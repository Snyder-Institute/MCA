import Foundation

struct CachedExtraction: Codable, Identifiable, Hashable {
    let id: UUID
    let pmid: String
    let paperTitle: String
    let sourceType: String
    let extractionDate: Date
    let taxonCount: Int
    let passports: [ExtractedPassport]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: CachedExtraction, rhs: CachedExtraction) -> Bool { lhs.id == rhs.id }
}

struct ExtractionCache {
    private static var cacheDirectory: URL {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!
        let dir = appSupport.appendingPathComponent("ExtractionCache", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    static func save(_ extraction: CachedExtraction) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(extraction) else { return }
        let file = cacheDirectory.appendingPathComponent("\(extraction.id.uuidString).json")
        try? data.write(to: file, options: .atomic)
    }

    static func loadAll() -> [CachedExtraction] {
        let fm = FileManager.default
        let dir = cacheDirectory
        guard let files = try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else {
            return []
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return files
            .filter { $0.pathExtension == "json" }
            .compactMap { url -> CachedExtraction? in
                guard let data = try? Data(contentsOf: url) else { return nil }
                return try? decoder.decode(CachedExtraction.self, from: data)
            }
            .sorted { $0.extractionDate > $1.extractionDate }
    }

    static func find(pmid: String) -> CachedExtraction? {
        loadAll().first { $0.pmid == pmid }
    }

    static func delete(id: UUID) {
        let file = cacheDirectory.appendingPathComponent("\(id.uuidString).json")
        try? FileManager.default.removeItem(at: file)
    }
}
