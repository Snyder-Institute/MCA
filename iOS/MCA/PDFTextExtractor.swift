import PDFKit

struct PDFTextExtractor {
    private static let charCap = 25000

    static func extract(from url: URL) -> String {
        guard let doc = PDFDocument(url: url) else { return "" }
        var text = ""
        for i in 0..<doc.pageCount {
            text += doc.page(at: i)?.string ?? ""
            text += "\n"
            if text.count >= charCap { break }
        }
        return String(text.prefix(charCap))
    }
}
