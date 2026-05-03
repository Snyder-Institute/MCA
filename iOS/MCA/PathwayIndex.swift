import Foundation

struct PathwayInfo: Codable {
    let id: String
    let name: String
    let category: String
    let subcategory: String?
}

struct PassportKegg: Codable {
    let diseases: [String: String]
    let drugs: [String: String]
    let compounds: [String: String]
}

struct DrugClassInfo: Codable {
    let targetClass: String
    let targetFamily: String

    enum CodingKeys: String, CodingKey {
        case targetClass = "target_class"
        case targetFamily = "target_family"
    }
}

struct InfClassInfo: Codable {
    let category: String
    let subcategory: String
}

struct PathwayIndex: Codable {
    let pathways: [String: PathwayInfo]
    let diseaseNames: [String: String]
    let diseaseToPathways: [String: [String]]
    let diseaseToNt: [String: [String]]
    let ntToDiseases: [String: [String]]
    let pathwayToDiseases: [String: [String]]
    let pathwayToCompounds: [String: [String]]
    let compoundToPathways: [String: [String]]
    let compoundNames: [String: String]
    let drugNames: [String: String]
    let drugClass: [String: DrugClassInfo]
    let infClass: [String: InfClassInfo]
    let passportKegg: [String: PassportKegg]
    let passportNames: [String: String]
    let passportToPathways: [String: [String]]
    let pathwayToPassports: [String: [String]]
    let passportCooccurrence: [String: [String: Int]]

    enum CodingKeys: String, CodingKey {
        case pathways
        case diseaseNames = "disease_names"
        case diseaseToPathways = "disease_to_pathways"
        case diseaseToNt = "disease_to_nt"
        case ntToDiseases = "nt_to_diseases"
        case pathwayToDiseases = "pathway_to_diseases"
        case pathwayToCompounds = "pathway_to_compounds"
        case compoundToPathways = "compound_to_pathways"
        case compoundNames = "compound_names"
        case drugNames = "drug_names"
        case drugClass = "drug_class"
        case infClass = "inf_class"
        case passportKegg = "passport_kegg"
        case passportNames = "passport_names"
        case passportToPathways = "passport_to_pathways"
        case pathwayToPassports = "pathway_to_passports"
        case passportCooccurrence = "passport_cooccurrence"
    }

    static func load() -> PathwayIndex? {
        guard let url = Bundle.main.url(forResource: "kegg_pathway_index", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(PathwayIndex.self, from: data)
    }

    func pathwayInfo(for id: String) -> PathwayInfo {
        if let info = pathways[id] { return info }
        let base = id.components(separatedBy: "(").first ?? id
        return pathways[base] ?? PathwayInfo(id: id, name: id, category: "", subcategory: nil)
    }

    func taxonCount(for pathwayId: String) -> Int {
        pathwayToPassports[pathwayId]?.count ?? 0
    }
}
