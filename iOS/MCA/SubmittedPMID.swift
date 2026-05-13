import Foundation

struct SubmittedPMID: Codable, Identifiable, Hashable {
    let id: UUID
    let pmid: String
    let note: String
    let sentAt: Date
    var status: Status

    enum Status: String, Codable, Hashable {
        case sent
        case cancelled
        case saved
    }
}
