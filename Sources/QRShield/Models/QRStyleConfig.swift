import SwiftUI

/// QR Dot Style
public enum QRDotStyle: String, CaseIterable, Identifiable, Codable {
    case square = "Square"
    case rounded = "Rounded"
    case circular = "Dots"
    case diamond = "Diamond"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .square: return "square.fill"
        case .rounded: return "app.fill"
        case .circular: return "circle.fill"
        case .diamond: return "diamond.fill"
        }
    }
}

/// Color theme or gradient for QR code
public enum QRColorTheme: String, CaseIterable, Identifiable, Codable {
    case classicBlack = "Classic Black"
    case royalPurple = "Royal Purple"
    case instagramSunset = "Instagram"
    case oceanBlue = "Ocean Blue"
    case emeraldGreen = "Emerald Green"
    case youtubeRed = "YouTube Red"
    case sunsetOrange = "Sunset Orange"
    case midnightDark = "Midnight"
    
    public var id: String { rawValue }
    
    public var gradientColors: [Color] {
        switch self {
        case .classicBlack:
            return [Color(hex: "1F2937"), Color(hex: "111827")]
        case .royalPurple:
            return [Color(hex: "8B5CF6"), Color(hex: "6D28D9")]
        case .instagramSunset:
            return [Color(hex: "F58529"), Color(hex: "DD2A7B"), Color(hex: "8134AF")]
        case .oceanBlue:
            return [Color(hex: "06B6D4"), Color(hex: "3B82F6")]
        case .emeraldGreen:
            return [Color(hex: "10B981"), Color(hex: "059669")]
        case .youtubeRed:
            return [Color(hex: "EF4444"), Color(hex: "B91C1C")]
        case .sunsetOrange:
            return [Color(hex: "F97316"), Color(hex: "EA580C")]
        case .midnightDark:
            return [Color(hex: "312E81"), Color(hex: "1E1B4B")]
        }
    }
    
    public var hexColors: [String] {
        switch self {
        case .classicBlack: return ["1F2937", "111827"]
        case .royalPurple: return ["8B5CF6", "6D28D9"]
        case .instagramSunset: return ["F58529", "DD2A7B", "8134AF"]
        case .oceanBlue: return ["06B6D4", "3B82F6"]
        case .emeraldGreen: return ["10B981", "059669"]
        case .youtubeRed: return ["EF4444", "B91C1C"]
        case .sunsetOrange: return ["F97316", "EA580C"]
        case .midnightDark: return ["312E81", "1E1B4B"]
        }
    }
}

/// Logo embedded in the center of the QR code
public enum QRLogoType: String, CaseIterable, Identifiable, Codable {
    case none = "None"
    case instagram = "Instagram"
    case youtube = "YouTube"
    case whatsapp = "WhatsApp"
    case facebook = "Facebook"
    case tiktok = "TikTok"
    case x = "X"
    case telegram = "Telegram"
    case snapchat = "Snapchat"
    case spotify = "Spotify"
    case pinterest = "Pinterest"
    case linkedin = "LinkedIn"
    case reddit = "Reddit"
    case discord = "Discord"
    case threads = "Threads"
    case line = "LINE"
    case viber = "Viber"
    case kakaotalk = "KakaoTalk"
    case github = "GitHub"
    case wifi = "Wi-Fi"
    case link = "Link"
    case shield = "Shield"
    case star = "Star"
    case heart = "Heart"
    case custom = "Custom"
    
    public var id: String { rawValue }
    
    public static func from(itemId: String) -> QRLogoType? {
        let clean = itemId.lowercased().replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "_", with: "")
        switch clean {
        case "instagram": return .instagram
        case "youtube": return .youtube
        case "whatsapp": return .whatsapp
        case "facebook": return .facebook
        case "tiktok": return .tiktok
        case "x", "twitter": return .x
        case "telegram": return .telegram
        case "snapchat": return .snapchat
        case "spotify": return .spotify
        case "pinterest": return .pinterest
        case "linkedin": return .linkedin
        case "reddit": return .reddit
        case "discord": return .discord
        case "threads": return .threads
        case "line": return .line
        case "viber": return .viber
        case "kakaotalk": return .kakaotalk
        case "github": return .github
        case "wifi": return .wifi
        case "weburl", "url": return .link
        default: return nil
        }
    }
    
    public var systemIcon: String? {
        switch self {
        case .none: return nil
        case .instagram: return "camera.fill"
        case .youtube: return "play.rectangle.fill"
        case .whatsapp: return "message.fill"
        case .facebook: return "hand.thumbsup.fill"
        case .tiktok: return "music.note"
        case .x: return "number"
        case .telegram: return "paperplane.fill"
        case .snapchat: return "sparkles.rectangle.stack"
        case .spotify: return "headphones"
        case .pinterest: return "pin.fill"
        case .linkedin: return "briefcase.fill"
        case .reddit: return "bubble.middle.bottom.fill"
        case .discord: return "gamecontroller.fill"
        case .threads: return "at"
        case .line: return "message.fill"
        case .viber: return "phone.fill"
        case .kakaotalk: return "bubble.left.circle.fill"
        case .github: return "chevron.left.forwardslash.chevron.right"
        case .wifi: return "wifi"
        case .link: return "link"
        case .shield: return "checkmark.shield.fill"
        case .star: return "star.fill"
        case .heart: return "heart.fill"
        case .custom: return "photo.fill"
        }
    }
    
    public var badgeBackgroundColor: Color {
        switch self {
        case .instagram: return Color(hex: "E1306C")
        case .youtube: return Color(hex: "FF0000")
        case .whatsapp: return Color(hex: "25D366")
        case .facebook: return Color(hex: "1877F2")
        case .tiktok: return Color(hex: "010101")
        case .x: return Color(hex: "000000")
        case .telegram: return Color(hex: "24A1DE")
        case .snapchat: return Color(hex: "FFFC00")
        case .spotify: return Color(hex: "1DB954")
        case .pinterest: return Color(hex: "BD081C")
        case .linkedin: return Color(hex: "0A66C2")
        case .reddit: return Color(hex: "FF4500")
        case .discord: return Color(hex: "5865F2")
        case .threads: return Color(hex: "101010")
        case .line: return Color(hex: "06C755")
        case .viber: return Color(hex: "7360F2")
        case .kakaotalk: return Color(hex: "FEE500")
        case .github: return Color(hex: "24292F")
        case .wifi: return Color(hex: "0284C7")
        case .link: return Color(hex: "6366F1")
        case .shield: return Color(hex: "10B981")
        case .star: return Color(hex: "F59E0B")
        case .heart: return Color(hex: "EC4899")
        default: return Color(hex: "7C3AED")
        }
    }
}

/// Decorative frames surrounding the QR code
public enum QRFrameStyle: String, CaseIterable, Identifiable, Codable {
    case none = "None"
    case scanMeBottom = "SCAN ME"
    case cardBorder = "Card Badge"
    case neonGlow = "Neon Glow"
    case modernBracket = "Tech Brackets"
    
    public var id: String { rawValue }
}

/// Corner Eye Style
public enum QREyeStyle: String, CaseIterable, Identifiable, Codable {
    case rounded = "Rounded"
    case square = "Square"
    case circular = "Circle"
    case leaf = "Leaf"
    
    public var id: String { rawValue }
}

/// Full style configuration for rendering a QR code
public struct QRStyleConfig: Codable, Equatable {
    public var dotStyle: QRDotStyle = .rounded
    public var colorTheme: QRColorTheme = .royalPurple
    public var backgroundColorHex: String = "FFFFFF"
    public var logoType: QRLogoType = .none
    public var customLogoData: Data? = nil
    public var frameStyle: QRFrameStyle = .none
    public var eyeStyle: QREyeStyle = .rounded
    public var customText: String? = nil
    public var textPositionAbove: Bool = false
    public var textFont: String = "Default"
    public var textColorHex: String = "111827"
    public var decorativeFrame: QRDecorativeFrame = .none
    public var bannerText: String? = nil
    public var frameBrandColors: [String]? = nil
    
    public var hasCustomText: Bool {
        guard let customText = customText else { return false }
        return !customText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public init(
        dotStyle: QRDotStyle = .rounded,
        colorTheme: QRColorTheme = .royalPurple,
        backgroundColorHex: String = "FFFFFF",
        logoType: QRLogoType = .none,
        customLogoData: Data? = nil,
        frameStyle: QRFrameStyle = .none,
        eyeStyle: QREyeStyle = .rounded,
        customText: String? = nil,
        textPositionAbove: Bool = false,
        textFont: String = "Default",
        textColorHex: String = "111827",
        decorativeFrame: QRDecorativeFrame = .none,
        bannerText: String? = nil,
        frameBrandColors: [String]? = nil
    ) {
        self.dotStyle = dotStyle
        self.colorTheme = colorTheme
        self.backgroundColorHex = backgroundColorHex
        self.logoType = logoType
        self.customLogoData = customLogoData
        self.frameStyle = frameStyle
        self.eyeStyle = eyeStyle
        self.customText = customText
        self.textPositionAbove = textPositionAbove
        self.textFont = textFont
        self.textColorHex = textColorHex
        self.decorativeFrame = decorativeFrame
        self.bannerText = bannerText
        self.frameBrandColors = frameBrandColors
    }
    
    private enum CodingKeys: String, CodingKey {
        case dotStyle, colorTheme, backgroundColorHex, logoType, customLogoData, frameStyle, eyeStyle
        case customText, textPositionAbove, textFont, textColorHex
        case decorativeFrame, bannerText, frameBrandColors
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dotStyle = try container.decodeIfPresent(QRDotStyle.self, forKey: .dotStyle) ?? .rounded
        self.colorTheme = try container.decodeIfPresent(QRColorTheme.self, forKey: .colorTheme) ?? .royalPurple
        self.backgroundColorHex = try container.decodeIfPresent(String.self, forKey: .backgroundColorHex) ?? "FFFFFF"
        self.logoType = try container.decodeIfPresent(QRLogoType.self, forKey: .logoType) ?? .none
        self.customLogoData = try container.decodeIfPresent(Data.self, forKey: .customLogoData)
        self.frameStyle = try container.decodeIfPresent(QRFrameStyle.self, forKey: .frameStyle) ?? .none
        self.eyeStyle = try container.decodeIfPresent(QREyeStyle.self, forKey: .eyeStyle) ?? .rounded
        self.customText = try container.decodeIfPresent(String.self, forKey: .customText)
        self.textPositionAbove = try container.decodeIfPresent(Bool.self, forKey: .textPositionAbove) ?? false
        self.textFont = try container.decodeIfPresent(String.self, forKey: .textFont) ?? "Default"
        self.textColorHex = try container.decodeIfPresent(String.self, forKey: .textColorHex) ?? "111827"
        self.decorativeFrame = try container.decodeIfPresent(QRDecorativeFrame.self, forKey: .decorativeFrame) ?? .none
        self.bannerText = try container.decodeIfPresent(String.self, forKey: .bannerText)
        self.frameBrandColors = try container.decodeIfPresent([String].self, forKey: .frameBrandColors)
    }
}
