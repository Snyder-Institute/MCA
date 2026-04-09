import Foundation

struct PubMedResult {
    let pmid: String
    let title: String
    let abstract: String
}

enum PubMedError: LocalizedError {
    case notFound
    case noAbstract
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .notFound: return "Paper not found on PubMed."
        case .noAbstract: return "Abstract not available for this paper."
        case .networkError(let msg): return "Network error: \(msg)"
        }
    }
}

struct PubMedService {

    /// Fetch paper metadata from PubMed. If input is all digits, treat as PMID; otherwise clean up and search by title.
    static func fetch(query: String) async throws -> PubMedResult {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let pmid: String

        if trimmed.allSatisfy(\.isNumber) {
            pmid = trimmed
        } else {
            let cleaned = cleanScannedText(trimmed)
            pmid = try await searchPmid(title: cleaned)
        }

        return try await fetchByPmid(pmid)
    }

    /// Strip URLs, DOIs, and common OCR noise from scanned text to get a clean title for PubMed search.
    private static func cleanScannedText(_ text: String) -> String {
        var result = text
        // Remove URLs (https://..., http://..., doi.org/...)
        result = result.replacingOccurrences(of: "https?://\\S+", with: "", options: .regularExpression)
        // Remove bare DOIs (10.xxxx/...)
        result = result.replacingOccurrences(of: "\\b10\\.\\d{4,}/\\S+", with: "", options: .regularExpression)
        // Remove common OCR prefixes
        result = result.replacingOccurrences(of: "^\\s*(Article|DOI|doi)\\s*:?\\s*", with: "", options: .regularExpression)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Try to fetch full article text from PMC (open access). Returns nil if not available.
    static func fetchFullText(pmid: String) async -> String? {
        // Step 1: Convert PMID → PMCID
        guard let pmcid = await convertToPMCID(pmid: pmid) else { return nil }

        // Step 2: Fetch full XML from PMC
        guard let url = URL(string: "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id=\(pmcid)&rettype=xml") else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parser = PMCSectionParser(data: data)
            let sections = parser.parse()
            guard !sections.isEmpty else { return nil }

            // Assemble in priority order: Abstract → Discussion → Results → Introduction → Methods
            let charCap = 25000
            var assembled = ""
            let order: [PMCSectionParser.SectionKind] = [.abstract, .discussion, .results, .introduction, .methods]
            for kind in order {
                guard let text = sections[kind], !text.isEmpty else { continue }
                let remaining = charCap - assembled.count
                guard remaining > 100 else { break }
                let label = "[\(kind.rawValue.uppercased())]\n"
                let maxTextLen = remaining - label.count - 2 // 2 for \n\n
                let truncated = String(text.prefix(maxTextLen))
                assembled += label + truncated + "\n\n"
            }

            return String(assembled.prefix(charCap))
        } catch {
            return nil
        }
    }

    private static func convertToPMCID(pmid: String) async -> String? {
        guard let url = URL(string: "https://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0/?ids=\(pmid)&format=json&tool=MCA-iOS&email=bioinformatics@ucalgary.ca") else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let records = json["records"] as? [[String: Any]],
                  let first = records.first,
                  let pmcid = first["pmcid"] as? String else {
                return nil
            }
            return pmcid
        } catch {
            return nil
        }
    }

    // MARK: - Private

    private static func searchPmid(title: String) async throws -> String {
        guard let encoded = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmax=1&retmode=json&term=\(encoded)") else {
            throw PubMedError.networkError("Invalid search URL")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        struct ESearchResponse: Decodable {
            struct Result: Decodable {
                let idlist: [String]
            }
            let esearchresult: Result
        }

        let response = try JSONDecoder().decode(ESearchResponse.self, from: data)
        guard let first = response.esearchresult.idlist.first, !first.isEmpty else {
            throw PubMedError.notFound
        }
        return first
    }

    private static func fetchByPmid(_ pmid: String) async throws -> PubMedResult {
        guard let url = URL(string: "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&retmode=xml&id=\(pmid)") else {
            throw PubMedError.networkError("Invalid fetch URL")
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let parser = PubMedXMLParser(data: data)
        let parsed = parser.parse()

        guard !parsed.title.isEmpty else {
            throw PubMedError.notFound
        }

        if parsed.abstract.isEmpty {
            throw PubMedError.noAbstract
        }

        return PubMedResult(pmid: pmid, title: parsed.title, abstract: parsed.abstract)
    }
}

// MARK: - XML Parser

private class PubMedXMLParser: NSObject, XMLParserDelegate {
    private let data: Data
    private var currentElement = ""
    private var title = ""
    private var abstractParts: [String] = []
    private var pmid = ""
    private var captureText = false
    private var currentText = ""

    init(data: Data) {
        self.data = data
    }

    struct ParsedResult {
        let pmid: String
        let title: String
        let abstract: String
    }

    func parse() -> ParsedResult {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return ParsedResult(
            pmid: pmid,
            title: title,
            abstract: abstractParts.joined(separator: " ")
        )
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName: String?,
                attributes: [String: String] = [:]) {
        currentElement = elementName
        if elementName == "ArticleTitle" || elementName == "AbstractText" || elementName == "PMID" {
            captureText = true
            currentText = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if captureText {
            currentText += string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName: String?) {
        if elementName == "ArticleTitle" {
            title = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if elementName == "AbstractText" {
            let text = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !text.isEmpty {
                abstractParts.append(text)
            }
        } else if elementName == "PMID" && pmid.isEmpty {
            pmid = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        captureText = false
        currentText = ""
    }
}

// MARK: - PMC Section Parser

/// Extracts plain text from PMC full-text XML, grouped by section type.
private class PMCSectionParser: NSObject, XMLParserDelegate {
    enum SectionKind: String, Hashable {
        case abstract, introduction, results, discussion, methods, other
    }

    private let data: Data
    private var sections: [SectionKind: String] = [:]

    // Section tracking
    private var insideBody = false
    private var insideAbstract = false
    private var topLevelSecDepth = 0
    private var currentKind: SectionKind = .other
    private var currentSectionText = ""
    private var pendingSectionTitle = ""

    // Depth tracking
    private var bodyDepth = 0
    private var secDepth = 0

    // Skip non-content elements (tables, figures, refs, supplementary)
    private var skipDepth = 0
    private var skipping = false
    private static let skipElements: Set<String> = ["table-wrap", "fig", "supplementary-material", "ref-list"]

    // Title capture
    private var capturingTitle = false
    private var titleDepth = 0
    private var titleText = ""

    init(data: Data) {
        self.data = data
    }

    func parse() -> [SectionKind: String] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        // Flush last section
        flushSection()
        // Clean up whitespace in each section
        for (key, val) in sections {
            sections[key] = val
                .components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
                .joined(separator: " ")
        }
        return sections
    }

    private func flushSection() {
        let text = currentSectionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        if let existing = sections[currentKind] {
            sections[currentKind] = existing + " " + text
        } else {
            sections[currentKind] = text
        }
        currentSectionText = ""
    }

    private func classifySection(secType: String?, title: String) -> SectionKind {
        // Check sec-type attribute first
        if let st = secType?.lowercased() {
            if st.contains("result") { return .results }
            if st.contains("discussion") { return .discussion }
            if st.contains("method") || st.contains("material") { return .methods }
            if st.contains("intro") { return .introduction }
        }
        // Fall back to title text
        let t = title.lowercased()
        if t.contains("result") { return .results }
        if t.contains("discussion") { return .discussion }
        if t.contains("method") || t.contains("material") { return .methods }
        if t.contains("intro") || t == "main" || t == "background" { return .introduction }
        return .other
    }

    // MARK: - XMLParserDelegate

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName: String?,
                attributes: [String: String] = [:]) {
        // Abstract (outside body)
        if elementName == "abstract" {
            insideAbstract = true
            currentKind = .abstract
            return
        }
        if elementName == "body" {
            insideBody = true
            bodyDepth = 0
            return
        }

        guard insideBody || insideAbstract else { return }

        if insideBody {
            bodyDepth += 1

            // Track top-level sections (direct children of body)
            if elementName == "sec" {
                secDepth += 1
                if secDepth == 1 {
                    // New top-level section — flush previous
                    flushSection()
                    let secType = attributes["sec-type"]
                    pendingSectionTitle = ""
                    // Pre-classify from sec-type; may be refined by title
                    currentKind = classifySection(secType: secType, title: "")
                    topLevelSecDepth = bodyDepth
                }
            }

            // Capture title of top-level sec
            if elementName == "title" && secDepth == 1 && bodyDepth == topLevelSecDepth + 1 {
                capturingTitle = true
                titleDepth = bodyDepth
                titleText = ""
            }

            // Skip non-content elements
            if Self.skipElements.contains(elementName) && !skipping {
                skipping = true
                skipDepth = bodyDepth
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if insideAbstract && !insideBody {
            currentSectionText += string
            return
        }
        guard insideBody else { return }

        if capturingTitle {
            titleText += string
        }
        if !skipping {
            currentSectionText += string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName: String?) {
        if elementName == "abstract" && insideAbstract {
            insideAbstract = false
            flushSection()
            currentKind = .other
            return
        }

        guard insideBody else { return }

        // Finish title capture and reclassify section
        if capturingTitle && elementName == "title" && bodyDepth == titleDepth {
            capturingTitle = false
            let title = titleText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !title.isEmpty {
                currentKind = classifySection(secType: nil, title: title)
            }
        }

        // End skip
        if skipping && bodyDepth == skipDepth {
            skipping = false
        }

        // Add newlines after block elements
        if !skipping && (elementName == "p" || elementName == "title") {
            currentSectionText += "\n"
        }

        if elementName == "sec" {
            secDepth -= 1
        }

        bodyDepth -= 1

        if elementName == "body" {
            insideBody = false
            flushSection()
        }
    }
}
