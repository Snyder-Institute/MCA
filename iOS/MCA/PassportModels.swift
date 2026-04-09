import Foundation

struct Passport: Identifiable {
    let id: Int64
    let passportId: String
    let preferredName: String
    let taxonRank: String
    let domain: String
    let lineage: String
    let ncbiTaxid: Int?
    let isPathobiont: String
    let lastReviewed: String?
}

struct Biology {
    let gramStatus: String?
    let oxygenTolerance: String?
    let morphology: String?
    let bacdiveUrl: String?
}

struct TaxonTag: Identifiable {
    let id: Int64
    let category: String
    let value: String
    let extId: String?
}

struct Metabolite: Identifiable {
    let id: Int64
    let name: String
    let relationship: String
    let keggCompoundId: String?
    let chebiId: String?
}

struct Association: Identifiable {
    let id: Int64
    let text: String
    let evidenceGrade: String
    let pmids: [String]
    let refs: [AssocRef]
}

struct AssocRef: Identifiable {
    let id: Int64
    let refType: String
    let refId: String
    let refLabel: String
}

struct Paper: Identifiable {
    let pmid: String
    let title: String
    let year: Int?
    let studyDesign: String?

    var id: String { pmid }
}

struct RelatedTaxon: Identifiable {
    let dbId: Int64
    let passportId: String
    let preferredName: String
    let isPathobiont: String
    let matchCategories: Set<String>

    var id: Int64 { dbId }
}

struct PassportDetail {
    let passport: Passport
    let biology: Biology?
    let tags: [TaxonTag]
    let metabolites: [Metabolite]
    let associations: [Association]
    let evidencePmids: [String]
    let papers: [Paper]
    let relatedTaxa: [RelatedTaxon]
}
