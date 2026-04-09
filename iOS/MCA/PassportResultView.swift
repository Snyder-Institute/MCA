import SwiftUI
import MessageUI

struct PassportResultView: View {
    let passports: [ExtractedPassport]
    var isDemo: Bool = false

    @State private var showMail = false
    @State private var showMailAlert = false
    @State private var mcaMatches: [UUID: Passport] = [:]  // keyed by ExtractedPassport.id

    /// Passports sorted so MCA matches appear first
    private var sortedPassports: [ExtractedPassport] {
        passports.sorted { a, b in
            let aMatch = mcaMatches[a.id] != nil
            let bMatch = mcaMatches[b.id] != nil
            if aMatch != bMatch { return aMatch }
            return false
        }
    }

    private var matchCount: Int { mcaMatches.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if passports.isEmpty {
                    ContentUnavailableView {
                        Label("No Taxa Found", systemImage: "leaf")
                    } description: {
                        Text("Claude could not identify any microbial taxa in this paper. Try using full text instead of the abstract for better results.")
                    }
                    .padding(.top, 40)
                }

                // Taxa count header
                if passports.count > 1 {
                    HStack(spacing: 6) {
                        Text("\(passports.count) taxa extracted")
                            .font(.footnote).bold()
                            .foregroundColor(Color(hex: "#404f7c"))
                        if matchCount > 0 {
                            Text("·")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Text("\(matchCount) in MCA")
                                .font(.footnote).bold()
                                .foregroundColor(Color(hex: "#065f46"))
                        }
                    }
                    .padding(.vertical, 8)
                }

                ForEach(Array(sortedPassports.enumerated()), id: \.element.id) { index, passport in
                    if index > 0 {
                        taxonDivider
                    }

                    // MCA match link
                    if let mcaPassport = mcaMatches[passport.id] {
                        NavigationLink(destination: PassportDetailView(passportId: mcaPassport.id)) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#065f46"))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Found in MCA Database")
                                        .font(.caption).bold()
                                        .foregroundColor(Color(hex: "#065f46"))
                                    Text("View full passport for \(mcaPassport.preferredName)")
                                        .font(.caption2)
                                        .foregroundColor(Color(hex: "#065f46").opacity(0.8))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption2)
                                    .foregroundColor(Color(hex: "#065f46").opacity(0.6))
                            }
                            .padding(10)
                            .background(Color(hex: "#d1fae5"))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#6ee7b7"), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.bottom, 4)
                    }

                    PassportCardView(passport: passport)
                }

                // Source (from first passport)
                if let first = passports.first {
                    sourceSection(passport: first)
                }

                // Submit button
                if !isDemo && !passports.isEmpty {
                    submitButton
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .sheet(isPresented: $showMail) {
            MailComposer(passports: passports, isPresented: $showMail)
        }
        .alert("Mail Not Available", isPresented: $showMailAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Mail is not configured on this device. Please set up a Mail account in Settings.")
        }
        .onAppear {
            lookupMCAMatches()
        }
    }

    private func lookupMCAMatches() {
        var matches: [UUID: Passport] = [:]
        for passport in passports {
            if let found = DatabaseManager.shared.findPassport(byName: passport.taxonName) {
                matches[passport.id] = found
            }
        }
        mcaMatches = matches
    }

    // MARK: - Taxon Divider

    private var taxonDivider: some View {
        Rectangle()
            .fill(Color(hex: "#404f7c").opacity(0.15))
            .frame(height: 2)
            .padding(.vertical, 12)
    }

    // MARK: - Source

    private func sourceSection(passport: ExtractedPassport) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let pmid = passport.sourcePmid, !pmid.isEmpty,
               let url = URL(string: "https://pubmed.ncbi.nlm.nih.gov/\(pmid)/") {
                HStack(spacing: 3) {
                    Text("Source:").font(.caption).foregroundColor(.secondary)
                    Link("PMID \(pmid)", destination: url)
                        .font(.caption)
                        .foregroundColor(Color(hex: "#007bff"))
                }
            } else if let title = passport.sourceTitle, !title.isEmpty {
                HStack(alignment: .top, spacing: 3) {
                    Text("Source:").font(.caption).foregroundColor(.secondary)
                    Text(title).font(.caption).foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Submit

    private var submitButton: some View {
        Button {
            if MFMailComposeViewController.canSendMail() {
                showMail = true
            } else {
                showMailAlert = true
            }
        } label: {
            Label("Share with MCA Developer", systemImage: "envelope")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding(.top, 8)
    }
}

// MARK: - Single Passport Card

private struct PassportCardView: View {
    let passport: ExtractedPassport

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerSection
            Divider()

            // Biology
            if passport.gramStatus != nil || passport.oxygenTolerance != nil || passport.morphology != nil || !passport.keyTraits.isEmpty {
                biologySection
                Divider()
            }

            // Ecology
            if !passport.primaryNiches.isEmpty {
                ecologySection
                Divider()
            }

            // Metabolites
            if !passport.metabolites.isEmpty {
                metaboliteSection
                Divider()
            }

            // Clinical Profile
            clinicalProfileSection
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(passport.taxonName)
                .font(.system(size: 26, weight: .bold))
                .italic()

            if let rank = passport.taxonRank {
                HStack(spacing: 3) {
                    Text("Rank:").font(.caption).foregroundColor(.secondary)
                    Text(rank.capitalized).font(.caption).bold()
                }
            }
        }
        .padding(.vertical, 16)
    }

    private var biologySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ExtractorSectionHeader(title: "Biology")

            if let gram = passport.gramStatus {
                ExtractorInlineRow(label: "Gram Status", value: gram)
            }
            if let oxygen = passport.oxygenTolerance {
                ExtractorInlineRow(label: "Oxygen Tolerance", value: oxygen)
            }
            if let morph = passport.morphology {
                ExtractorInlineRow(label: "Morphology", value: morph)
            }
            if !passport.keyTraits.isEmpty {
                ExtractorInlineRow(label: "Key Traits", value: passport.keyTraits.joined(separator: ", "))
            }
        }
        .padding(.vertical, 16)
    }

    private var ecologySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ExtractorSectionHeader(title: "Ecology")

            ExtractorInlineRow(label: "Primary Niches", value: passport.primaryNiches.joined(separator: ", "))
        }
        .padding(.vertical, 16)
    }

    private var metaboliteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ExtractorSectionHeader(title: "Metabolites")

            ExtractorInlineRow(label: "Metabolites", value: passport.metabolites.joined(separator: ", "))
        }
        .padding(.vertical, 16)
    }

    private var clinicalProfileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ExtractorSectionHeader(title: "Clinical Profile")

            if !passport.clinicalRoles.isEmpty {
                ExtractorInlineRow(label: "Clinical Roles", value: passport.clinicalRoles.joined(separator: "; "))
            }

            if !passport.clinicalAssociations.isEmpty {
                Divider().padding(.vertical, 4)
                Text("Clinical Associations:")
                    .font(.footnote).bold()
                VStack(spacing: 10) {
                    ForEach(passport.clinicalAssociations) { assoc in
                        ExtractorAssociationCard(association: assoc)
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
}

// MARK: - Extractor Section Header

private struct ExtractorSectionHeader: View {
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

// MARK: - Extractor Inline Row

private struct ExtractorInlineRow: View {
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

// MARK: - Extractor Association Card

private struct ExtractorAssociationCard: View {
    let association: ExtractedAssociation

    private var colors: EvidenceColors { EvidenceColors.forGrade(association.evidenceLevel) }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(association.evidenceLevel)
                .font(.system(size: 11, weight: .black))
                .frame(width: 28, height: 28)
                .background(colors.bg)
                .foregroundColor(colors.text)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(colors.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 4))

            Text(association.text)
                .font(.footnote)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#fafafa"))
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxX = max(maxX, x)
        }
        return CGSize(width: maxX, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
