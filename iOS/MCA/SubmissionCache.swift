import Foundation

enum SubmissionCache {

    private static let dirName = "Submissions"

    static func directoryURL() -> URL? {
        guard let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        let dir = support.appendingPathComponent(dirName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    static func save(_ submission: SubmittedPMID) {
        guard let dir = directoryURL() else { return }
        let url = dir.appendingPathComponent("\(submission.id.uuidString).json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(submission) {
            try? data.write(to: url)
        }
    }

    static func loadAll() -> [SubmittedPMID] {
        guard let dir = directoryURL(),
              let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else {
            return []
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return files
            .filter { $0.pathExtension == "json" }
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap { try? decoder.decode(SubmittedPMID.self, from: $0) }
            .sorted { $0.sentAt > $1.sentAt }
    }

    static func delete(id: UUID) {
        guard let dir = directoryURL() else { return }
        let url = dir.appendingPathComponent("\(id.uuidString).json")
        try? FileManager.default.removeItem(at: url)
    }
}
