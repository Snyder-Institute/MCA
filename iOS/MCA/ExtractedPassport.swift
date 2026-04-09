import Foundation

struct ExtractedPassport: Codable, Identifiable {
    let id = UUID()
    var taxonName: String
    var taxonRank: String?
    var gramStatus: String?
    var oxygenTolerance: String?
    var morphology: String?
    var keyTraits: [String]
    var clinicalRoles: [String]
    var primaryNiches: [String]
    var clinicalAssociations: [ExtractedAssociation]
    var metabolites: [String]
    var sourcePmid: String?
    var sourceTitle: String?

    enum CodingKeys: String, CodingKey {
        case taxonName = "taxon_name"
        case taxonRank = "taxon_rank"
        case gramStatus = "gram_status"
        case oxygenTolerance = "oxygen_tolerance"
        case morphology
        case keyTraits = "key_traits"
        case clinicalRoles = "clinical_roles"
        case primaryNiches = "primary_niches"
        case clinicalAssociations = "clinical_associations"
        case metabolites
        case sourcePmid = "source_pmid"
        case sourceTitle = "source_title"
    }
}

struct ExtractedAssociation: Codable, Identifiable {
    let id = UUID()
    var text: String
    var evidenceLevel: String

    enum CodingKeys: String, CodingKey {
        case text
        case evidenceLevel = "evidence_level"
    }
}

// MARK: - Demo Data

extension ExtractedPassport {
    static let demoArray: [ExtractedPassport] = [
        ExtractedPassport(
            taxonName: "Escherichia coli",
            taxonRank: "species",
            gramStatus: "gram-negative",
            oxygenTolerance: "facultative anaerobe",
            morphology: "bacillus (rod)",
            keyTraits: ["biofilm-forming", "toxin-producing"],
            clinicalRoles: ["commensal", "opportunistic pathogen"],
            primaryNiches: ["gut", "urinary tract"],
            clinicalAssociations: [
                ExtractedAssociation(text: "Leading cause of uncomplicated urinary tract infections in women.", evidenceLevel: "E3"),
                ExtractedAssociation(text: "Enterotoxigenic strains (ETEC) are a major cause of traveler's diarrhea.", evidenceLevel: "E3"),
                ExtractedAssociation(text: "Gut abundance shifts observed in colorectal cancer microbiome studies.", evidenceLevel: "E1")
            ],
            metabolites: ["indole", "short-chain fatty acids", "vitamin K2"],
            sourcePmid: "00000000",
            sourceTitle: "Demo — no API call was made"
        ),
        ExtractedPassport(
            taxonName: "Faecalibacterium prausnitzii",
            taxonRank: "species",
            gramStatus: "gram-positive",
            oxygenTolerance: "obligate anaerobe",
            morphology: "bacillus (rod)",
            keyTraits: ["butyrate-producing"],
            clinicalRoles: ["commensal"],
            primaryNiches: ["gut"],
            clinicalAssociations: [
                ExtractedAssociation(text: "Reduced abundance consistently associated with inflammatory bowel disease.", evidenceLevel: "E3"),
                ExtractedAssociation(text: "Butyrate production supports intestinal barrier integrity.", evidenceLevel: "E2")
            ],
            metabolites: ["butyrate"],
            sourcePmid: "00000000",
            sourceTitle: "Demo — no API call was made"
        )
    ]
}
