import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3:  (r, g, b) = (((int >> 8) & 0xF) * 17, ((int >> 4) & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

// MARK: - Evidence Grade Colors

struct EvidenceColors {
    let bg: Color
    let text: Color
    let border: Color

    static func forGrade(_ grade: String) -> EvidenceColors {
        switch grade {
        case "E3": return EvidenceColors(bg: Color(hex: "#dcfce7"), text: Color(hex: "#166534"), border: Color(hex: "#4ade80"))
        case "E2": return EvidenceColors(bg: Color(hex: "#fef3c7"), text: Color(hex: "#92400e"), border: Color(hex: "#fbbf24"))
        default:   return EvidenceColors(bg: Color(hex: "#e5e7eb"), text: Color(hex: "#6b7280"), border: Color(hex: "#d1d5db"))
        }
    }
}
