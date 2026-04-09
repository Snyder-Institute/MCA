import Foundation

enum ClaudeError: LocalizedError {
    case invalidApiKey
    case rateLimited
    case apiError(Int)
    case parseError
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .invalidApiKey: return "Extraction requires a Claude API key.\nPlease provide a valid API key."
        case .rateLimited: return "Rate limited. Please wait a moment and try again."
        case .apiError(let code): return "Claude API error (HTTP \(code))."
        case .parseError: return "Failed to parse Claude's response."
        case .networkError(let msg): return "Network error: \(msg)"
        }
    }
}

struct ClaudeService {

    static func extract(title: String, pmid: String, abstract: String) async throws -> [ExtractedPassport] {
        guard let apiKey = KeychainHelper.load(account: KeychainHelper.apiKeyAccount), !apiKey.isEmpty else {
            throw ClaudeError.invalidApiKey
        }

        let prompt = buildPrompt(title: title, pmid: pmid, abstract: abstract)

        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue("application/json", forHTTPHeaderField: "content-type")

        let body: [String: Any] = [
            "model": "claude-opus-4-6",
            "max_tokens": 8192,
            "system": "You are a microbiology entity extractor for the Microbial Clinical Atlas (MCA). You MUST extract EVERY microbial taxon mentioned in the paper — not just the primary organism. If a paper mentions 5 taxa, return 5 objects. Always return a JSON array, even for a single taxon.",
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClaudeError.networkError("Invalid response")
        }

        switch httpResponse.statusCode {
        case 200: break
        case 401: throw ClaudeError.invalidApiKey
        case 429: throw ClaudeError.rateLimited
        default:  throw ClaudeError.apiError(httpResponse.statusCode)
        }

        // Parse the API response to get the text content
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let first = content.first,
              let text = first["text"] as? String else {
            throw ClaudeError.parseError
        }

        let cleaned = stripCodeBlock(text)

        // Decode the Claude-generated JSON into array of ExtractedPassport
        guard let passportData = cleaned.data(using: .utf8) else {
            throw ClaudeError.parseError
        }

        do {
            return try JSONDecoder().decode([ExtractedPassport].self, from: passportData)
        } catch {
            do {
                let single = try JSONDecoder().decode(ExtractedPassport.self, from: passportData)
                return [single]
            } catch {
                throw ClaudeError.parseError
            }
        }
    }

    // MARK: - Private

    private static func stripCodeBlock(_ text: String) -> String {
        var result = text.trimmingCharacters(in: .whitespacesAndNewlines)
        // Remove ```json or ``` prefix
        if result.hasPrefix("```") {
            if let end = result.firstIndex(of: "\n") {
                result = String(result[result.index(after: end)...])
            }
        }
        // Remove trailing ```
        if result.hasSuffix("```") {
            result = String(result.dropLast(3))
        }
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        // Extract JSON array or object if there's extra text around it
        if result.hasPrefix("["), let end = result.lastIndex(of: "]") {
            result = String(result[result.startIndex...end])
        } else if let start = result.firstIndex(of: "["), let end = result.lastIndex(of: "]") {
            result = String(result[start...end])
        } else if let start = result.firstIndex(of: "{"), let end = result.lastIndex(of: "}") {
            result = String(result[start...end])
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func buildPrompt(title: String, pmid: String, abstract: String) -> String {
        """
        Paper Title: \(title)
        PMID: \(pmid)
        Paper text: \(abstract)

        ---

        Task: Extract one Taxon Passport per microbial taxon mentioned in the paper text above.

        First, scan the text and identify every distinct microbial organism name (genus, species, \
        family, or strain level). Include taxa mentioned in results, conclusions, AND background context. \
        Then produce a JSON array with one passport object for each taxon found.

        Output format — a JSON array (no markdown fences, no commentary before or after):
        [
          {
            "taxon_name": "Genus species",
            "taxon_rank": "species",
            "gram_status": "gram-positive|gram-negative|not applicable|unknown",
            "oxygen_tolerance": "aerobe|facultative anaerobe|obligate anaerobe|microaerophile|not applicable|unknown",
            "morphology": "bacillus (rod)|coccus|coccobacillus|spirochete|yeast|mold|not applicable|unknown",
            "key_traits": [],
            "clinical_roles": [],
            "primary_niches": [],
            "clinical_associations": [{"text": "claim", "evidence_level": "E1|E2|E3"}],
            "metabolites": [],
            "source_pmid": "\(pmid)",
            "source_title": "\(title)"
          }
        ]

        Important:
        - Return one object per taxon. If the text names 6 organisms, the array must have 6 objects.
        - Use null or [] for fields not reported for a given taxon.
        - Each clinical_association is one discrete claim. Do not merge claims.
        - Evidence: E3=meta-analysis/systematic review, E2=single cohort/RCT/case-control, E1=animal/in-vitro/case-report.
        - Output ONLY the JSON array. No text before or after.
        """
    }
}
