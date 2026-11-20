import SwiftUI

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // The Exact 6-Color Dark Mode Palette
    static let darkBg = Color(hex: "06141B")           // Primary App Background (#06141B)
    static let darkSurface = Color(hex: "11212D")      // Elevated Surface / Card Background (#11212D)
    static let darkControl = Color(hex: "253745")      // Interactive Controls, Borders & Secondary Buttons (#253745)
    static let darkAccent = Color(hex: "4A5C6A")       // Primary Accent, Active Buttons & Highlights (#4A5C6A)
    static let darkTextMuted = Color(hex: "9BA8AB")    // Secondary Text & Inactive Icons (#9BA8AB)
    static let darkTextPrimary = Color(hex: "CCD0CF")  // Primary Text & Active Foreground (#CCD0CF)
    
    // QR Shield Brand Colors mapped to Dark Mode Palette
    static let shieldPurple = Color(hex: "4A5C6A")
    static let shieldDarkPurple = Color(hex: "253745")
    static let shieldLightPurple = Color(hex: "11212D")
    static let shieldBorderPurple = Color(hex: "253745")
    static let shieldGold = Color(hex: "F59E0B")
    static let shieldBackground = Color(hex: "06141B")
    static let shieldTextDark = Color(hex: "CCD0CF")
    static let shieldTextMuted = Color(hex: "9BA8AB")
    
    // Status colors
    static let shieldSafeGreen = Color(hex: "10B981")
    static let shieldSuspiciousAmber = Color(hex: "F59E0B")
    static let shieldDangerousRed = Color(hex: "EF4444")
}
