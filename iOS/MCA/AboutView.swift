import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    introSection
                    Divider()
                    statsSection
                    Divider()
                    featuresSection
                    Divider()
                    pipelineSection
                    Divider()
                    dataModelSection
                    Divider()
                    acknowledgementsSection
                    Divider()
                    contactSection
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("About MCA")
        }
    }

    // MARK: - Intro

    private var introSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Database \(DatabaseManager.shared.fetchDbVersion())")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("The **Microbial Clinical Atlas (MCA)** is a curated knowledge base of **Taxon Passports** — structured records that summarise the clinically relevant biology, ecology, and evidence-linked associations of human-associated microorganisms.")
                .font(.footnote)
                .foregroundColor(.secondary)
            Text("MCA is designed to make microbiome findings reproducible and comparable across studies by enforcing controlled vocabularies, stable identifiers, and explicit evidence grading.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 16)
    }

    // MARK: - Live Stats

    private var statsSection: some View {
        let stats = DatabaseManager.shared.fetchStats()
        return VStack(alignment: .leading, spacing: 12) {
            SectionTitle("Database Stats")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatCard(number: "\(stats.passports)", label: "Taxon Passports")
                StatCard(number: "\(stats.associations)", label: "Clinical Associations")
                StatCard(number: "\(stats.pmids)", label: "Unique PMIDs")
                StatCard(number: "\(stats.refs)", label: "Ontology References")
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Features

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle("Features")

            // Pathobiont Status
            FeatureCard(title: "Pathobiont Status") {
                Text("Each Taxon Passport records whether the organism is considered a pathobiont — a commensal capable of causing disease under conditions such as immunosuppression, antibiotic disruption, or barrier dysfunction.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: 6) {
                    PathobiontKeyRow(label: "YES", description: "Recognised pathobiont", bg: "#007bff", fg: "#ffffff")
                    PathobiontKeyRow(label: "CD", description: "Context dependent", bg: "#4b5563", fg: "#ffffff")
                    PathobiontKeyRow(label: "NO", description: "Not considered a pathobiont", bg: "#e5e7eb", fg: "#6b7280")
                    PathobiontKeyRow(label: "UK", description: "Unknown — insufficient evidence", bg: "#e5e7eb", fg: "#6b7280")
                }
            }

            // Evidence Grading
            FeatureCard(title: "Evidence Grading") {
                Text("Every clinical association is graded by study design. Each grade reflects the strongest design reported for that finding.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: 6) {
                    EvidenceKeyRow(grade: "E3", description: "Strong — clinical practice guidelines, systematic reviews, pooled meta-analyses (across RCTs or cohorts), or a discovery + independent validation cohort design within a single paper")
                    EvidenceKeyRow(grade: "E2", description: "Moderate — a single human cohort (including multi-center observational cohorts without pooled analysis), a single RCT, a case-control study, or a cross-sectional human study")
                    EvidenceKeyRow(grade: "E1", description: "Limited — animal models, in vitro studies, case reports, or mechanistic work only")
                }
            }

            // Cross-Database Linkage
            FeatureCard(title: "Cross-Database Linkage") {
                Text("Every passport field is anchored to a standard ontology or external database, making MCA entries interoperable with other bioinformatics resources.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: 6) {
                    DbLinkRow(label: "NCBI", description: "Taxon lineage, rank, preferred name, stable TaxID", bg: "#eef0f8", fg: "#404f7c")
                    DbLinkRow(label: "MeSH", description: "Disease terms and anatomy on associations", bg: "#d1fae5", fg: "#065f46")
                    DbLinkRow(label: "KEGG", description: "Disease, Drug, and Compound IDs", bg: "#ffedd5", fg: "#9a3412")
                    DbLinkRow(label: "ARO", description: "Antimicrobial resistance gene ontology", bg: "#fee2e2", fg: "#991b1b")
                    DbLinkRow(label: "ChEBI", description: "Chemical entity identifiers on metabolites", bg: "#e0f2fe", fg: "#0369a1")
                    DbLinkRow(label: "BacDive", description: "Morphology, physiology, ecological niche data", bg: "#eef0f8", fg: "#404f7c")
                }
            }

            // Advanced Search
            FeatureCard(title: "Advanced Search") {
                Text("A unified search bar across the Search tab lets you explore MCA through three lenses at once:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: 6) {
                    SearchModeRow(label: "Pathway", description: "Browse KEGG pathways — for each pathway, see the linked MCA taxa and the diseases it touches.")
                    SearchModeRow(label: "Taxon", description: "Pick any MCA taxon to see the pathways it participates in, the diseases that share those pathways, and co-occurring taxa.")
                    SearchModeRow(label: "Disease", description: "Pick a disease to see the pathways implicated and the MCA taxa connected through them.")
                }
                Text("Type a few letters and the suggestions group by type — tap to open a result. From inside a result, tap any badge to cross-navigate (pathway \u{2192} disease \u{2192} taxon) without losing your place.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // On-Device Extractor
            FeatureCard(title: "On-Device AI Extractor") {
                Text("An optional, opt-in tool that helps you suggest papers for the atlas. Runs entirely on your device with Gemma 4 by Google — nothing leaves your phone unless you tap Send in Mail.")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("How it works")
                    .font(.caption.bold())
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                VStack(alignment: .leading, spacing: 6) {
                    ExtractorStepRow(number: 1, text: "Open the Extractor tab and tap Enable. The on-device AI model (~3.6 GB) downloads once and is cached for future use.")
                    ExtractorStepRow(number: 2, text: "Enter a PubMed ID for a paper you find interesting.")
                    ExtractorStepRow(number: 3, text: "Choose Abstract or Full Text. If the full text isn\u{2019}t freely available on PMC, upload the PDF from your device.")
                    ExtractorStepRow(number: 4, text: "Gemma 4 scans the text on-device and surfaces a PubMed ID, DOI, title, abstract, and a list of candidate taxa. All of this stays on your phone.")
                    ExtractorStepRow(number: 5, text: "Review the suggestion, add an optional note, then tap Share to MCA team. Mail opens pre-filled — you tap Send. Only the PMID and your note are sent.")
                }
                Text("Gemma 4 is a general-purpose language model, not microbiology-specific, so the candidate list may include unrelated terms. Please review before sharing.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)

                Text("Full text extraction on-device is limited; we are exploring another approach.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)

                Text("Requires an iPhone 15 Pro or newer.")
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#888888"))
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Pipeline

    private var pipelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("Curation Process")
            Text("Each Taxon Passport is assembled by a two-skill AI-assisted curation pipeline. An expert curator reviews every staging file before any changes are committed to the database.")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 0) {
                PipelineStep(number: 1, title: "Paper Analysis", description: "A PDF is submitted to the Paper Curator skill. An analyst agent reads the full paper, extracts metadata, and identifies all microbial taxa mentioned.")
                PipelineStep(number: 2, title: "Database Fetch & Entity Extraction", description: "Per taxon, agents query NCBI Taxonomy and BacDive for biology/ecology fields, while an Entity Extractor reads the paper for the clinical layer.")
                PipelineStep(number: 3, title: "Routing, Grading & Ontology Enrichment", description: "A Routing agent checks CREATE vs UPDATE. A Grading agent assigns E1/E2/E3. Enrichment agents run MeSH, KEGG, and ARO lookups in parallel.")
                PipelineStep(number: 4, title: "Expert Review", description: "Every staging file — the full Taxon Passport plus its clinical associations — is routed to outside domain experts through a token-gated review portal. Reviewers can flag any field they see: biology, ecology, clinical profile, metabolites, synonyms, ontology references, and PMIDs. For each clinical association, they also assess the evidence grade (E3 / E2 / E1 / Undetermined) and judge whether the curated text is Accurate, Overstated, Understated, or Unsure, with free-text comments for additional context.", dotColor: "#166534")
                PipelineStep(number: 5, title: "XML Update & SQL Export", description: "Approved staging files are applied to the versioned XML database. A content hash deduplicates associations. A full SQL dump is generated automatically.", isLast: true)
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Data Model

    private var dataModelSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("Data Model")
            Text("Each Taxon Passport is the central record, linked to satellite tables via a surrogate integer primary key.")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                DataModelRow(layer: "Identity", fields: "passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, synonyms", source: "NCBI Taxonomy")
                DataModelRow(layer: "Biology", fields: "gram_status, oxygen_tolerance, morphology, key_traits", source: "BacDive")
                DataModelRow(layer: "Ecology", fields: "primary_niches, reservoirs, transmission_routes", source: "Literature; BacDive")
                DataModelRow(layer: "Clinical", fields: "is_pathobiont, clinical_roles, typical_specimens, bloom_triggers, risk_contexts, amr_highlights", source: "Curated literature")
                DataModelRow(layer: "Metabolites", fields: "metabolite_name, relationship, KEGG Compound, ChEBI", source: "Literature; KEGG")
                DataModelRow(layer: "Associations", fields: "text, evidence_level, content_hash, MeSH/KEGG refs, PMIDs", source: "Literature; NLM; KEGG")
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Acknowledgements

    private var acknowledgementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("Acknowledgements")
            Text("MCA integrates data from the following publicly available resources. We gratefully acknowledge the teams that build and maintain them.")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                AckRow(name: "NCBI Taxonomy", use: "Taxon lineage, rank, preferred name, synonyms, TaxID", url: "https://www.ncbi.nlm.nih.gov/taxonomy")
                AckRow(name: "NLM MeSH", use: "MeSH term annotations on clinical associations", url: "https://meshb.nlm.nih.gov")
                AckRow(name: "BacDive", use: "Gram status, oxygen tolerance, morphology, key traits", url: "https://bacdive.dsmz.de")
                AckRow(name: "KEGG", use: "Disease, Drug, and Compound IDs", url: "https://www.kegg.jp")
                AckRow(name: "CARD / ARO", use: "Antibiotic Resistance Ontology identifiers", url: "https://card.mcmaster.ca")
                AckRow(name: "Google Gemma 4", use: "On-device language model powering the Extractor (Apache 2.0)", url: "https://ai.google.dev/gemma")
                AckRow(name: "Apple MLX", use: "On-device tensor framework used by the Extractor (MIT)", url: "https://github.com/ml-explore/mlx-swift")
                AckRow(name: "Hugging Face", use: "Tokenizers and model hosting for the Extractor", url: "https://huggingface.co")
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Contact

    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle("Contact")
            Text("We would love to hear from you. If you would like to suggest specific papers for inclusion in MCA, or if you have spotted an error in any of the records, please reach out to us — we appreciate every contribution and will do our best to respond promptly.")
                .font(.caption)
                .foregroundColor(.secondary)
            Link("bioinformatics@ucalgary.ca", destination: URL(string: "mailto:bioinformatics@ucalgary.ca")!)
                .font(.footnote).bold()
                .foregroundColor(Color(hex: "#404f7c"))
        }
        .padding(.vertical, 16)
    }
}

// MARK: - Reusable Components

private struct SectionTitle: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.primary)
    }
}

private struct StatCard: View {
    let number: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.title2).bold()
                .foregroundColor(Color(hex: "#404f7c"))
            Text(label.uppercased())
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct FeatureCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.footnote).bold()
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct PathobiontKeyRow: View {
    let label: String
    let description: String
    let bg: String
    let fg: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.caption2).bold()
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Color(hex: bg))
                .foregroundColor(Color(hex: fg))
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct EvidenceKeyRow: View {
    let grade: String
    let description: String

    private var colors: EvidenceColors { EvidenceColors.forGrade(grade) }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(grade)
                .font(.caption2).bold()
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(colors.bg)
                .foregroundColor(colors.text)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct SearchModeRow: View {
    let label: String
    let description: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.caption2).bold()
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Color(hex: "#eef0f8"))
                .foregroundColor(Color(hex: "#404f7c"))
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct ExtractorStepRow: View {
    let number: Int
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#404f7c"))
                    .frame(width: 18, height: 18)
                Text("\(number)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            }
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct DbLinkRow: View {
    let label: String
    let description: String
    let bg: String
    let fg: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.caption2).bold()
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Color(hex: bg))
                .foregroundColor(Color(hex: fg))
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct PipelineStep: View {
    let number: Int
    let title: String
    let description: String
    var isLast = false
    var dotColor: String = "#404f7c"

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color(hex: dotColor))
                        .frame(width: 28, height: 28)
                    Text("\(number)")
                        .font(.caption2).bold()
                        .foregroundColor(.white)
                }
                if !isLast {
                    Rectangle()
                        .fill(Color(.separator))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.footnote).bold()
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, isLast ? 0 : 16)
        }
    }
}

private struct DataModelRow: View {
    let layer: String
    let fields: String
    let source: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(layer)
                .font(.caption).bold()
            Text(fields)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("Source: \(source)")
                .font(.caption2)
                .foregroundColor(Color(hex: "#404f7c"))
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private struct AckRow: View {
    let name: String
    let use: String
    let url: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Text(name).font(.caption).bold()
                Link("(\(url.replacingOccurrences(of: "https://", with: "")))", destination: URL(string: url)!)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#404f7c"))
            }
            Text(use).font(.caption2).foregroundColor(.secondary)
        }
    }
}
