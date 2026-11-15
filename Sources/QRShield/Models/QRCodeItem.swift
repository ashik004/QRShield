import SwiftUI

public struct QRCodeItem: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var title: String
    public var contentPreview: String
    public var rawContent: String
    public var contentType: QRContentType
    public var category: QRTemplateCategory
    public var createdAt: Date
    public var isFavorite: Bool
    public var styleConfig: QRStyleConfig
    public var templateId: String?
    public var customFooterText: String?
    
    public init(
        id: UUID = UUID(),
        title: String,
        contentPreview: String,
        rawContent: String,
        contentType: QRContentType,
        category: QRTemplateCategory,
        createdAt: Date = Date(),
        isFavorite: Bool = false,
        styleConfig: QRStyleConfig = QRStyleConfig(),
        templateId: String? = nil,
        customFooterText: String? = nil
    ) {
        self.id = id
        self.title = title
        self.contentPreview = contentPreview
        self.rawContent = rawContent
        self.contentType = contentType
        self.category = category
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        self.styleConfig = styleConfig
        self.templateId = templateId
        self.customFooterText = customFooterText
    }
    
    public var relativeTimeString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(createdAt) {
            let diffHours = calendar.dateComponents([.hour, .minute], from: createdAt, to: Date())
            if let hours = diffHours.hour, hours > 0 {
                return "\(hours)h ago"
            } else if let minutes = diffHours.minute, minutes > 5 {
                return "\(minutes)m ago"
            } else {
                return "Just now"
            }
        }
        let days = calendar.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
        if days == 1 {
            return "Yesterday"
        } else if days > 1 {
            return "\(days) days ago"
        }
        return "Recently"
    }
}

public extension QRCodeItem {
    static let sampleItems: [QRCodeItem] = [
        QRCodeItem(
            title: "My Instagram",
            contentPreview: "qrshield.app/ig",
            rawContent: "https://instagram.com/qrshield",
            contentType: .social,
            category: .social,
            createdAt: Date(),
            isFavorite: false,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .instagram
            )
        ),
        QRCodeItem(
            title: "Home Wi-Fi",
            contentPreview: "Wi-Fi",
            rawContent: "WIFI:T:WPA;S:Home_Network;P:MySafePass123;;",
            contentType: .wifi,
            category: .wifi,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            isFavorite: true,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi
            )
        ),
        QRCodeItem(
            title: "Business Card",
            contentPreview: "vCard",
            rawContent: "BEGIN:VCARD\nVERSION:3.0\nN:Doe;John;;;\nFN:John Doe\nORG:Tech Corp\nTITLE:Product Lead\nTEL;TYPE=CELL:+1555019283\nEMAIL:john@techcorp.io\nEND:VCARD",
            contentType: .contact,
            category: .business,
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            isFavorite: false,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .link
            )
        ),
        QRCodeItem(
            title: "Black Friday Offer",
            contentPreview: "https://myshop.com/bf",
            rawContent: "https://myshop.com/bf",
            contentType: .website,
            category: .business,
            createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            isFavorite: false,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                frameStyle: .cardBorder
            )
        )
    ]
}
