import Foundation
import Gemma4Swift

/// Real on-device LLM backed by Gemma 4 E2B INT4 via mlx-swift.
/// Falls back to `MockLLMService` regex pre-pass for PMID/DOI extraction;
/// uses the model to surface candidate taxa from the paper text.
@MainActor
final class GemmaLLMService: LLMService {

    static let shared = GemmaLLMService()

    private let pipeline = Gemma4Pipeline()
    private var loadTask: Task<Void, Error>?

    var isReady: Bool { pipeline.isReady }

    /// Loads the model from the local cache (downloads via `ExtractorPackDownloader` first).
    func loadIfNeeded() async throws {
        if pipeline.isReady { return }
        if let task = loadTask {
            try await task.value
            return
        }
        let task = Task { [pipeline] in
            try await pipeline.load(.e2b4bit, multimodal: false)
        }
        loadTask = task
        do {
            try await task.value
        } catch {
            loadTask = nil
            throw error
        }
    }

    func extractMetadata(text: String, knownPMID: String?) async throws -> ExtractedMetadata {
        try await loadIfNeeded()

        // Regex pre-pass — always run; LLM augments for candidate taxa.
        let pmid = knownPMID ?? MockLLMService.pmidRegex(in: text) ?? ""
        let doi = MockLLMService.doiRegex(in: text)

        let truncated = String(text.prefix(4000))
        let prompt = """
        List microbial taxa (bacteria, archaea, fungi, viruses, protists) in the text below.
        Use scientific names. One per line. Skip humans, animals, plants, genes, proteins.

        \(truncated)
        """
        let system = "Microbiology entity extractor. Output one scientific name per line."

        var taxa: [String] = []
        do {
            let response = try await pipeline.chat(
                prompt: prompt,
                systemPrompt: system,
                temperature: 0.1,
                maxTokens: 256
            )
            taxa = Self.parseTaxa(response)
        } catch {
            // Fall back to regex-only if the model fails.
            taxa = MockLLMService.candidateTaxa(in: text, limit: 12)
        }

        // Free GPU/CPU memory after each extraction. iOS jetsam will SIGKILL
        // apps that exceed the per-process cap; on iPhone 15 Pro this is ~5 GB,
        // and Gemma 4 E2B 4-bit + KV cache crowds that limit if it stays resident.
        pipeline.unload()
        loadTask = nil

        let abstractCap = 800
        let abstractPreview = text.count > abstractCap
            ? String(text.prefix(abstractCap)) + "\u{2026}"
            : text

        return ExtractedMetadata(
            pmid: pmid,
            doi: doi,
            title: "",
            abstract: abstractPreview,
            candidateTaxa: taxa
        )
    }

    // MARK: - Output parsing

    private static func parseTaxa(_ raw: String) -> [String] {
        let lines = raw
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var seen = Set<String>()
        var ordered: [String] = []
        for line in lines {
            // Strip bullet markers and leading numbering
            var cleaned = line
            for prefix in ["- ", "* ", "• "] where cleaned.hasPrefix(prefix) {
                cleaned = String(cleaned.dropFirst(prefix.count))
            }
            cleaned = cleaned.replacingOccurrences(
                of: #"^\d+[\.\)]\s*"#,
                with: "",
                options: .regularExpression
            )
            cleaned = cleaned.trimmingCharacters(in: .whitespaces)
            guard !cleaned.isEmpty,
                  cleaned.count <= 80,
                  cleaned.first?.isUppercase == true else { continue }
            let key = cleaned.lowercased()
            if seen.contains(key) { continue }
            seen.insert(key)
            ordered.append(cleaned)
            if ordered.count >= 20 { break }
        }
        return ordered
    }
}
