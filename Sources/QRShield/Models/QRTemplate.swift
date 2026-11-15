import SwiftUI

public enum QRTemplateCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case social = "Social"
    case wifi = "Wi-Fi"
    case business = "Business"
    case event = "Event"
    
    public var id: String { rawValue }
}

public struct QRTemplate: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let category: QRTemplateCategory
    public let badgeText: String?
    public let styleConfig: QRStyleConfig
    public let defaultTitle: String
    public let defaultContent: String
    public let previewGradientHex: [String]
    
    public init(
        id: String,
        name: String,
        category: QRTemplateCategory,
        badgeText: String? = nil,
        styleConfig: QRStyleConfig,
        defaultTitle: String,
        defaultContent: String,
        previewGradientHex: [String]
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.badgeText = badgeText
        self.styleConfig = styleConfig
        self.defaultTitle = defaultTitle
        self.defaultContent = defaultContent
        self.previewGradientHex = previewGradientHex
    }
}

public extension QRTemplate {
    static let predefinedTemplates: [QRTemplate] = [
        QRTemplate(
            id: "instagram",
            name: "Instagram",
            category: .social,
            badgeText: nil,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .instagram,
                frameStyle: .none
            ),
            defaultTitle: "My Instagram",
            defaultContent: "https://instagram.com/qrshield",
            previewGradientHex: ["F58529", "DD2A7B", "8134AF"]
        ),
        QRTemplate(
            id: "youtube",
            name: "YouTube",
            category: .social,
            badgeText: nil,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .youtube,
                frameStyle: .none
            ),
            defaultTitle: "YouTube Channel",
            defaultContent: "https://youtube.com/@qrshield",
            previewGradientHex: ["EF4444", "B91C1C"]
        ),
        QRTemplate(
            id: "wifi",
            name: "Wi-Fi Network",
            category: .wifi,
            badgeText: nil,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                frameStyle: .none
            ),
            defaultTitle: "Home Wi-Fi",
            defaultContent: "WIFI:T:WPA;S:Home_Network;P:MySafePass123;;",
            previewGradientHex: ["06B6D4", "3B82F6"]
        ),
        QRTemplate(
            id: "whatsapp",
            name: "WhatsApp",
            category: .social,
            badgeText: nil,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .whatsapp,
                frameStyle: .none
            ),
            defaultTitle: "WhatsApp Contact",
            defaultContent: "https://wa.me/15551234567",
            previewGradientHex: ["10B981", "059669"]
        ),
        QRTemplate(
            id: "black_friday",
            name: "Black Friday %",
            category: .business,
            badgeText: "Black Friday %",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                frameStyle: .cardBorder
            ),
            defaultTitle: "Black Friday Sale",
            defaultContent: "https://myshop.com/blackfriday",
            previewGradientHex: ["1F2937", "111827"]
        ),
        QRTemplate(
            id: "sale",
            name: "SALE Event",
            category: .business,
            badgeText: "SALE",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                frameStyle: .scanMeBottom
            ),
            defaultTitle: "Flash Sale Promo",
            defaultContent: "https://myshop.com/sale",
            previewGradientHex: ["EF4444", "DC2626"]
        ),
        QRTemplate(
            id: "hearts",
            name: "Valentine Love",
            category: .event,
            badgeText: "♥",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFF1F2",
                logoType: .heart,
                frameStyle: .none
            ),
            defaultTitle: "Special Surprise",
            defaultContent: "https://qrshield.app/love",
            previewGradientHex: ["F43F5E", "FB7185"]
        ),
        QRTemplate(
            id: "waves",
            name: "Ocean Waves",
            category: .event,
            badgeText: nil,
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .oceanBlue,
                backgroundColorHex: "F0F9FF",
                logoType: .shield,
                frameStyle: .neonGlow
            ),
            defaultTitle: "Beach Festival",
            defaultContent: "https://beachfestival.com",
            previewGradientHex: ["0EA5E9", "2563EB"]
        )
    ]
}
