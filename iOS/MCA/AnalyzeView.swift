import SwiftUI
import UniformTypeIdentifiers

struct AnalyzeView: View {
    var onKeyCleared: () -> Void

    @State private var input = ""
    @State private var state: AnalyzeState = .idle
    @State private var isDemo = false
    @State private var showApiKeySheet = false
    @State private var showDocumentPicker = false
    @State private var pendingPubMedResult: PubMedResult?
    @State private var cachedExtractions: [CachedExtraction] = []
    @State private var selectedExtraction: CachedExtraction?
    @State private var sourceType = "abstract"
    @State private var showCacheHitAlert = false
    @State private var cacheHitExtraction: CachedExtraction?
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Input area
                HStack {
                    TextField("PMID", text: $input)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                        .focused($isInputFocused)
                        .onSubmit { analyze() }
                        .overlay(alignment: .trailing) {
                            if !input.isEmpty {
                                Button {
                                    input = ""
                                    isDemo = false
                                    state = .idle
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.trailing, 6)
                            }
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isInputFocused = false
                                }
                            }
                        }

                    Button {
                        showApiKeySheet = true
                    } label: {
                        Image(systemName: "key")
                    }
                    .buttonStyle(.bordered)

                    Button("Extract") { analyze() }
                        .buttonStyle(.borderedProminent)
                        .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                }
                .padding(.horizontal)

                // Content area
                Group {
                    switch state {
                    case .idle:
                        if cachedExtractions.isEmpty {
                            ContentUnavailableView {
                                Label("Enter a PMID", systemImage: "doc.text.magnifyingglass")
                            } description: {
                                Text("The app will fetch the paper from PubMed and extract Taxon Passports using Claude.")
                            } actions: {
                                HStack(spacing: 12) {
                                    Button {
                                        showApiKeySheet = true
                                    } label: {
                                        Label("API Key", systemImage: "key")
                                            .frame(minHeight: 20)
                                    }
                                    .buttonStyle(.bordered)
                                    Button {
                                        isDemo = true
                                        state = .result(ExtractedPassport.demoArray)
                                    } label: {
                                        Label("Try Demo", systemImage: "play.circle")
                                            .frame(minHeight: 20)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        } else {
                            recentExtractionsView
                        }

                    case .loading(let message):
                        VStack(spacing: 12) {
                            ProgressView()
                            Text(message)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxHeight: .infinity)

                    case .chooseSource(let result):
                        chooseSourceView(result: result)

                    case .needsPDF(let result):
                        needsPDFView(result: result)

                    case .result(let passports):
                        PassportResultView(passports: passports, isDemo: isDemo)

                    case .error(let message):
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text(message)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            if message.contains("API key") {
                                Button {
                                    showApiKeySheet = true
                                } label: {
                                    Label("API Key", systemImage: "key")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Passport Extractor")
            .navigationDestination(item: $selectedExtraction) { extraction in
                PassportResultView(passports: extraction.passports, isDemo: false)
                    .navigationTitle("Cached Result")
            }
            .task {
                cachedExtractions = ExtractionCache.loadAll()
            }
            .onChange(of: stateIsIdle) { _, isIdle in
                if isIdle {
                    cachedExtractions = ExtractionCache.loadAll()
                }
            }
            .sheet(isPresented: $showApiKeySheet) {
                NavigationStack {
                    apiKeySettingsView
                }
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker { url in
                    showDocumentPicker = false
                    handlePickedPDF(url: url)
                }
            }
            .alert("Previous Result Found", isPresented: $showCacheHitAlert) {
                Button("View Cached") {
                    if let cached = cacheHitExtraction {
                        isDemo = false
                        state = .result(cached.passports)
                    }
                }
                Button("Extract Again") {
                    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
                    fetchAndExtract(pmid: trimmed)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This PMID was previously extracted. View the cached result or extract again?")
            }
        }
    }

    // MARK: - Loading check

    private var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    private var stateIsIdle: Bool {
        if case .idle = state { return true }
        return false
    }

    private func saveExtraction(passports: [ExtractedPassport], pmid: String, title: String) {
        guard !isDemo, !passports.isEmpty else { return }
        let cached = CachedExtraction(
            id: UUID(),
            pmid: pmid,
            paperTitle: title,
            sourceType: sourceType,
            extractionDate: Date(),
            taxonCount: passports.count,
            passports: passports
        )
        ExtractionCache.save(cached)
        cachedExtractions = ExtractionCache.loadAll()
    }

    // MARK: - Step 1: Fetch PubMed → show source choice

    private func analyze() {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isInputFocused = false
        isDemo = false

        // Check cache first
        if let cached = ExtractionCache.find(pmid: trimmed) {
            cacheHitExtraction = cached
            showCacheHitAlert = true
            return
        }

        fetchAndExtract(pmid: trimmed)
    }

    private func fetchAndExtract(pmid: String) {
        Task {
            state = .loading("Fetching from PubMed…")
            do {
                let result = try await PubMedService.fetch(query: pmid)
                state = .chooseSource(result)
            } catch let error as PubMedError {
                switch error {
                case .noAbstract:
                    let partialResult = PubMedResult(pmid: pmid.allSatisfy(\.isNumber) ? pmid : "", title: "", abstract: "")
                    state = .chooseSource(partialResult)
                case .notFound:
                    state = .error("Paper not found on PubMed.")
                case .networkError(let msg):
                    state = .error(msg)
                }
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    // MARK: - Step 2: Choose source

    private func chooseSourceView(result: PubMedResult) -> some View {
        VStack(spacing: 20) {
            if !result.title.isEmpty {
                Text(result.title)
                    .font(.subheadline).bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Text("Choose extraction source:")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Button {
                    extractFromAbstract(result: result)
                } label: {
                    Label("Abstract", systemImage: "doc.plaintext")
                        .frame(minWidth: 120, minHeight: 20)
                }
                .buttonStyle(.bordered)
                .disabled(result.abstract.isEmpty)

                Button {
                    extractFromFullText(result: result)
                } label: {
                    Label("Full Text", systemImage: "doc.richtext")
                        .frame(minWidth: 120, minHeight: 20)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - Step 2a: Abstract → extract

    private func extractFromAbstract(result: PubMedResult) {
        sourceType = "abstract"
        Task {
            state = .loading("Extracting with Claude…")
            do {
                let passports = try await ClaudeService.extract(
                    title: result.title,
                    pmid: result.pmid,
                    abstract: result.abstract
                )
                state = .result(passports)
                saveExtraction(passports: passports, pmid: result.pmid, title: result.title)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    // MARK: - Step 2b: Full Text → check PMC → extract or ask PDF

    private func extractFromFullText(result: PubMedResult) {
        sourceType = "fulltext"
        Task {
            state = .loading("Checking PMC for full text…")
            if let fullText = await PubMedService.fetchFullText(pmid: result.pmid) {
                // 2b.1: PMC has full text → extract
                state = .loading("Extracting with Claude…")
                do {
                    let passports = try await ClaudeService.extract(
                        title: result.title,
                        pmid: result.pmid,
                        abstract: fullText
                    )
                    state = .result(passports)
                    saveExtraction(passports: passports, pmid: result.pmid, title: result.title)
                } catch {
                    state = .error(error.localizedDescription)
                }
            } else {
                // 2b.2: Not on PMC → ask user for PDF
                state = .needsPDF(result)
            }
        }
    }

    // MARK: - Step 2b.2: Need PDF

    private func needsPDFView(result: PubMedResult) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.doc")
                .font(.largeTitle)
                .foregroundColor(.orange)

            Text("Full text is not available on PMC.\nPlease upload the PDF.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button {
                    pendingPubMedResult = result
                    showDocumentPicker = true
                } label: {
                    Label("Upload PDF", systemImage: "doc.badge.plus")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    state = .chooseSource(result)
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - Step 2b.2.1: Handle picked PDF

    private func handlePickedPDF(url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            state = .error("Could not access the PDF file.")
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }

        let pdfText = PDFTextExtractor.extract(from: url)
        guard !pdfText.isEmpty else {
            state = .error("Could not extract text from PDF.")
            return
        }

        let result = pendingPubMedResult ?? PubMedResult(pmid: input, title: "", abstract: "")
        sourceType = "pdf"
        Task {
            state = .loading("Extracting from PDF with Claude…")
            do {
                let pmid = result.pmid.isEmpty ? input : result.pmid
                let title = result.title.isEmpty ? input : result.title
                let passports = try await ClaudeService.extract(
                    title: title,
                    pmid: pmid,
                    abstract: pdfText
                )
                state = .result(passports)
                saveExtraction(passports: passports, pmid: pmid, title: title)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    // MARK: - Recent Extractions

    private var recentExtractionsView: some View {
        List {
            Section {
                ForEach(cachedExtractions) { extraction in
                    Button {
                        selectedExtraction = extraction
                    } label: {
                        recentExtractionRow(extraction)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        ExtractionCache.delete(id: cachedExtractions[index].id)
                    }
                    cachedExtractions = ExtractionCache.loadAll()
                }
            } header: {
                Text("RECENT EXTRACTIONS")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "#888888"))
                    .tracking(1.5)
            }
        }
        .listStyle(.insetGrouped)
    }

    private func recentExtractionRow(_ extraction: CachedExtraction) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(extraction.paperTitle.isEmpty ? "PMID \(extraction.pmid)" : extraction.paperTitle)
                .font(.subheadline).bold()
                .foregroundColor(.primary)
                .lineLimit(2)

            HStack(spacing: 8) {
                Label("\(extraction.taxonCount) taxa", systemImage: "leaf")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("·")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(extraction.sourceType.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(extraction.extractionDate, style: .date)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#888888"))
            }

            if !extraction.pmid.isEmpty {
                Text("PMID \(extraction.pmid)")
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#007bff"))
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - API Key Settings Sheet

    private var apiKeySettingsView: some View {
        ApiKeySettingsContent(onKeyCleared: onKeyCleared, dismiss: { showApiKeySheet = false })
    }
}

// MARK: - Analyze State

enum AnalyzeState {
    case idle
    case loading(String)
    case chooseSource(PubMedResult)
    case needsPDF(PubMedResult)
    case result([ExtractedPassport])
    case error(String)
}

// MARK: - API Key Settings (Sheet)

private struct ApiKeySettingsContent: View {
    var onKeyCleared: () -> Void
    var dismiss: () -> Void

    @State private var newKey = ""
    @State private var hasExistingKey = KeychainHelper.load(account: KeychainHelper.apiKeyAccount) != nil

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            if hasExistingKey {
                Label("API key is saved", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }

            SecureField("New API key", text: $newKey)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal)

            Button("Update Key") {
                let trimmed = newKey.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                KeychainHelper.save(trimmed, account: KeychainHelper.apiKeyAccount)
                hasExistingKey = true
                newKey = ""
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .disabled(newKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            Button("Delete Key", role: .destructive) {
                KeychainHelper.delete(account: KeychainHelper.apiKeyAccount)
                hasExistingKey = false
                dismiss()
                onKeyCleared()
            }

            Spacer()

            Text("Estimated cost per extraction:\n~$0.01 for abstract, ~$0.10 for full text (USD).")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .navigationTitle("Claude API Key")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }
}

// MARK: - Document Picker

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onPick: onPick) }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (URL) -> Void
        init(onPick: @escaping (URL) -> Void) { self.onPick = onPick }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPick(url)
        }
    }
}
