import SwiftUI

// MARK: - Result Models

struct PathwayModeResult {
    let pathway: PathwayInfo
    let pathwayId: String
    let taxa: [PathwayTaxonItem]
    let relatedDiseases: [DiseaseItem]
}

struct TaxonModeResult {
    let passportId: String
    let name: String
    let totalPathways: Int
    let pathwaysViaDiseases: [PathwayLinkItem]
    let pathwaysViaCompounds: [PathwayLinkItem]
    let drugClasses: [DrugClassItem]
    let cooccurring: [CooccurringItem]
}

struct DiseaseModeResult {
    let diseaseId: String
    let diseaseName: String
    let infClass: InfClassInfo?
    let pathways: [PathwayCountItem]
    let taxa: [PathwayTaxonItem]
}

struct PathwayTaxonItem: Identifiable {
    let passportId: String
    let name: String
    let taxonRank: String
    let isPathobiont: String
    let roles: [String]
    let viaDiseases: [DiseaseItem]
    let viaCompounds: [CompoundItem]
    let dbId: Int64?
    var id: String { passportId }
}

struct PathwayLinkItem: Identifiable {
    let pathwayId: String
    let name: String
    let category: String
    let taxonCount: Int
    let linkingDiseases: [DiseaseItem]
    let linkingCompounds: [CompoundItem]
    var id: String { pathwayId }
}

struct PathwayCountItem: Identifiable {
    let pathwayId: String
    let name: String
    let category: String
    let taxonCount: Int
    var id: String { pathwayId }
}

struct DiseaseItem: Identifiable {
    let diseaseId: String
    let label: String
    var id: String { diseaseId }
}

struct CompoundItem: Identifiable {
    let compoundId: String
    let name: String
    var id: String { compoundId }
}

struct DrugClassItem: Identifiable {
    let drugId: String
    let drugName: String
    let targetClass: String
    let targetFamily: String
    var id: String { drugId }
}

struct CooccurringItem: Identifiable {
    let passportId: String
    let name: String
    let isPathobiont: String
    let sharedPathways: Int
    let dbId: Int64?
    var id: String { passportId }
}

// MARK: - Suggestion

enum PathwaySuggestion: Identifiable {
    case pathway(id: String, name: String, category: String, taxonCount: Int)
    case taxon(passportId: String, name: String, hasPathways: Bool)
    case disease(id: String, name: String)

    var id: String {
        switch self {
        case .pathway(let id, _, _, _): return "pw-\(id)"
        case .taxon(let pid, _, _): return "tx-\(pid)"
        case .disease(let id, _): return "ds-\(id)"
        }
    }
}

// MARK: - View Model

@Observable
final class PathwaySearchViewModel {
    var searchText = ""
    var suggestions: [PathwaySuggestion] = []
    var showSuggestions = false
    private var suppressSuggestions = false

    var pathwayResult: PathwayModeResult?
    var taxonResult: TaxonModeResult?
    var diseaseResult: DiseaseModeResult?

    var hasResult: Bool {
        pathwayResult != nil || taxonResult != nil || diseaseResult != nil
    }

    private(set) var indexLoaded = false
    private var index: PathwayIndex?
    private var passportDB: [String: (dbId: Int64, name: String, rank: String, pathobiont: String, roles: [String])] = [:]

    func loadIfNeeded() {
        guard !indexLoaded else { return }
        index = PathwayIndex.load()
        guard index != nil else { return }
        indexLoaded = true

        let allPassports = DatabaseManager.shared.fetchAllPassports()
        for p in allPassports {
            let roles = DatabaseManager.shared.fetchRoles(passportId: p.id)
            passportDB[p.passportId] = (p.id, p.preferredName, p.taxonRank, p.isPathobiont, roles)
        }
    }

    func updateSuggestions() {
        if suppressSuggestions {
            suppressSuggestions = false
            return
        }
        guard let index else { suggestions = []; return }
        let q = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        guard q.count >= 2 else {
            suggestions = []
            showSuggestions = false
            return
        }

        var results: [PathwaySuggestion] = []
        let limit = 8

        var count = 0
        for (pid, passports) in index.pathwayToPassports {
            guard count < limit else { break }
            let info = index.pathwayInfo(for: pid)
            if info.name.lowercased().contains(q) || pid.lowercased().contains(q) {
                results.append(.pathway(id: pid, name: info.name, category: info.category, taxonCount: passports.count))
                count += 1
            }
        }

        count = 0
        for (pid, name) in index.passportNames {
            guard count < limit else { break }
            if name.lowercased().contains(q) || pid.lowercased().contains(q) {
                results.append(.taxon(passportId: pid, name: name, hasPathways: index.passportToPathways[pid] != nil))
                count += 1
            }
        }

        count = 0
        for (did, name) in index.diseaseNames {
            guard count < limit else { break }
            if name.lowercased().contains(q) || did.lowercased().contains(q) {
                results.append(.disease(id: did, name: name))
                count += 1
            }
        }

        suggestions = results
        showSuggestions = !results.isEmpty
    }

    func selectSuggestion(_ suggestion: PathwaySuggestion) {
        showSuggestions = false
        suggestions = []
        suppressSuggestions = true
        switch suggestion {
        case .pathway(let id, _, _, _):
            searchPathway(id: id)
        case .taxon(let passportId, _, _):
            searchTaxon(id: passportId)
        case .disease(let id, _):
            searchDisease(id: id)
        }
    }

    func clearResults() {
        pathwayResult = nil
        taxonResult = nil
        diseaseResult = nil
    }

    // MARK: - Pathway Mode (Q3)

    func searchPathway(id: String) {
        guard let index else { return }
        clearResults()

        let info = index.pathwayInfo(for: id)
        let passportIds = index.pathwayToPassports[id] ?? []

        let taxa = passportIds.map { pid -> PathwayTaxonItem in
            let kegg = index.passportKegg[pid]
            let db = passportDB[pid]

            var viaDiseases: [DiseaseItem] = []
            for (hid, hlabel) in kegg?.diseases ?? [:] {
                let hpaths = (index.diseaseToPathways[hid] ?? []) + (index.diseaseToNt[hid] ?? [])
                if hpaths.contains(id) {
                    let label = hlabel.isEmpty ? (index.diseaseNames[hid] ?? hid) : hlabel
                    viaDiseases.append(DiseaseItem(diseaseId: hid, label: label))
                }
            }

            var viaCompounds: [CompoundItem] = []
            for (cid, cname) in kegg?.compounds ?? [:] {
                let cpaths = index.compoundToPathways[cid] ?? []
                if cpaths.contains(id) {
                    let name = cname.isEmpty ? (index.compoundNames[cid] ?? cid) : cname
                    viaCompounds.append(CompoundItem(compoundId: cid, name: name))
                }
            }

            return PathwayTaxonItem(
                passportId: pid,
                name: db?.name ?? (index.passportNames[pid] ?? pid),
                taxonRank: db?.rank ?? "",
                isPathobiont: db?.pathobiont ?? "unknown",
                roles: db?.roles ?? [],
                viaDiseases: viaDiseases,
                viaCompounds: viaCompounds,
                dbId: db?.dbId
            )
        }

        let mcaDiseaseIds: Set<String> = {
            var ids = Set<String>()
            for (_, kegg) in index.passportKegg {
                ids.formUnion(kegg.diseases.keys)
            }
            return ids
        }()

        var seenDiseases = Set<String>()
        var relatedDiseases: [DiseaseItem] = []
        for hid in (index.pathwayToDiseases[id] ?? []) + (index.ntToDiseases[id] ?? []) {
            guard !seenDiseases.contains(hid), mcaDiseaseIds.contains(hid) else { continue }
            seenDiseases.insert(hid)
            relatedDiseases.append(DiseaseItem(diseaseId: hid, label: index.diseaseNames[hid] ?? hid))
        }

        pathwayResult = PathwayModeResult(
            pathway: info, pathwayId: id, taxa: taxa, relatedDiseases: relatedDiseases
        )
        suppressSuggestions = true
        searchText = ""
    }

    // MARK: - Taxon Mode (Q1 + Q6)

    func searchTaxon(id: String) {
        guard let index else { return }
        clearResults()

        let kegg = index.passportKegg[id]
        let paths = index.passportToPathways[id] ?? []
        let cooc = index.passportCooccurrence[id] ?? [:]

        var viaDiseases: [PathwayLinkItem] = []
        var viaCompounds: [PathwayLinkItem] = []

        for pid in paths {
            let info = index.pathwayInfo(for: pid)
            let tc = index.taxonCount(for: pid)

            var linkingDiseases: [DiseaseItem] = []
            for (hid, hlabel) in kegg?.diseases ?? [:] {
                let hpaths = (index.diseaseToPathways[hid] ?? []) + (index.diseaseToNt[hid] ?? [])
                if hpaths.contains(pid) {
                    let label = hlabel.isEmpty ? (index.diseaseNames[hid] ?? hid) : hlabel
                    linkingDiseases.append(DiseaseItem(diseaseId: hid, label: label))
                }
            }

            var linkingCompounds: [CompoundItem] = []
            for (cid, cname) in kegg?.compounds ?? [:] {
                let cpaths = index.compoundToPathways[cid] ?? []
                if cpaths.contains(pid) {
                    let name = cname.isEmpty ? (index.compoundNames[cid] ?? cid) : cname
                    linkingCompounds.append(CompoundItem(compoundId: cid, name: name))
                }
            }

            let item = PathwayLinkItem(
                pathwayId: pid, name: info.name, category: info.category,
                taxonCount: tc, linkingDiseases: linkingDiseases, linkingCompounds: linkingCompounds
            )
            if !linkingDiseases.isEmpty { viaDiseases.append(item) }
            if !linkingCompounds.isEmpty { viaCompounds.append(item) }
        }

        var drugClasses: [DrugClassItem] = []
        for (did, dname) in kegg?.drugs ?? [:] {
            if let dc = index.drugClass[did] {
                let name = dname.isEmpty ? (index.drugNames[did] ?? did) : dname
                drugClasses.append(DrugClassItem(
                    drugId: did, drugName: name,
                    targetClass: dc.targetClass, targetFamily: dc.targetFamily
                ))
            }
        }

        let sortedCooc = cooc.sorted { $0.value > $1.value }.prefix(20)
        let cooccurring = sortedCooc.map { (cpid, count) in
            let db = passportDB[cpid]
            return CooccurringItem(
                passportId: cpid,
                name: db?.name ?? (index.passportNames[cpid] ?? cpid),
                isPathobiont: db?.pathobiont ?? "unknown",
                sharedPathways: count,
                dbId: db?.dbId
            )
        }

        taxonResult = TaxonModeResult(
            passportId: id,
            name: index.passportNames[id] ?? id,
            totalPathways: paths.count,
            pathwaysViaDiseases: viaDiseases,
            pathwaysViaCompounds: viaCompounds,
            drugClasses: drugClasses,
            cooccurring: Array(cooccurring)
        )
        suppressSuggestions = true
        searchText = ""
    }

    // MARK: - Disease Mode (Q4)

    func searchDisease(id: String) {
        guard let index else { return }
        clearResults()

        let dname = index.diseaseNames[id] ?? id
        let inf = index.infClass[id]

        let pathIds = Array(Set((index.diseaseToPathways[id] ?? []) + (index.diseaseToNt[id] ?? [])))
        let pathways = pathIds.map { pid -> PathwayCountItem in
            let info = index.pathwayInfo(for: pid)
            return PathwayCountItem(
                pathwayId: pid, name: info.name,
                category: info.category, taxonCount: index.taxonCount(for: pid)
            )
        }

        var passportIds: [String] = []
        for (pid, kegg) in index.passportKegg {
            if kegg.diseases.keys.contains(id) {
                passportIds.append(pid)
            }
        }

        let taxa = passportIds.map { pid -> PathwayTaxonItem in
            let db = passportDB[pid]
            return PathwayTaxonItem(
                passportId: pid,
                name: db?.name ?? (index.passportNames[pid] ?? pid),
                taxonRank: db?.rank ?? "",
                isPathobiont: db?.pathobiont ?? "unknown",
                roles: db?.roles ?? [],
                viaDiseases: [], viaCompounds: [],
                dbId: db?.dbId
            )
        }

        diseaseResult = DiseaseModeResult(
            diseaseId: id, diseaseName: dname,
            infClass: inf, pathways: pathways, taxa: taxa
        )
        suppressSuggestions = true
        searchText = ""
    }
}

// MARK: - Main View

struct PathwaySearchView: View {
    @State private var vm = PathwaySearchViewModel()
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search pathways, taxa, or diseases...", text: $vm.searchText)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($isSearchFocused)
                        .onChange(of: vm.searchText) {
                            vm.updateSuggestions()
                        }
                        .onSubmit {
                            if let first = vm.suggestions.first {
                                vm.selectSuggestion(first)
                                isSearchFocused = false
                            }
                        }
                    if !vm.searchText.isEmpty {
                        Button {
                            vm.searchText = ""
                            vm.clearResults()
                            vm.suggestions = []
                            vm.showSuggestions = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                ZStack(alignment: .top) {
                    ScrollViewReader { proxy in
                        ScrollView {
                            Color.clear.frame(height: 0).id("scrollTop")
                            if let result = vm.pathwayResult {
                                pathwayResultView(result)
                            } else if let result = vm.taxonResult {
                                taxonResultView(result)
                            } else if let result = vm.diseaseResult {
                                diseaseResultView(result)
                            } else if !vm.indexLoaded {
                                ContentUnavailableView(
                                    "Index not found",
                                    systemImage: "exclamationmark.triangle",
                                    description: Text("kegg_pathway_index.json is not included in the app bundle.")
                            )
                        } else {
                            emptyStateView
                        }
                        }
                        .onChange(of: vm.pathwayResult?.pathwayId) { proxy.scrollTo("scrollTop", anchor: .top) }
                        .onChange(of: vm.taxonResult?.passportId) { proxy.scrollTo("scrollTop", anchor: .top) }
                        .onChange(of: vm.diseaseResult?.diseaseId) { proxy.scrollTo("scrollTop", anchor: .top) }
                    }

                    if vm.showSuggestions && !vm.suggestions.isEmpty {
                        suggestionsOverlay
                    }
                }
            }
            .navigationTitle("Advanced Search")
            .task { vm.loadIfNeeded() }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 60)
            Image(systemName: "arrow.triangle.branch")
                .font(.system(size: 40))
                .foregroundStyle(Color(hex: "#404f7c").opacity(0.5))
            Text("Explore KEGG Pathway Connections")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Search for pathways, taxa, or diseases to explore how MCA taxa connect through KEGG biological pathways.")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Suggestions Overlay

    private var suggestionsOverlay: some View {
        ScrollView {
            VStack(spacing: 0) {
                let pwSugg = vm.suggestions.filter { if case .pathway = $0 { return true }; return false }
                let txSugg = vm.suggestions.filter { if case .taxon = $0 { return true }; return false }
                let dsSugg = vm.suggestions.filter { if case .disease = $0 { return true }; return false }

                if !pwSugg.isEmpty { suggestionGroup("PATHWAYS", items: pwSugg) }
                if !txSugg.isEmpty { suggestionGroup("TAXA", items: txSugg) }
                if !dsSugg.isEmpty { suggestionGroup("DISEASES", items: dsSugg) }
            }
        }
        .frame(maxHeight: 360)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        .padding(.horizontal, 16)
    }

    private func suggestionGroup(_ title: String, items: [PathwaySuggestion]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption2.bold())
                .foregroundStyle(Color(hex: "#888888"))
                .tracking(1.5)
                .padding(.horizontal, 12)
                .padding(.top, 8)
                .padding(.bottom, 4)

            ForEach(items) { suggestion in
                Button {
                    vm.selectSuggestion(suggestion)
                    isSearchFocused = false
                } label: {
                    suggestionRow(suggestion)
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private func suggestionRow(_ suggestion: PathwaySuggestion) -> some View {
        switch suggestion {
        case .pathway(let id, let name, let category, let taxonCount):
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(name).font(.subheadline)
                    HStack(spacing: 4) {
                        Text(id).font(.caption2.monospaced()).foregroundStyle(.tertiary)
                        if !category.isEmpty {
                            Text("·").foregroundStyle(.tertiary)
                            Text(category).font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
                Text("\(taxonCount)")
                    .font(.caption2.bold())
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color(hex: "#404f7c"))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .padding(.horizontal, 12).padding(.vertical, 8)

        case .taxon(let passportId, let name, let hasPathways):
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(name).font(.subheadline).italic()
                    Text(passportId).font(.caption2.monospaced()).foregroundStyle(.tertiary)
                }
                Spacer()
                if hasPathways {
                    Image(systemName: "arrow.triangle.branch")
                        .font(.caption2)
                        .foregroundStyle(Color(hex: "#404f7c"))
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 8)

        case .disease(let id, let name):
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(name).font(.subheadline)
                    Text(id).font(.caption2.monospaced()).foregroundStyle(.tertiary)
                }
                Spacer()
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
        }
    }

    // MARK: - Pathway Mode Result

    private func pathwayResultView(_ result: PathwayModeResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(result.pathway.name)
                    .font(.title3.bold())
                HStack(spacing: 8) {
                    Text(result.pathwayId)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                    if !result.pathway.category.isEmpty {
                        categoryBadge(result.pathway.category)
                    }
                }
                if let sub = result.pathway.subcategory, !sub.isEmpty {
                    Text(sub)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            if !result.taxa.isEmpty {
                sectionHeader("LINKED TAXA (\(result.taxa.count))")
                ForEach(result.taxa) { taxon in
                    taxonCard(taxon)
                }
            }

            if !result.relatedDiseases.isEmpty {
                sectionHeader("RELATED DISEASES")
                FlowLayout(spacing: 6) {
                    ForEach(result.relatedDiseases) { disease in
                        Button {
                            vm.searchDisease(id: disease.diseaseId)
                        } label: {
                            diseaseBadge(disease.label, id: disease.diseaseId)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer().frame(height: 24)
        }
    }

    // MARK: - Taxon Mode Result

    private func taxonResultView(_ result: TaxonModeResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(result.name)
                    .font(.title3.bold().italic())
                HStack(spacing: 8) {
                    Text(result.passportId)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                    Text("\(result.totalPathways) pathways")
                        .font(.caption2.bold())
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color(hex: "#404f7c"))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            if !result.pathwaysViaDiseases.isEmpty {
                sectionHeader("PATHWAYS VIA DISEASE (\(result.pathwaysViaDiseases.count))")
                ForEach(result.pathwaysViaDiseases) { item in
                    pathwayLinkCard(item)
                }
            }

            if !result.pathwaysViaCompounds.isEmpty {
                sectionHeader("PATHWAYS VIA COMPOUND (\(result.pathwaysViaCompounds.count))")
                ForEach(result.pathwaysViaCompounds) { item in
                    pathwayLinkCard(item)
                }
            }

            if !result.drugClasses.isEmpty {
                sectionHeader("DRUG TARGET CLASSES")
                ForEach(result.drugClasses) { drug in
                    drugClassCard(drug)
                }
            }

            if !result.cooccurring.isEmpty {
                sectionHeader("CO-OCCURRING TAXA (TOP \(result.cooccurring.count))")
                ForEach(result.cooccurring) { item in
                    cooccurringCard(item)
                }
            }

            Spacer().frame(height: 24)
        }
    }

    // MARK: - Disease Mode Result

    private func diseaseResultView(_ result: DiseaseModeResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(result.diseaseName)
                    .font(.title3.bold())
                HStack(spacing: 8) {
                    Text(result.diseaseId)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                    if let inf = result.infClass {
                        infClassBadge(inf.category)
                    }
                }
                if let inf = result.infClass, !inf.subcategory.isEmpty {
                    Text(inf.subcategory)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            if !result.pathways.isEmpty {
                sectionHeader("RELATED PATHWAYS (\(result.pathways.count))")
                ForEach(result.pathways) { item in
                    pathwayCountCard(item)
                }
            }

            if !result.taxa.isEmpty {
                sectionHeader("LINKED TAXA (\(result.taxa.count))")
                ForEach(result.taxa) { taxon in
                    taxonCard(taxon)
                }
            }

            Spacer().frame(height: 24)
        }
    }

    // MARK: - Reusable Components

    private func sectionHeader(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Divider()
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(Color(hex: "#888888"))
                .tracking(1.5)
                .padding(.top, 4)
        }
        .padding(.horizontal, 16)
    }

    private func taxonCard(_ taxon: PathwayTaxonItem) -> some View {
        Group {
            if let dbId = taxon.dbId {
                NavigationLink(destination: PassportDetailView(passportId: dbId)) {
                    taxonCardContent(taxon)
                }
                .buttonStyle(.plain)
            } else {
                taxonCardContent(taxon)
            }
        }
        .padding(.horizontal, 16)
    }

    private func taxonCardContent(_ taxon: PathwayTaxonItem) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(taxon.name)
                    .font(.subheadline.bold().italic())
                if !taxon.taxonRank.isEmpty {
                    Text(taxon.taxonRank)
                        .font(.caption2)
                        .padding(.horizontal, 5).padding(.vertical, 1)
                        .background(Color(hex: "#f0f0f0"))
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                Spacer()
                if taxon.dbId != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            HStack(spacing: 6) {
                Text(taxon.passportId)
                    .font(.caption2.monospaced())
                    .foregroundStyle(.tertiary)
                if taxon.isPathobiont.lowercased() == "yes" {
                    pathobiontBadge
                }
            }

            if !taxon.roles.isEmpty {
                Text(taxon.roles.prefix(3).joined(separator: " · "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !taxon.viaDiseases.isEmpty || !taxon.viaCompounds.isEmpty {
                FlowLayout(spacing: 4) {
                    ForEach(taxon.viaDiseases) { d in
                        diseaseBadge(d.label, id: d.diseaseId, small: true)
                    }
                    ForEach(taxon.viaCompounds) { c in
                        compoundBadge(c.name, small: true)
                    }
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#fafafa"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#e8e8e8"), lineWidth: 0.5))
    }

    private func pathwayLinkCard(_ item: PathwayLinkItem) -> some View {
        Button {
            vm.searchPathway(id: item.pathwayId)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name).font(.subheadline)
                        HStack(spacing: 4) {
                            Text(item.pathwayId)
                                .font(.caption2.monospaced())
                                .foregroundStyle(.tertiary)
                            if !item.category.isEmpty {
                                Text(item.category)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    Spacer()
                    taxonCountBadge(item.taxonCount)
                }

                if !item.linkingDiseases.isEmpty || !item.linkingCompounds.isEmpty {
                    FlowLayout(spacing: 4) {
                        ForEach(item.linkingDiseases) { d in
                            diseaseBadge(d.label, id: d.diseaseId, small: true)
                        }
                        ForEach(item.linkingCompounds) { c in
                            compoundBadge(c.name, small: true)
                        }
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#fafafa"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#e8e8e8"), lineWidth: 0.5))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private func pathwayCountCard(_ item: PathwayCountItem) -> some View {
        Button {
            vm.searchPathway(id: item.pathwayId)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name).font(.subheadline)
                    HStack(spacing: 4) {
                        Text(item.pathwayId)
                            .font(.caption2.monospaced())
                            .foregroundStyle(.tertiary)
                        if !item.category.isEmpty {
                            Text(item.category)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
                if item.taxonCount > 0 {
                    taxonCountBadge(item.taxonCount)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#fafafa"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#e8e8e8"), lineWidth: 0.5))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private func drugClassCard(_ drug: DrugClassItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(drug.drugName).font(.subheadline)
            HStack(spacing: 4) {
                Text(drug.drugId)
                    .font(.caption2.monospaced())
                    .foregroundStyle(.tertiary)
                Text("·").foregroundStyle(.tertiary)
                Text(drug.targetClass)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            if !drug.targetFamily.isEmpty {
                Text(drug.targetFamily)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#fafafa"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#e8e8e8"), lineWidth: 0.5))
        .padding(.horizontal, 16)
    }

    private func cooccurringCard(_ item: CooccurringItem) -> some View {
        Group {
            if let dbId = item.dbId {
                NavigationLink(destination: PassportDetailView(passportId: dbId)) {
                    cooccurringCardContent(item)
                }
                .buttonStyle(.plain)
            } else {
                cooccurringCardContent(item)
            }
        }
        .padding(.horizontal, 16)
    }

    private func cooccurringCardContent(_ item: CooccurringItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name).font(.subheadline.italic())
                HStack(spacing: 6) {
                    Text(item.passportId)
                        .font(.caption2.monospaced())
                        .foregroundStyle(.tertiary)
                    if item.isPathobiont.lowercased() == "yes" {
                        pathobiontBadge
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(item.sharedPathways)")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color(hex: "#404f7c"))
                Text("shared")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            if item.dbId != nil {
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#fafafa"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#e8e8e8"), lineWidth: 0.5))
    }

    // MARK: - Badges

    private var pathobiontBadge: some View {
        Text("Pathobiont")
            .font(.caption2.bold())
            .padding(.horizontal, 5).padding(.vertical, 1)
            .background(Color(hex: "#007bff"))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private func categoryBadge(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(Color(hex: "#f0f4ff"))
            .foregroundStyle(Color(hex: "#404f7c"))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func infClassBadge(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(Color(hex: "#d1fae5"))
            .foregroundStyle(Color(hex: "#065f46"))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func diseaseBadge(_ label: String, id: String, small: Bool = false) -> some View {
        HStack(spacing: 3) {
            if !small {
                Text(id).font(.caption2.monospaced())
            }
            Text(label)
        }
        .font(small ? .caption2 : .caption)
        .padding(.horizontal, small ? 5 : 6)
        .padding(.vertical, small ? 1 : 2)
        .background(Color(hex: "#d1fae5"))
        .foregroundStyle(Color(hex: "#065f46"))
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "#6ee7b7"), lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func compoundBadge(_ name: String, small: Bool = false) -> some View {
        Text(name)
            .font(small ? .caption2 : .caption)
            .padding(.horizontal, small ? 5 : 6)
            .padding(.vertical, small ? 1 : 2)
            .background(Color(hex: "#ffedd5"))
            .foregroundStyle(Color(hex: "#9a3412"))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "#fdba74"), lineWidth: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func taxonCountBadge(_ count: Int) -> some View {
        Text("\(count)")
            .font(.caption2.bold())
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(Color(hex: "#404f7c"))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
