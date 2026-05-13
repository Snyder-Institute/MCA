import Foundation
import Gemma4Swift

@MainActor
@Observable
final class ExtractorPackDownloader {

    enum State: Equatable {
        case idle
        case downloading
        case ready
        case failed(String)
    }

    static let model: Gemma4Pipeline.Model = .e2b4bit

    private(set) var state: State = .idle
    private(set) var progress: Double = 0
    private(set) var currentFile: String = ""

    func download() async {
        guard state != .downloading else { return }

        if Gemma4ModelCache.isDownloaded(Self.model) {
            state = .ready
            progress = 1
            return
        }

        state = .downloading
        progress = 0
        currentFile = ""

        do {
            _ = try await Gemma4ModelDownloader.download(Self.model, token: nil) { [weak self] prog in
                guard let self else { return }
                Task { @MainActor in
                    self.progress = prog.fraction
                    self.currentFile = prog.currentFile
                }
            }
            state = .ready
            progress = 1
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func purge() {
        if let path = Gemma4ModelCache.localPath(for: Self.model) {
            try? FileManager.default.removeItem(at: path)
        }
        state = .idle
        progress = 0
        currentFile = ""
    }
}
