import SwiftUI

struct GlossaryView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Understanding the Passport")
                            .font(.system(size: 28, weight: .black))
                        Text("This guide explains the data fields and nomenclature used within the Microbial Clinical Atlas (MCA) Taxon Passports.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)
                    Divider().frame(height: 2).overlay(Color.primary)
                    .padding(.bottom, 24)

                    // Identity
                    glossarySection("Identity") {
                        glossaryItem("Passport ID",
                            "A stable, unique identifier for each taxon entry following the format MCA-[DOMAIN]-[NNNNNN].",
                            bullets: [
                                "BAC: Bacteria",
                                "FUN: Fungi",
                                "VIR: Viruses",
                                "ARC: Archaea"
                            ],
                            footer: "[NNNNNN] is a unique six-digit numeric identifier that ensures permanent reference regardless of taxonomic updates.")
                        glossaryItem("TaxID",
                            "The official NCBI Taxonomy database identifier, linking each entry to a globally recognised taxonomic record. Clicking the TaxID opens the corresponding NCBI Taxonomy page.")
                        glossaryItem("BacDive ID",
                            "Identifier linking to the BacDive entry for this taxon's type strain. BacDive is a standardised microbiological culture collection database maintained by DSMZ, providing curated microbiological metadata including culture conditions, physiology, and isolation sources. Available at species level and below.")
                        glossaryItem("Rank",
                            "The taxonomic level of the entry, such as family, genus, species, or strain.")
                        glossaryItem("Lineage",
                            "The full taxonomic hierarchy from domain down to the specific rank of the entry.")
                        glossaryItem("Synonyms",
                            "Alternative scientific names and historical nomenclature sourced from NCBI Taxonomy.")
                    }

                    // Biology
                    glossarySection("Biology") {
                        glossaryItem("Gram Status",
                            "Gram stain classification (positive, negative, or variable) for bacterial taxa. Sourced from BacDive.")
                        glossaryItem("Oxygen Tolerance",
                            "Classification of metabolic oxygen requirements (e.g., aerobe, obligate anaerobe, facultative anaerobe). Sourced from BacDive.")
                        glossaryItem("Morphology",
                            "Typical physical cell structure and shape (e.g., rod, coccus, spiral). Sourced from BacDive.")
                        glossaryItem("Key Traits",
                            "Biologically relevant features such as spore formation, biofilm production, or toxin production. Sourced from BacDive.")
                    }

                    // Ecology
                    glossarySection("Ecology") {
                        glossaryItem("Primary Niches",
                            "The specific body sites or environments where the organism is most commonly found (e.g., gut, oral cavity, skin). Sourced from BacDive.")
                        glossaryItem("Reservoir",
                            "The natural hosts or environments where the taxon persists: human, animal, or environment. Sourced from BacDive.")
                        glossaryItem("Transmission",
                            "The routes through which the organism is typically acquired (e.g., contact, foodborne, waterborne). Sourced from the curated literature.")
                    }

                    // Clinical Profile
                    glossarySection("Clinical Profile") {
                        glossaryItem("Pathobiont",
                            "Whether this taxon is considered a pathobiont \u{2014} a resident commensal that can cause disease under specific conditions.",
                            bullets: [
                                "Yes \u{2014} organism is a recognised pathobiont",
                                "Context dependent \u{2014} pathobiont status depends on host factors, clinical setting, or taxonomic level",
                                "No \u{2014} organism is not considered a pathobiont",
                                "Unknown \u{2014} insufficient evidence to classify"
                            ])
                        glossaryItem("Clinical Roles",
                            "The clinical characterisation of this taxon, such as opportunistic pathogen, protective commensal, or commensal. Extracted from curated literature.")
                        glossaryItem("Typical Specimen",
                            "Common specimen types in which the organism is identified in a clinical context (e.g., stool, blood, respiratory). Extracted from curated literature.")
                        glossaryItem("Risk Contexts",
                            "Clinical settings or patient populations where this taxon is most likely to cause harm (e.g., ICU, post-antibiotic, immunocompromised). Extracted from curated literature.")
                        glossaryItemWithBadge("Antimicrobial Resistance",
                            "Notable resistance phenotypes that impact clinical management (e.g., ESBL, CRE, VRE). Extracted from curated literature. Where available, linked to the CARD Antibiotic Resistance Ontology (ARO).",
                            example: "multidrug-resistant (MDR)", badgeText: "3004305",
                            bg: "#fee2e2", fg: "#991b1b", border: "#fca5a5")
                        glossaryItemWithBadge("Bloom Triggers",
                            "Conditions that enable this taxon to expand to clinically relevant abundance (e.g., antibiotic exposure, immunosuppression). Extracted from curated literature. Specific drugs are linked to KEGG Drug (D numbers).",
                            example: "proton pump inhibitor (PPI) use", badgeText: "D00455",
                            bg: "#ffedd5", fg: "#9a3412", border: "#fdba74")
                        glossaryItemWithBadge("Virulence Factors",
                            "Molecular factors that contribute to pathogenicity (e.g., toxins, adhesins, capsule). Linked to the Virulence Factor Database (VFDB) where available.",
                            example: "Toxin A", badgeText: "VF0592",
                            bg: "#fce7f3", fg: "#9d174d", border: "#f9a8d4")
                    }

                    // Metabolites
                    glossarySection("Metabolites") {
                        glossaryItem("Metabolite Relationships",
                            "Documented metabolic interactions between this taxon and specific compounds.",
                            bullets: [
                                "Produces \u{2014} taxon synthesises this metabolite",
                                "Consumes \u{2014} taxon degrades or consumes this metabolite",
                                "Modifies \u{2014} taxon chemically transforms this metabolite"
                            ],
                            footer: "Compounds are linked to KEGG Compound (C numbers) and ChEBI IDs where available.")
                    }

                    // Clinical Associations
                    glossarySection("Clinical Associations") {
                        glossaryItem("Association",
                            "An individual, evidence-graded claim linking this taxon to a specific clinical condition or outcome, extracted from a peer-reviewed publication. Each association is supported by at least one PMID and assigned an evidence grade.")

                        // Evidence grades
                        VStack(alignment: .leading, spacing: 12) {
                            evidenceGradeItem(grade: "E3", label: "Strong human clinical evidence",
                                description: "Supported by clinical practice guidelines, systematic reviews, pooled meta-analyses (across RCTs or cohorts), or a discovery + independent validation cohort design within a single paper.",
                                bg: "#dcfce7", fg: "#166534")
                            evidenceGradeItem(grade: "E2", label: "Moderate human evidence",
                                description: "Supported by a single human cohort (including multi-center observational cohorts without pooled analysis), a single RCT, case-control, or cross-sectional study.",
                                bg: "#fef3c7", fg: "#92400e")
                            evidenceGradeItem(grade: "E1", label: "Limited / preliminary",
                                description: "Supported by animal models, in vitro studies, case reports, or mechanistic work only.",
                                bg: "#e5e7eb", fg: "#6b7280")
                        }
                        .padding(.leading, 15)
                        .padding(.bottom, 16)

                        glossaryItemWithBadge("MeSH",
                            "Standardised Medical Subject Headings (MeSH) terms assigned by NLM to the source paper, filtered to those directly relevant to the association. Clicking a badge opens the NLM MeSH Browser entry.",
                            example: "Cross Infection", badgeText: "D003428",
                            bg: "#d1fae5", fg: "#065f46", border: "#6ee7b7")
                        glossaryItemWithBadge("KEGG",
                            "KEGG Disease identifiers mapping the associated clinical condition to KEGG's disease classification. Clicking a badge opens the corresponding KEGG Disease entry.",
                            example: "Enterococcal infection", badgeText: "H01444",
                            bg: "#ffedd5", fg: "#9a3412", border: "#fdba74")
                    }

                    // Evidence Timeline
                    glossarySection("Evidence Timeline") {
                        glossaryItem("Timeline",
                            "A chronological summary of the papers that contributed clinical associations to this passport. Each card shows the publication year and study design. Clicking a card opens the source paper on PubMed.")
                    }

                    // Related Taxa
                    glossarySection("Related Taxa") {
                        glossaryItem("Related Taxa",
                            "Other taxa in the MCA database that share at least one annotated attribute with this entry.",
                            bullets: [
                                "Shared Niche \u{2014} both taxa occupy the same primary body site or environment",
                                "Shared Risk \u{2014} both taxa are associated with the same clinical risk context or vulnerable population"
                            ])
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .navigationTitle("Glossary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Section

    @ViewBuilder
    private func glossarySection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3).bold()
                .padding(.bottom, 4)
            Divider()
            content()
        }
        .padding(.bottom, 32)
    }

    // MARK: - Item

    @ViewBuilder
    private func glossaryItem(_ term: String, _ description: String, bullets: [String]? = nil, footer: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(term)
                .font(.subheadline).bold()
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 3))

            Text(description)
                .font(.footnote)
                .foregroundColor(Color(.secondaryLabel))
                .lineSpacing(3)

            if let bullets {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(bullets, id: \.self) { item in
                        HStack(alignment: .top, spacing: 6) {
                            Text("\u{2022}").font(.footnote)
                            Text(item).font(.footnote).foregroundColor(Color(.secondaryLabel))
                        }
                    }
                }
                .padding(.leading, 8)
            }

            if let footer {
                Text(footer)
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
                    .lineSpacing(3)
            }
        }
        .padding(.leading, 15)
        .padding(.bottom, 8)
    }

    // MARK: - Item with Badge Example

    @ViewBuilder
    private func glossaryItemWithBadge(_ term: String, _ description: String,
                                       example: String, badgeText: String,
                                       bg: String, fg: String, border: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(term)
                .font(.subheadline).bold()
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 3))

            Text(description)
                .font(.footnote)
                .foregroundColor(Color(.secondaryLabel))
                .lineSpacing(3)

            HStack(spacing: 6) {
                Text(example)
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
                Text(badgeText)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 5).padding(.vertical, 1)
                    .background(Color(hex: bg))
                    .foregroundColor(Color(hex: fg))
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: border), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 3))
            }
            .padding(.top, 4)
        }
        .padding(.leading, 15)
        .padding(.bottom, 8)
    }

    // MARK: - Evidence Grade

    @ViewBuilder
    private func evidenceGradeItem(grade: String, label: String, description: String, bg: String, fg: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(grade) \u{2014} \(label)")
                .font(.subheadline).bold()
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(Color(hex: bg))
                .foregroundColor(Color(hex: fg))
                .clipShape(RoundedRectangle(cornerRadius: 3))
            Text(description)
                .font(.footnote)
                .foregroundColor(Color(.secondaryLabel))
                .lineSpacing(3)
        }
    }
}
