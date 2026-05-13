import SwiftUI
import MessageUI
import UniformTypeIdentifiers

// MARK: - Flow state

enum ExtractorState {
    case idle
    case loading(String)
    case chooseSource(PubMedResult)
    // Reachable once Full Text is re-enabled (server proxy). The PDF picker,
    // `handlePickedPDF`, and `PDFTextExtractor` exist for this path.
    case needsPDF(PubMedResult)
    case review(ExtractedMetadata)
    case error(String)
}

// MARK: - Main view

struct ExtractorView: View {
    @AppStorage("extractorEnabled") private var extractorEnabled = false
    @State private var downloader = ExtractorPackDownloader()

    var body: some View {
        NavigationStack {
            Group {
                if !DeviceCapability.supportsOnDeviceAI {
                    unsupportedDeviceCard
                } else if extractorEnabled {
                    ExtractorActiveView()
                } else {
                    switch downloader.state {
                    case .downloading:
                        downloadingView
                    case .failed(let msg):
                        downloadFailedView(message: msg)
                    default:
                        optInCard
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Extractor")
            .onChange(of: downloader.state) { _, newValue in
                if case .ready = newValue { extractorEnabled = true }
            }
        }
    }

    // MARK: - Opt-in card

    private var optInCard: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "sparkles.rectangle.stack")
                .font(.system(size: 56))
                .foregroundColor(Color(hex: "#404f7c"))

            Text("Optional: on-device AI")
                .font(.title3.bold())

            Text("Enable the on-device AI extractor to scan papers you find interesting and contribute to MCA — a shared resource for the microbiology and microbiome communities.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Text("Runs entirely on your device with Gemma 4 by Google. Nothing leaves your phone unless you tap Send in Mail.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                Task { await downloader.download() }
            } label: {
                Label("Enable AI Extractor (3.6 GB)", systemImage: "arrow.down.circle")
                    .frame(minWidth: 240, minHeight: 24)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
    }

    private var downloadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView(value: downloader.progress)
                .progressViewStyle(.linear)
                .padding(.horizontal, 40)
            Text("Downloading Gemma 4\u{2026} \(Int(downloader.progress * 100))%")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if !downloader.currentFile.isEmpty {
                Text(downloader.currentFile)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#888888"))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.horizontal, 40)
            }
            Spacer()
        }
    }

    private func downloadFailedView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text("Download failed")
                .font(.subheadline.bold())
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button("Try Again") {
                Task { await downloader.download() }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }

    private var unsupportedDeviceCard: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "iphone.slash")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Not available on this device")
                .font(.subheadline.bold())
            Text(DeviceCapability.unsupportedDeviceMessage)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: - Active extractor (after opt-in)

struct ExtractorActiveView: View {
    @AppStorage("extractorEnabled") private var extractorEnabled = false
    @State private var input = ""
    @State private var state: ExtractorState = .idle
    @State private var submissions: [SubmittedPMID] = []
    @State private var pendingResult: PubMedResult?
    @State private var showDocumentPicker = false
    @State private var selectedSubmission: SubmittedPMID?
    private let llm: any LLMService = GemmaLLMService.shared
    @FocusState private var isInputFocused: Bool

    private var appVersion: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "—"
    }

    var body: some View {
        VStack(spacing: 16) {
            inputBar

            Group {
                switch state {
                case .idle:
                    if submissions.isEmpty { emptyStateView } else { entriesListView }
                case .loading(let msg):
                    loadingView(msg)
                case .chooseSource(let result):
                    chooseSourceView(result: result)
                case .needsPDF(let result):
                    needsPDFView(result: result)
                case .review(let metadata):
                    ReviewScreen(
                        metadata: metadata,
                        appVersion: appVersion,
                        onSubmitted: { submission in
                            SubmissionCache.save(submission)
                            submissions = SubmissionCache.loadAll()
                            input = ""
                            state = .idle
                        },
                        onCancel: { state = .idle }
                    )
                case .error(let msg):
                    errorView(msg)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        extractorEnabled = false
                    } label: {
                        Label("Free up 3.6 GB (remove on-device AI)", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            PDFDocumentPicker { url in
                showDocumentPicker = false
                handlePickedPDF(url: url)
            }
        }
        .sheet(item: $selectedSubmission) { submission in
            SavedSubmissionSheet(
                submission: submission,
                appVersion: appVersion,
                onShareCompleted: { updated in
                    // Replace the existing entry with the new sent record
                    SubmissionCache.delete(id: submission.id)
                    SubmissionCache.save(updated)
                    submissions = SubmissionCache.loadAll()
                    selectedSubmission = nil
                },
                onDismiss: { selectedSubmission = nil }
            )
        }
        .task { submissions = SubmissionCache.loadAll() }
    }

    // MARK: - Input bar

    private var inputBar: some View {
        HStack {
            TextField("PMID", text: $input)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .focused($isInputFocused)
                .onSubmit { startExtraction() }
                .overlay(alignment: .trailing) {
                    if !input.isEmpty {
                        Button {
                            input = ""
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
                        Button("Done") { isInputFocused = false }
                    }
                }

            Button("Extract") { startExtraction() }
                .buttonStyle(.borderedProminent)
                .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
        }
        .padding(.horizontal)
    }

    private var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    // MARK: - Flow steps

    private func startExtraction() {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isInputFocused = false

        Task {
            state = .loading("Fetching from PubMed\u{2026}")
            do {
                let result = try await PubMedService.fetch(query: trimmed)
                state = .chooseSource(result)
            } catch let error as PubMedError {
                switch error {
                case .noAbstract:
                    let partial = PubMedResult(
                        pmid: trimmed.allSatisfy(\.isNumber) ? trimmed : "",
                        title: "",
                        abstract: ""
                    )
                    state = .chooseSource(partial)
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

    private func chooseSourceView(result: PubMedResult) -> some View {
        VStack(spacing: 20) {
            Spacer()

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
                    extractFromText(result: result, text: result.abstract)
                } label: {
                    Label("Abstract", systemImage: "doc.plaintext")
                        .frame(minWidth: 120, minHeight: 20)
                }
                .buttonStyle(.borderedProminent)
                .disabled(result.abstract.isEmpty)

                // Full Text is disabled in v1.2.0 — on-device Gemma 4 cannot
                // hold a multi-thousand-token prefill on iPhone 15 Pro without
                // jetsam. Re-enables when the server-side Claude proxy lands.
                Button {
                    extractFromFullText(result: result)
                } label: {
                    Label("Full Text", systemImage: "doc.richtext")
                        .frame(minWidth: 120, minHeight: 20)
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }

            Text("Full text extraction is on the way.")
                .font(.caption2)
                .foregroundColor(Color(hex: "#888888"))

            Spacer()
        }
    }

    private func extractFromText(result: PubMedResult, text: String) {
        Task {
            state = .loading("Extracting on device\u{2026}")
            do {
                var metadata = try await llm.extractMetadata(text: text, knownPMID: result.pmid)
                if metadata.title.isEmpty, !result.title.isEmpty {
                    metadata = ExtractedMetadata(
                        pmid: metadata.pmid.isEmpty ? result.pmid : metadata.pmid,
                        doi: metadata.doi,
                        title: result.title,
                        abstract: metadata.abstract.isEmpty ? result.abstract : metadata.abstract,
                        candidateTaxa: metadata.candidateTaxa
                    )
                }
                state = .review(metadata)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    private func extractFromFullText(result: PubMedResult) {
        Task {
            state = .loading("Checking PMC for full text\u{2026}")
            if let fullText = await PubMedService.fetchFullText(pmid: result.pmid) {
                extractFromText(result: result, text: fullText)
            } else {
                state = .needsPDF(result)
            }
        }
    }

    private func needsPDFView(result: PubMedResult) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "lock.doc")
                .font(.largeTitle)
                .foregroundColor(.orange)

            Text("Full text is not available on PMC.\nPlease upload the PDF.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button {
                    pendingResult = result
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
            Spacer()
        }
    }

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

        let result = pendingResult ?? PubMedResult(pmid: input, title: "", abstract: "")
        extractFromText(result: result, text: pdfText)
    }

    // MARK: - Side views

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("Enter a PubMed ID", systemImage: "doc.text.magnifyingglass")
        } description: {
            Text("MCA fetches the paper, extracts metadata on-device, and lets you email a quick reference to our curation team.")
        }
    }

    private func loadingView(_ message: String) -> some View {
        VStack(spacing: 12) {
            ProgressView()
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again") { state = .idle }
                .buttonStyle(.bordered)
        }
    }

    private var entriesListView: some View {
        List {
            Section {
                ForEach(submissions) { submission in
                    Button {
                        selectedSubmission = submission
                    } label: {
                        submissionRow(submission)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        SubmissionCache.delete(id: submissions[index].id)
                    }
                    submissions = SubmissionCache.loadAll()
                }
            } header: {
                Text("YOUR ENTRIES")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "#888888"))
                    .tracking(1.5)
            }
        }
        .listStyle(.insetGrouped)
    }

    private func submissionRow(_ submission: SubmittedPMID) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text("PMID \(submission.pmid)")
                    .font(.subheadline).bold()
                    .foregroundColor(.primary)
                Spacer()
                if submission.status == .sent {
                    Text(statusLabel(submission.status))
                        .font(.caption2)
                        .foregroundColor(statusColor(submission.status))
                }
            }
            if !submission.note.isEmpty {
                Text(submission.note)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Text(submission.sentAt, style: .date)
                .font(.caption2)
                .foregroundColor(Color(hex: "#888888"))
        }
        .padding(.vertical, 4)
    }

    private func statusLabel(_ status: SubmittedPMID.Status) -> String {
        switch status {
        case .sent:      return "SENT"
        case .cancelled: return "CANCELLED"
        case .saved:     return "DRAFT"
        }
    }

    private func statusColor(_ status: SubmittedPMID.Status) -> Color {
        switch status {
        case .sent:      return Color(hex: "#166534")
        case .cancelled: return Color(hex: "#6b7280")
        case .saved:     return Color(hex: "#404f7c")
        }
    }
}

// MARK: - Review screen (Phase 4)

struct ReviewScreen: View {
    let metadata: ExtractedMetadata
    let appVersion: String
    let onSubmitted: (SubmittedPMID) -> Void
    let onCancel: () -> Void

    @State private var pmid: String
    @State private var note: String = ""
    @State private var showMail = false
    @State private var mailUnavailableAlert = false

    init(metadata: ExtractedMetadata,
         appVersion: String,
         onSubmitted: @escaping (SubmittedPMID) -> Void,
         onCancel: @escaping () -> Void) {
        self.metadata = metadata
        self.appVersion = appVersion
        self.onSubmitted = onSubmitted
        self.onCancel = onCancel
        _pmid = State(initialValue: metadata.pmid)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Confirm this is the paper you want to suggest. Only the PMID and your optional note are sent — the title, abstract, and AI-detected taxa never leave your phone.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Divider()

                section("PMID") {
                    TextField("PMID", text: $pmid)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                }

                if let doi = metadata.doi {
                    section("DOI") {
                        Text(doi)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textSelection(.enabled)
                    }
                }

                if !metadata.title.isEmpty {
                    section("TITLE (on-device only)") {
                        Text(metadata.title)
                            .font(.subheadline)
                    }
                }

                if !metadata.abstract.isEmpty {
                    section("ABSTRACT (on-device only)") {
                        Text(metadata.abstract)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                if !metadata.candidateTaxa.isEmpty {
                    section("CANDIDATE TAXA (on-device only)") {
                        WrappingChips(items: metadata.candidateTaxa)
                    }
                }

                section("YOUR NOTE (optional)") {
                    TextField("Why is this paper a good fit?", text: $note, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...5)
                        .onChange(of: note) { _, newValue in
                            if newValue.count > 280 { note = String(newValue.prefix(280)) }
                        }
                    Text("\(note.count) / 280")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "#888888"))
                }

                HStack(spacing: 12) {
                    Button("Cancel") { onCancel() }
                        .buttonStyle(.bordered)

                    Button("Save") { saveDraft() }
                        .buttonStyle(.bordered)
                        .disabled(!isPMIDValid)

                    Button {
                        share()
                    } label: {
                        Label("Share", systemImage: "envelope")
                            .frame(maxWidth: .infinity, minHeight: 24)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isPMIDValid)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .sheet(isPresented: $showMail) {
            MailComposer(
                pmid: pmid,
                note: note,
                appVersion: appVersion,
                isPresented: $showMail,
                onResult: handleMailResult
            )
        }
        .alert("Mail not set up", isPresented: $mailUnavailableAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Add a mail account in iOS Settings, or copy the PMID and email it manually to bioinformatics@ucalgary.ca.")
        }
    }

    private var isPMIDValid: Bool {
        let trimmed = pmid.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 6, trimmed.count <= 9 else { return false }
        return trimmed.allSatisfy(\.isNumber)
    }

    private func share() {
        guard MailAvailability.canSendMail else {
            mailUnavailableAlert = true
            return
        }
        showMail = true
    }

    private func saveDraft() {
        let trimmedPMID = pmid.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let submission = SubmittedPMID(
            id: UUID(),
            pmid: trimmedPMID,
            note: trimmedNote,
            sentAt: Date(),
            status: .saved
        )
        onSubmitted(submission)
    }

    private func handleMailResult(_ result: MFMailComposeResult) {
        let trimmedPMID = pmid.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let status: SubmittedPMID.Status
        switch result {
        case .sent:      status = .sent
        case .saved:     status = .saved
        case .cancelled, .failed: status = .cancelled
        @unknown default: status = .cancelled
        }
        let submission = SubmittedPMID(
            id: UUID(),
            pmid: trimmedPMID,
            note: trimmedNote,
            sentAt: Date(),
            status: status
        )
        // Only persist user-completed actions
        if status == .sent || status == .saved {
            onSubmitted(submission)
        } else {
            onCancel()
        }
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(Color(hex: "#888888"))
                .tracking(1.5)
            content()
            Divider()
        }
    }
}

// MARK: - Wrapping chips

struct WrappingChips: View {
    let items: [String]
    var body: some View {
        FlowLayout(spacing: 6) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#f0f4ff"))
                    .foregroundColor(Color(hex: "#404f7c"))
                    .clipShape(Capsule())
            }
        }
    }
}

// MARK: - Saved submission sheet (re-open a saved draft to share)

struct SavedSubmissionSheet: View {
    let submission: SubmittedPMID
    let appVersion: String
    let onShareCompleted: (SubmittedPMID) -> Void
    let onDismiss: () -> Void

    @State private var showMail = false
    @State private var mailUnavailableAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    fieldSection("PMID") {
                        Text(submission.pmid)
                            .font(.body)
                            .textSelection(.enabled)
                    }

                    if !submission.note.isEmpty {
                        fieldSection("NOTE") {
                            Text(submission.note)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .textSelection(.enabled)
                        }
                    }

                    fieldSection("STATUS") {
                        Text(statusLabel)
                            .font(.caption2.bold())
                            .foregroundColor(statusColor)
                    }

                    fieldSection("DATE") {
                        Text(submission.sentAt, style: .date)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    if submission.status == .saved {
                        Button {
                            share()
                        } label: {
                            Label("Share", systemImage: "envelope")
                                .frame(maxWidth: .infinity, minHeight: 24)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
            .navigationTitle("Submission")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { onDismiss() }
                }
            }
            .sheet(isPresented: $showMail) {
                MailComposer(
                    pmid: submission.pmid,
                    note: submission.note,
                    appVersion: appVersion,
                    isPresented: $showMail,
                    onResult: handleMailResult
                )
            }
            .alert("Mail not set up", isPresented: $mailUnavailableAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Add a mail account in iOS Settings, or copy the PMID and email it manually to bioinformatics@ucalgary.ca.")
            }
        }
    }

    private var statusLabel: String {
        switch submission.status {
        case .sent:      return "SENT"
        case .cancelled: return "CANCELLED"
        case .saved:     return "DRAFT"
        }
    }

    private var statusColor: Color {
        switch submission.status {
        case .sent:      return Color(hex: "#166534")
        case .cancelled: return Color(hex: "#6b7280")
        case .saved:     return Color(hex: "#404f7c")
        }
    }

    private func share() {
        guard MailAvailability.canSendMail else {
            mailUnavailableAlert = true
            return
        }
        showMail = true
    }

    private func handleMailResult(_ result: MFMailComposeResult) {
        let status: SubmittedPMID.Status
        switch result {
        case .sent:      status = .sent
        case .saved:     status = .saved
        case .cancelled, .failed: status = .cancelled
        @unknown default: status = .cancelled
        }
        guard status == .sent else { return }
        let updated = SubmittedPMID(
            id: UUID(),
            pmid: submission.pmid,
            note: submission.note,
            sentAt: Date(),
            status: status
        )
        onShareCompleted(updated)
    }

    @ViewBuilder
    private func fieldSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(Color(hex: "#888888"))
                .tracking(1.5)
            content()
            Divider()
        }
    }
}

// MARK: - PDF picker

struct PDFDocumentPicker: UIViewControllerRepresentable {
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
