import Foundation

protocol LLMService {
    var isReady: Bool { get }
    func extractMetadata(text: String, knownPMID: String?) async throws -> ExtractedMetadata
}

/// Regex-only fallback used both as the standalone service before Gemma 4 lands,
/// and as a pre-pass alongside the LLM once it does.
struct MockLLMService: LLMService {
    var isReady: Bool { true }

    func extractMetadata(text: String, knownPMID: String?) async throws -> ExtractedMetadata {
        try await Task.sleep(nanoseconds: 600_000_000)
        let pmid = knownPMID ?? Self.pmidRegex(in: text) ?? ""
        let doi = Self.doiRegex(in: text)
        let taxa = Self.candidateTaxa(in: text, limit: 12)
        return ExtractedMetadata(
            pmid: pmid,
            doi: doi,
            title: "",
            abstract: String(text.prefix(800)),
            candidateTaxa: taxa
        )
    }

    // MARK: - Regex helpers

    static func pmidRegex(in text: String) -> String? {
        let pattern = #"(?i)PMID[:\s]*?(\d{6,9})"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              match.numberOfRanges >= 2,
              let r = Range(match.range(at: 1), in: text) else { return nil }
        return String(text[r])
    }

    static func doiRegex(in text: String) -> String? {
        let pattern = #"10\.\d{4,}/[\w.\-()/:]+"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              let r = Range(match.range, in: text) else { return nil }
        return String(text[r])
    }

    /// Surfaces likely binomial scientific names (Genus species) using a conservative pattern.
    /// Order preserved by first mention; duplicates removed (case-insensitive).
    static func candidateTaxa(in text: String, limit: Int = 12) -> [String] {
        let pattern = #"\b([A-Z][a-z]{2,})\s+([a-z]{3,}(?:[-\s][a-z]{3,})?)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)

        var seen = Set<String>()
        var ordered: [String] = []
        for match in matches {
            guard match.numberOfRanges >= 3,
                  let r = Range(match.range, in: text) else { continue }
            let candidate = String(text[r])
            if !Self.isLikelyTaxon(candidate) { continue }
            let key = candidate.lowercased()
            if seen.contains(key) { continue }
            seen.insert(key)
            ordered.append(candidate)
            if ordered.count >= limit { break }
        }
        return ordered
    }

    /// Filters out obvious false positives (English noun phrases, journal names, place names).
    private static func isLikelyTaxon(_ candidate: String) -> Bool {
        let lower = candidate.lowercased()
        for stop in Self.stopBigrams where lower.hasPrefix(stop) { return false }
        let firstWord = candidate.components(separatedBy: " ").first ?? ""
        if Self.commonEnglishCapitalized.contains(firstWord) { return false }
        return true
    }

    private static let stopBigrams: [String] = [
        "the ", "this ", "these ", "those ", "supplementary ", "table ", "figure ",
        "we ", "our ", "their ", "results ", "discussion ", "introduction ",
        "methods ", "abstract ", "conclusion ", "background "
    ]

    private static let commonEnglishCapitalized: Set<String> = [
        "The", "This", "These", "Those", "We", "Our", "Their",
        "Results", "Discussion", "Introduction", "Methods", "Abstract",
        "Conclusion", "Background", "Table", "Figure", "Supplementary",
        "United", "American", "European", "African", "Asian",
        "Hospital", "University", "Department", "Institute"
    ]
}
