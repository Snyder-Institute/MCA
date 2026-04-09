import SwiftUI

struct PassportDetailView: View {
    let passportId: Int64
    @State private var detail: PassportDetail?
    @State private var showGlossary = false

    var body: some View {
        Group {
            if let detail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        headerSection(detail)
                        Divider()
                        biologyEcologySection(detail)
                        metaboliteSection(detail)
                        Divider()
                        clinicalProfileSection(detail)
                        if !detail.papers.isEmpty {
                            Divider()
                            evidenceTimelineSection(detail)
                        }
                        Divider()
                        relatedTaxaSection(detail)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(detail?.passport.preferredName ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    if let detail {
                        ShareLink(item: detail.passport.passportId) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    Button {
                        showGlossary = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showGlossary) {
            GlossaryView()
        }
        .task { detail = DatabaseManager.shared.fetchPassportDetail(id: passportId) }
    }

    // MARK: - Header

    private func headerSection(_ d: PassportDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Preferred name — large italic, matching web h1
            Text(d.passport.preferredName)
                .font(.system(size: 32, weight: .bold))
                .italic()

            // Lineage breadcrumbs
            if !d.passport.lineage.isEmpty {
                let parts = d.passport.lineage
                    .components(separatedBy: CharacterSet(charactersIn: ";|"))
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                Text(parts.joined(separator: " › "))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Synonyms
            let synonyms = d.tags.filter { $0.category == "synonym" }
            if !synonyms.isEmpty {
                HStack(alignment: .top, spacing: 0) {
                    Text("Synonyms: ")
                        .font(.caption).bold()
                        .foregroundColor(Color(.secondaryLabel))
                    Text(synonyms.map(\.value).joined(separator: "; "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // ID block
            VStack(alignment: .leading, spacing: 6) {
                Text(d.passport.passportId)
                    .font(.subheadline.monospaced()).bold()

                HStack(spacing: 12) {
                    if let ncbi = d.passport.ncbiTaxid,
                       let url = URL(string: "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=\(ncbi)") {
                        HStack(spacing: 3) {
                            Text("TaxID:").font(.caption).foregroundColor(.secondary)
                            Link(String(ncbi), destination: url)
                                .font(.caption).bold()
                        }
                    }

                    let showBacdive = ["species", "subspecies", "strain"].contains(d.passport.taxonRank.lowercased())
                    if showBacdive, let bacdiveUrl = d.biology?.bacdiveUrl, let url = URL(string: bacdiveUrl) {
                        HStack(spacing: 3) {
                            Text("BacDive:").font(.caption).foregroundColor(.secondary)
                            Link(url.lastPathComponent, destination: url)
                                .font(.caption).bold()
                        }
                    }

                    HStack(spacing: 3) {
                        Text("Rank:").font(.caption).foregroundColor(.secondary)
                        Text(d.passport.taxonRank.capitalized).font(.caption).bold()
                    }
                }
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 16)
    }

    // MARK: - Biology & Ecology

    private func biologyEcologySection(_ d: PassportDetail) -> some View {
        let bio = d.biology
        let traits = d.tags.filter { $0.category == "key_trait" }
        let niches = d.tags.filter { $0.category == "primary_niche" }
        let reservoirs = d.tags.filter { $0.category == "reservoir" }
        let routes = d.tags.filter { $0.category == "transmission_route" }

        let hasBiology = bio?.gramStatus != nil || bio?.oxygenTolerance != nil || bio?.morphology != nil || !traits.isEmpty
        let hasEcology = !niches.isEmpty || !reservoirs.isEmpty || !routes.isEmpty

        return VStack(alignment: .leading, spacing: 0) {
            // Biology section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Biology")

                if !hasBiology {
                    Text("Not characterized at this rank.")
                        .font(.caption).foregroundColor(.secondary)
                } else {
                    if let gram = bio?.gramStatus {
                        InlineDataRow(label: "Gram Status", value: gram)
                    }
                    if let oxygen = bio?.oxygenTolerance {
                        InlineDataRow(label: "Oxygen Tolerance", value: oxygen)
                    }
                    if let morph = bio?.morphology {
                        InlineDataRow(label: "Morphology", value: morph)
                    }
                    if !traits.isEmpty {
                        InlineDataRow(label: "Key Traits", value: traits.map(\.value).joined(separator: ", "))
                    }
                }
            }
            .padding(.vertical, 16)

            Divider()

            // Ecology section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Ecology")

                if !hasEcology {
                    Text("Not characterized at this rank.")
                        .font(.caption).foregroundColor(.secondary)
                } else {
                    if !niches.isEmpty {
                        InlineDataRow(label: "Primary Niches", value: niches.map(\.value).joined(separator: ", "))
                    }
                    if !reservoirs.isEmpty {
                        InlineDataRow(label: "Reservoirs", value: reservoirs.map(\.value).joined(separator: ", "))
                    }
                    if !routes.isEmpty {
                        InlineDataRow(label: "Transmission", value: routes.map(\.value).joined(separator: ", "))
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }

    // MARK: - Metabolites

    private func metaboliteSection(_ d: PassportDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Metabolites")

            if d.metabolites.isEmpty {
                Text("No metabolite relationships documented for this taxon.")
                    .font(.caption).foregroundColor(.secondary)
            } else {
                let grouped = Dictionary(grouping: d.metabolites, by: \.relationship)
                ForEach(["produces", "consumes", "modifies"], id: \.self) { rel in
                    if let mets = grouped[rel], !mets.isEmpty {
                        HStack(alignment: .top, spacing: 0) {
                            Text(rel.capitalized)
                                .font(.caption).bold()
                                .foregroundColor(Color(.label))
                                .frame(width: 130, alignment: .leading)
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(mets) { met in
                                    HStack(spacing: 4) {
                                        if let kegg = met.keggCompoundId,
                                           let keggUrl = URL(string: "https://www.genome.jp/entry/\(kegg)") {
                                            Link(kegg, destination: keggUrl)
                                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                                .padding(.horizontal, 5).padding(.vertical, 1)
                                                .background(Color(hex: "#ffedd5"))
                                                .foregroundColor(Color(hex: "#9a3412"))
                                                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: "#fdba74"), lineWidth: 1))
                                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                        }
                                        if let chebi = met.chebiId,
                                           let chebiUrl = URL(string: "https://www.ebi.ac.uk/chebi/searchId.do?chebiId=\(chebi)") {
                                            let chebiDisplay = chebi.replacingOccurrences(of: "CHEBI:", with: "")
                                            Link(chebiDisplay, destination: chebiUrl)
                                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                                .padding(.horizontal, 5).padding(.vertical, 1)
                                                .background(Color(hex: "#e0f2fe"))
                                                .foregroundColor(Color(hex: "#0369a1"))
                                                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: "#7dd3fc"), lineWidth: 1))
                                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                        }
                                        Text(met.name).font(.caption).foregroundColor(Color(.secondaryLabel))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Clinical Profile

    private func clinicalProfileSection(_ d: PassportDetail) -> some View {
        let roles = d.tags.filter { $0.category == "role" }
        let specimens = d.tags.filter { $0.category == "typical_specimen" }
        let triggers = d.tags.filter { $0.category == "bloom_trigger" }
        let riskContexts = d.tags.filter { $0.category == "risk_context" }
        let amrHighlights = d.tags.filter { $0.category == "amr_highlight" }
        let virulenceFactors = d.tags.filter { $0.category == "virulence_factor" }

        return VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Clinical Profile")

            // Pathobiont status badges
            VStack(alignment: .leading, spacing: 4) {
                Text("Pathobiont")
                    .font(.caption).bold()
                HStack(spacing: 4) {
                    ForEach(["yes", "no", "context dependent", "unknown"], id: \.self) { opt in
                        PathobiontOptionBadge(
                            option: opt,
                            isActive: d.passport.isPathobiont.lowercased() == opt
                        )
                    }
                }
            }
            .padding(.bottom, 4)

            // Single-column layout
            if !roles.isEmpty {
                InlineDataRow(label: "Clinical Roles", value: roles.map(\.value).joined(separator: "; "))
            }
            if !specimens.isEmpty {
                InlineDataRow(label: "Typical Specimens", value: specimens.map(\.value).joined(separator: "; "))
            }
            if !triggers.isEmpty {
                tagRowWithExtId(label: "Bloom Triggers", tags: triggers, linkType: .kegg)
            }
            if !riskContexts.isEmpty {
                InlineDataRow(label: "Risk Contexts", value: riskContexts.map(\.value).joined(separator: "; "))
            }
            if !amrHighlights.isEmpty {
                tagRowWithExtId(label: "AMR Highlights", tags: amrHighlights, linkType: .aro)
            }
            if !virulenceFactors.isEmpty {
                tagRowWithExtId(label: "Virulence Factors", tags: virulenceFactors, linkType: .vfdb)
            }

            // Clinical Associations (full width, below columns)
            if !d.associations.isEmpty {
                Divider().padding(.vertical, 8)
                Text("Clinical Associations:")
                    .font(.footnote).bold()
                VStack(spacing: 10) {
                    ForEach(d.associations) { assoc in
                        CuratedAssociationCard(assoc: assoc)
                    }
                }
            }

            // Last reviewed
            if let lastReviewed = d.passport.lastReviewed {
                HStack {
                    Spacer()
                    Text("Last reviewed: \(lastReviewed)")
                        .font(.caption2)
                        .foregroundColor(Color(.tertiaryLabel))
                }
                .padding(.top, 8)
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Evidence Timeline

    private func evidenceTimelineSection(_ d: PassportDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Evidence Timeline")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(d.papers) { paper in
                        Link(destination: URL(string: "https://pubmed.ncbi.nlm.nih.gov/\(paper.pmid)/") ?? URL(string: "https://pubmed.ncbi.nlm.nih.gov")!) {
                            VStack(spacing: 4) {
                                Text(paper.year.map(String.init) ?? "?")
                                    .font(.subheadline).bold()
                                    .foregroundColor(Color(hex: "#404f7c"))
                                if let design = paper.studyDesign {
                                    Text(truncatedDesign(design))
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(width: 120)
                            .padding(.vertical, 8).padding(.horizontal, 12)
                            .background(Color(.secondarySystemBackground))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(.separator), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Related Taxa

    private func relatedTaxaSection(_ d: PassportDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Related Taxa")

            if d.relatedTaxa.isEmpty {
                Text("No related taxa in current database.")
                    .font(.caption).foregroundColor(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(d.relatedTaxa) { taxon in
                        NavigationLink(destination: PassportDetailView(passportId: taxon.dbId)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(taxon.passportId)
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(Color(.tertiaryLabel))
                                HStack(spacing: 4) {
                                    Text(taxon.preferredName)
                                        .font(.caption).bold().italic()
                                        .foregroundColor(.primary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    Spacer(minLength: 0)
                                }
                                HStack(spacing: 4) {
                                    if taxon.matchCategories.contains("primary_niche") {
                                        MatchBadge(text: "Niche", bg: "#efefef", fg: "#555555", border: "#d8d8d8")
                                    }
                                    if taxon.matchCategories.contains("risk_context") {
                                        MatchBadge(text: "Risk", bg: "#f0ece8", fg: "#7a6a5f", border: "#ddd0c8")
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(Color(hex: "#f5f6fa"))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(hex: "#e0e2ee"), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Helpers

    private enum ExtIdLinkType { case kegg, aro, vfdb }

    private func tagRowWithExtId(label: String, tags: [TaxonTag], linkType: ExtIdLinkType) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(label)
                .font(.caption).bold()
                .foregroundColor(Color(.label))
                .frame(width: 130, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                ForEach(tags) { tag in
                    HStack(spacing: 4) {
                        if let extId = tag.extId, !extId.isEmpty {
                            extIdBadge(extId: extId, linkType: linkType)
                        }
                        Text(tag.value).font(.caption).foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func extIdBadge(extId: String, linkType: ExtIdLinkType) -> some View {
        switch linkType {
        case .kegg:
            Link(extId, destination: URL(string: "https://www.kegg.jp/entry/\(extId)")!)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .padding(.horizontal, 5).padding(.vertical, 1)
                .background(Color(hex: "#ffedd5")).foregroundColor(Color(hex: "#9a3412"))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: "#fdba74"), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 3))
        case .aro:
            let num = extId.replacingOccurrences(of: "ARO:", with: "")
            Link(num, destination: URL(string: "https://card.mcmaster.ca/ontology/\(num)")!)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .padding(.horizontal, 5).padding(.vertical, 1)
                .background(Color(hex: "#fee2e2")).foregroundColor(Color(hex: "#991b1b"))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: "#fca5a5"), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 3))
        case .vfdb:
            Link(extId, destination: URL(string: "https://www.mgc.ac.cn/cgi-bin/VFs/vfs.cgi?VFID=\(extId)")!)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .padding(.horizontal, 5).padding(.vertical, 1)
                .background(Color(hex: "#fce7f3")).foregroundColor(Color(hex: "#9d174d"))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: "#f9a8d4"), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 3))
        }
    }

    private func truncatedDesign(_ design: String) -> String {
        var result = design
        for sep in ["\u{2014}", " \u{2014} ", " - "] {
            if let range = result.range(of: sep) {
                result = String(result[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
                break
            }
        }
        guard !result.isEmpty else { return "" }
        return result.prefix(1).uppercased() + result.dropFirst()
    }
}

// MARK: - Section Header

private struct SectionHeader: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.uppercased())
                .font(.caption).bold()
                .foregroundColor(Color(hex: "#888888"))
                .tracking(1.5)
            Divider()
        }
    }
}

// MARK: - Inline Data Row (label + value on same line)

private struct InlineDataRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(label)
                .font(.caption).bold()
                .foregroundColor(Color(.label))
                .frame(width: 130, alignment: .leading)
            Text(value)
                .font(.caption)
                .foregroundColor(Color(.secondaryLabel))
        }
    }
}

// MARK: - Pathobiont Option Badges

private struct PathobiontOptionBadge: View {
    let option: String
    let isActive: Bool

    var body: some View {
        Text(option.uppercased())
            .font(.system(size: 9, weight: .bold))
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(bgColor)
            .foregroundColor(fgColor)
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(borderColor, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private var bgColor: Color {
        guard isActive else { return Color(hex: "#f5f5f5") }
        switch option {
        case "yes": return Color(hex: "#007bff")
        case "context dependent": return Color(hex: "#4b5563")
        default: return Color(hex: "#e5e7eb")
        }
    }

    private var fgColor: Color {
        guard isActive else { return Color(hex: "#cccccc") }
        switch option {
        case "yes", "context dependent": return .white
        default: return Color(hex: "#6b7280")
        }
    }

    private var borderColor: Color {
        guard isActive else { return Color(hex: "#eeeeee") }
        switch option {
        case "yes": return Color(hex: "#0056b3")
        case "context dependent": return Color(hex: "#374151")
        default: return Color(hex: "#d1d5db")
        }
    }
}

// MARK: - Match Badge (Related Taxa)

private struct MatchBadge: View {
    let text: String
    let bg: String
    let fg: String
    let border: String

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .bold))
            .padding(.horizontal, 5).padding(.vertical, 1)
            .background(Color(hex: bg))
            .foregroundColor(Color(hex: fg))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: border), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}

// MARK: - Curated Association Card

private struct CuratedAssociationCard: View {
    let assoc: Association

    private var colors: EvidenceColors { EvidenceColors.forGrade(assoc.evidenceGrade) }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Evidence badge
            Text(assoc.evidenceGrade)
                .font(.system(size: 11, weight: .black))
                .frame(width: 28, height: 28)
                .background(colors.bg)
                .foregroundColor(colors.text)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(colors.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading, spacing: 6) {
                Text(assoc.text)
                    .font(.footnote)

                if !assoc.pmids.isEmpty {
                    HStack(spacing: 4) {
                        Text("PMID:").font(.caption2).bold().foregroundColor(.secondary)
                        ForEach(assoc.pmids, id: \.self) { pmid in
                            if let url = URL(string: "https://pubmed.ncbi.nlm.nih.gov/\(pmid)/") {
                                Link(pmid, destination: url)
                                    .font(.caption2)
                                    .foregroundColor(Color(hex: "#007bff"))
                            }
                        }
                    }
                }

                if !assoc.refs.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(assoc.refs) { ref in
                            RefBadge(ref: ref)
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#fafafa"))
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

// MARK: - Ref Badge

private struct RefBadge: View {
    let ref: AssocRef

    private var colors: (bg: Color, text: Color, border: Color) {
        switch ref.refType {
        case "mesh":         return (Color(hex: "#d1fae5"), Color(hex: "#065f46"), Color(hex: "#6ee7b7"))
        case "kegg_disease": return (Color(hex: "#ffedd5"), Color(hex: "#9a3412"), Color(hex: "#fdba74"))
        default:             return (Color(hex: "#f5f5f5"), Color(hex: "#555555"), Color(hex: "#dddddd"))
        }
    }

    private var url: URL? {
        switch ref.refType {
        case "mesh":
            return URL(string: "https://meshb.nlm.nih.gov/record/ui?ui=\(ref.refId)")
        case "kegg_disease":
            return URL(string: "https://www.genome.jp/entry/\(ref.refId)")
        default:
            return nil
        }
    }

    var body: some View {
        let (bg, text, border) = colors
        HStack(spacing: 4) {
            if let url {
                Link(ref.refId, destination: url)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 5).padding(.vertical, 1)
                    .background(bg).foregroundColor(text)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(border, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 3))
            } else {
                Text(ref.refLabel.isEmpty ? ref.refId : ref.refLabel)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 5).padding(.vertical, 1)
                    .background(bg).foregroundColor(text)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(border, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 3))
            }
            if !ref.refLabel.isEmpty && url != nil {
                Text(ref.refLabel)
                    .font(.caption)
                    .foregroundColor(Color(.label))
            }
        }
    }
}
