import SwiftUI

public enum QRTemplateCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case popular = "Popular"
    case business = "Business"
    case colorful = "Colorful"
    case socialMedia = "Social"
    case wifi = "Wi-Fi"
    case event = "Event"
    case location = "Location"
    case email = "Email"
    
    public var id: String { rawValue }
    
    public var sfSymbol: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .popular: return "flame.fill"
        case .business: return "briefcase.fill"
        case .colorful: return "paintbrush.fill"
        case .socialMedia: return "person.2.fill"
        case .wifi: return "wifi"
        case .event: return "calendar"
        case .location: return "mappin.and.ellipse"
        case .email: return "envelope.fill"
        }
    }
    
    public var defaultBadgeLabel: String {
        switch self {
        case .all: return "ALL"
        case .popular: return "POPULAR"
        case .business: return "BUSINESS"
        case .colorful: return "COLORFUL"
        case .socialMedia: return "SOCIAL"
        case .wifi: return "WI-FI"
        case .event: return "EVENT"
        case .location: return "LOCATION"
        case .email: return "EMAIL"
        }
    }
}

public extension QRTemplateCategory {
    // Backward compatibility aliases
    static let social = QRTemplateCategory.socialMedia
    static let creative = QRTemplateCategory.colorful
}

public enum TemplateBadgePosition: String, Codable {
    case centerLogo
    case bannerLeft
    case badgeTop
    case badgeBottom
    case ribbon
}

public struct QRTemplate: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let category: QRTemplateCategory
    public let title: String
    public let subtitle: String
    public let categoryIcon: String         // SF Symbol for top pill & center badge
    public let categoryLabel: String        // Top pill badge label (e.g. "SOCIAL")
    public let footerText: String           // Customizable footer text (default "Scan Me")
    public let gradientHexColors: [String]  // Background linear gradient stops
    public let gradientStops: [Double]?     // Optional stop offsets (e.g. [0.0, 0.58, 1.0])
    public let accentColorHex: String       // Stroke / accent color for center badge
    public let isPro: Bool                  // Show PRO indicator
    public let subCategory: String?         // Subcategory filter (e.g. "Menu", "Store", etc.)
    public let styleConfig: QRStyleConfig
    public let defaultContent: String
    
    // Backward-compatibility properties
    public var badgeText: String? { categoryLabel }
    public var defaultTitle: String { title }
    public var previewGradientHex: [String] { gradientHexColors }
    public var badgePosition: TemplateBadgePosition { .centerLogo }
    
    public init(
        id: String,
        name: String,
        category: QRTemplateCategory,
        title: String,
        subtitle: String,
        categoryIcon: String,
        categoryLabel: String? = nil,
        footerText: String = "Scan Me",
        gradientHexColors: [String],
        gradientStops: [Double]? = nil,
        accentColorHex: String? = nil,
        isPro: Bool = false,
        subCategory: String? = nil,
        styleConfig: QRStyleConfig,
        defaultContent: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.title = title
        self.subtitle = subtitle
        self.categoryIcon = categoryIcon
        self.categoryLabel = categoryLabel ?? category.defaultBadgeLabel
        self.footerText = footerText
        self.gradientHexColors = gradientHexColors
        self.gradientStops = gradientStops
        self.accentColorHex = accentColorHex ?? gradientHexColors.first ?? "7C3AED"
        self.isPro = isPro
        self.subCategory = subCategory
        self.styleConfig = styleConfig
        self.defaultContent = defaultContent
    }
    
    public init(
        id: String,
        name: String,
        category: QRTemplateCategory,
        badgeText: String? = nil,
        badgePosition: TemplateBadgePosition = .centerLogo,
        styleConfig: QRStyleConfig,
        defaultTitle: String,
        defaultContent: String,
        previewGradientHex: [String],
        accentColorHex: String = "FFFFFF",
        isPro: Bool = false,
        subCategory: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.title = defaultTitle
        self.subtitle = badgeText ?? "SCAN ME"
        self.categoryIcon = category.sfSymbol
        self.categoryLabel = badgeText ?? category.defaultBadgeLabel
        self.footerText = "Scan Me"
        self.gradientHexColors = previewGradientHex
        self.gradientStops = nil
        self.accentColorHex = accentColorHex
        self.isPro = isPro
        self.subCategory = subCategory
        self.styleConfig = styleConfig
        self.defaultContent = defaultContent
    }
}

public extension QRTemplate {
    var linearGradient: LinearGradient {
        if let stops = gradientStops, stops.count == gradientHexColors.count {
            let gradientStops = zip(gradientHexColors, stops).map { hex, stop in
                Gradient.Stop(color: Color(hex: hex), location: CGFloat(stop))
            }
            return LinearGradient(stops: gradientStops, startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(
                colors: gradientHexColors.map { Color(hex: $0) },
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var accentColor: Color {
        Color(hex: accentColorHex)
    }
}


public extension QRTemplate {
    static let predefinedTemplates: [QRTemplate] = [
        QRTemplate(
            id: "ig_sunset_glow",
            name: "Instagram Sunset",
            category: .socialMedia,
            title: "Instagram",
            subtitle: "FOLLOW US",
            categoryIcon: "camera.fill",
            categoryLabel: "SOCIAL",
            footerText: "FOLLOW US",
            gradientHexColors: ["7C3AED", "EC4899", "F97316"],
            gradientStops: [0.0, 0.58, 1.0],
            accentColorHex: "EC4899",
            isPro: false,
            subCategory: "Instagram",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .instagram,
                eyeStyle: .rounded,
                decorativeFrame: .socialGradientFrame,
                bannerText: "FOLLOW US",
                frameBrandColors: ["F58529", "DD2A7B", "8134AF", "515BD4"]
            ),
            defaultContent: "https://instagram.com/qrshield"
        ),
        QRTemplate(
            id: "ig_story_card",
            name: "Insta Story Frame",
            category: .socialMedia,
            title: "Instagram Story",
            subtitle: "SWIPE & FOLLOW",
            categoryIcon: "camera.fill",
            categoryLabel: "SOCIAL",
            footerText: "FOLLOW",
            gradientHexColors: ["DD2A7B", "8134AF"],
            gradientStops: nil,
            accentColorHex: "DD2A7B",
            isPro: true,
            subCategory: "Instagram",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .instagram,
                eyeStyle: .leaf,
                decorativeFrame: .socialHeaderFrame,
                bannerText: "INSTAGRAM",
                frameBrandColors: ["DD2A7B", "8134AF"]
            ),
            defaultContent: "https://instagram.com/qrshield"
        ),
        QRTemplate(
            id: "yt_red_banner",
            name: "YouTube Subscribe",
            category: .socialMedia,
            title: "YouTube",
            subtitle: "WATCH MORE",
            categoryIcon: "play.rectangle.fill",
            categoryLabel: "SOCIAL",
            footerText: "SUBSCRIBE",
            gradientHexColors: ["EF4444", "B91C1C"],
            gradientStops: nil,
            accentColorHex: "EF4444",
            isPro: false,
            subCategory: "YouTube",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .youtube,
                eyeStyle: .square,
                decorativeFrame: .fullBanner,
                bannerText: "SUBSCRIBE",
                frameBrandColors: ["EF4444", "B91C1C"]
            ),
            defaultContent: "https://youtube.com/@qrshield"
        ),
        QRTemplate(
            id: "yt_watch_scanme",
            name: "YouTube Red Scan",
            category: .socialMedia,
            title: "YouTube Video",
            subtitle: "LATEST UPLOAD",
            categoryIcon: "play.rectangle.fill",
            categoryLabel: "SOCIAL",
            footerText: "WATCH NOW",
            gradientHexColors: ["DC2626", "991B1B"],
            gradientStops: nil,
            accentColorHex: "DC2626",
            isPro: false,
            subCategory: "YouTube",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .youtube,
                eyeStyle: .rounded,
                decorativeFrame: .scanMeBanner,
                bannerText: "WATCH NOW",
                frameBrandColors: ["DC2626"]
            ),
            defaultContent: "https://youtube.com/@qrshield"
        ),
        QRTemplate(
            id: "fb_connect_header",
            name: "Facebook Connect",
            category: .socialMedia,
            title: "Facebook Page",
            subtitle: "LIKE & CONNECT",
            categoryIcon: "hand.thumbsup.fill",
            categoryLabel: "SOCIAL",
            footerText: "FOLLOW US",
            gradientHexColors: ["1877F2", "0D65D9"],
            gradientStops: nil,
            accentColorHex: "1877F2",
            isPro: false,
            subCategory: "Facebook",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .facebook,
                eyeStyle: .rounded,
                decorativeFrame: .socialHeaderFrame,
                bannerText: "FOLLOW US ON",
                frameBrandColors: ["1877F2", "0D65D9"]
            ),
            defaultContent: "https://facebook.com/qrshield"
        ),
        QRTemplate(
            id: "fb_solid_blue",
            name: "Facebook Blue",
            category: .socialMedia,
            title: "Facebook Official",
            subtitle: "COMMUNITY HUB",
            categoryIcon: "hand.thumbsup.fill",
            categoryLabel: "SOCIAL",
            footerText: "LIKE US",
            gradientHexColors: ["1877F2"],
            gradientStops: nil,
            accentColorHex: "1877F2",
            isPro: true,
            subCategory: "Facebook",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .facebook,
                eyeStyle: .square,
                decorativeFrame: .solidBorder,
                bannerText: "LIKE US",
                frameBrandColors: ["1877F2"]
            ),
            defaultContent: "https://facebook.com/qrshield"
        ),
        QRTemplate(
            id: "wa_direct_chat",
            name: "WhatsApp Chat",
            category: .socialMedia,
            title: "WhatsApp Direct",
            subtitle: "INSTANT MESSAGING",
            categoryIcon: "message.fill",
            categoryLabel: "SOCIAL",
            footerText: "CHAT NOW",
            gradientHexColors: ["25D366", "128C7E"],
            gradientStops: nil,
            accentColorHex: "25D366",
            isPro: false,
            subCategory: "WhatsApp",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .whatsapp,
                eyeStyle: .rounded,
                decorativeFrame: .colorCard,
                bannerText: "CHAT WITH US",
                frameBrandColors: ["25D366", "128C7E"]
            ),
            defaultContent: "https://wa.me/15551234567"
        ),
        QRTemplate(
            id: "wa_scan_chat",
            name: "WhatsApp Green",
            category: .socialMedia,
            title: "WhatsApp Support",
            subtitle: "24/7 HELPLINE",
            categoryIcon: "message.fill",
            categoryLabel: "SOCIAL",
            footerText: "MESSAGE US",
            gradientHexColors: ["10B981", "059669"],
            gradientStops: nil,
            accentColorHex: "10B981",
            isPro: false,
            subCategory: "WhatsApp",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .whatsapp,
                eyeStyle: .circular,
                decorativeFrame: .scanMeBanner,
                bannerText: "MESSAGE US",
                frameBrandColors: ["10B981"]
            ),
            defaultContent: "https://wa.me/15551234567"
        ),
        QRTemplate(
            id: "tt_neon_vibe",
            name: "TikTok Neon",
            category: .socialMedia,
            title: "TikTok",
            subtitle: "VIRAL VIDEOS",
            categoryIcon: "music.note",
            categoryLabel: "SOCIAL",
            footerText: "WATCH",
            gradientHexColors: ["00F2FE", "FE2C55"],
            gradientStops: nil,
            accentColorHex: "00F2FE",
            isPro: true,
            subCategory: "TikTok",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .tiktok,
                eyeStyle: .leaf,
                decorativeFrame: .neonGlowRing,
                bannerText: "WATCH VIDEOS",
                frameBrandColors: ["00F2FE", "FE2C55"]
            ),
            defaultContent: "https://tiktok.com/@qrshield"
        ),
        QRTemplate(
            id: "x_modern_bracket",
            name: "X Minimal",
            category: .socialMedia,
            title: "X Profile",
            subtitle: "LATEST UPDATES",
            categoryIcon: "number",
            categoryLabel: "SOCIAL",
            footerText: "FOLLOW",
            gradientHexColors: ["18181B", "09090B"],
            gradientStops: nil,
            accentColorHex: "18181B",
            isPro: false,
            subCategory: "X",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .x,
                eyeStyle: .square,
                decorativeFrame: .cornerBrackets,
                bannerText: "FOLLOW @US",
                frameBrandColors: ["18181B"]
            ),
            defaultContent: "https://x.com/qrshield"
        ),
        QRTemplate(
            id: "li_pro_connect",
            name: "LinkedIn Connect",
            category: .socialMedia,
            title: "LinkedIn",
            subtitle: "PROFESSIONAL NETWORK",
            categoryIcon: "briefcase.fill",
            categoryLabel: "SOCIAL",
            footerText: "CONNECT",
            gradientHexColors: ["0A66C2", "004182"],
            gradientStops: nil,
            accentColorHex: "0A66C2",
            isPro: false,
            subCategory: "LinkedIn",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .linkedin,
                eyeStyle: .rounded,
                decorativeFrame: .topBanner,
                bannerText: "CONNECT ON LINKEDIN",
                frameBrandColors: ["0A66C2", "004182"]
            ),
            defaultContent: "https://linkedin.com/in/qrshield"
        ),
        QRTemplate(
            id: "sp_stream_card",
            name: "Spotify Stream",
            category: .socialMedia,
            title: "Spotify",
            subtitle: "STREAM PLAYLIST",
            categoryIcon: "headphones",
            categoryLabel: "SOCIAL",
            footerText: "LISTEN",
            gradientHexColors: ["1DB954", "191414"],
            gradientStops: nil,
            accentColorHex: "1DB954",
            isPro: true,
            subCategory: "Spotify",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .spotify,
                eyeStyle: .circular,
                decorativeFrame: .gradientCard,
                bannerText: "LISTEN ON SPOTIFY",
                frameBrandColors: ["1DB954", "191414"]
            ),
            defaultContent: "https://open.spotify.com/artist/qrshield"
        ),
        QRTemplate(
            id: "tg_channel_wave",
            name: "Telegram Channel",
            category: .socialMedia,
            title: "Telegram",
            subtitle: "COMMUNITY CHAT",
            categoryIcon: "paperplane.fill",
            categoryLabel: "SOCIAL",
            footerText: "JOIN US",
            gradientHexColors: ["24A1DE", "1565C0"],
            gradientStops: nil,
            accentColorHex: "24A1DE",
            isPro: false,
            subCategory: "Telegram",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .telegram,
                eyeStyle: .rounded,
                decorativeFrame: .wavesBorder,
                bannerText: "JOIN CHANNEL",
                frameBrandColors: ["24A1DE"]
            ),
            defaultContent: "https://t.me/qrshield"
        ),
        QRTemplate(
            id: "snap_yellow_stamp",
            name: "Snapchat Spotlight",
            category: .socialMedia,
            title: "Snapchat",
            subtitle: "ADD NEW FRIEND",
            categoryIcon: "sparkles.rectangle.stack",
            categoryLabel: "SOCIAL",
            footerText: "ADD FRIEND",
            gradientHexColors: ["FBBF24", "D97706"],
            gradientStops: nil,
            accentColorHex: "FBBF24",
            isPro: true,
            subCategory: "Snapchat",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .snapchat,
                eyeStyle: .rounded,
                decorativeFrame: .stampBorder,
                bannerText: "ADD ON SNAP",
                frameBrandColors: ["FBBF24", "D97706"]
            ),
            defaultContent: "https://snapchat.com/add/qrshield"
        ),
        QRTemplate(
            id: "biz_menu_cafe",
            name: "Artisan Café Menu",
            category: .business,
            title: "Café Menu",
            subtitle: "DIGITAL DRINKS & BITES",
            categoryIcon: "cup.and.saucer.fill",
            categoryLabel: "BUSINESS",
            footerText: "VIEW MENU",
            gradientHexColors: ["78350F", "92400E"],
            gradientStops: nil,
            accentColorHex: "92400E",
            isPro: false,
            subCategory: "Menu",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .fullBanner,
                bannerText: "CAFE MENU",
                frameBrandColors: ["78350F", "92400E"]
            ),
            defaultContent: "https://artisancafe.com/menu"
        ),
        QRTemplate(
            id: "biz_menu_bistro",
            name: "Bistro Dining Menu",
            category: .business,
            title: "Bistro Dining",
            subtitle: "TABLE SERVICE QR",
            categoryIcon: "fork.knife",
            categoryLabel: "BUSINESS",
            footerText: "BROWSE MENU",
            gradientHexColors: ["DC2626", "991B1B"],
            gradientStops: nil,
            accentColorHex: "DC2626",
            isPro: false,
            subCategory: "Menu",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .scanMeBanner,
                bannerText: "DIGITAL MENU",
                frameBrandColors: ["DC2626"]
            ),
            defaultContent: "https://bistromoderne.com/menu"
        ),
        QRTemplate(
            id: "biz_menu_gourmet",
            name: "Chef's Specials",
            category: .business,
            title: "Gourmet Selection",
            subtitle: "DAILY SIGNATURE DISHES",
            categoryIcon: "fork.knife",
            categoryLabel: "BUSINESS",
            footerText: "SPECIALS",
            gradientHexColors: ["D97706", "B45309"],
            gradientStops: nil,
            accentColorHex: "D97706",
            isPro: true,
            subCategory: "Menu",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .leaf,
                decorativeFrame: .topBanner,
                bannerText: "CHEF SPECIALS",
                frameBrandColors: ["D97706", "B45309"]
            ),
            defaultContent: "https://gourmetexperience.com/specials"
        ),
        QRTemplate(
            id: "biz_store_boutique",
            name: "Boutique Catalog",
            category: .business,
            title: "Fashion Boutique",
            subtitle: "NEW ARRIVALS",
            categoryIcon: "bag.fill",
            categoryLabel: "BUSINESS",
            footerText: "SHOP COLLECTION",
            gradientHexColors: ["EC4899", "8B5CF6"],
            gradientStops: nil,
            accentColorHex: "EC4899",
            isPro: false,
            subCategory: "Store",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .circular,
                decorativeFrame: .gradientBorder,
                bannerText: "ONLINE STORE",
                frameBrandColors: ["EC4899", "8B5CF6"]
            ),
            defaultContent: "https://maisonluxe.co/collection"
        ),
        QRTemplate(
            id: "biz_store_retail",
            name: "Retail Storefront",
            category: .business,
            title: "Product Showcase",
            subtitle: "SCAN FOR INVENTORY",
            categoryIcon: "cart.fill",
            categoryLabel: "BUSINESS",
            footerText: "VIEW PRODUCTS",
            gradientHexColors: ["0284C7", "0369A1"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: false,
            subCategory: "Store",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .solidBorder,
                bannerText: "SHOP CATALOG",
                frameBrandColors: ["0284C7"]
            ),
            defaultContent: "https://storefront.retail/products"
        ),
        QRTemplate(
            id: "biz_crypto_btc",
            name: "Bitcoin Pay Card",
            category: .business,
            title: "Crypto Payment",
            subtitle: "INSTANT BTC WALLET",
            categoryIcon: "bitcoinsign.circle.fill",
            categoryLabel: "BUSINESS",
            footerText: "SEND BITCOIN",
            gradientHexColors: ["F59E0B", "D97706"],
            gradientStops: nil,
            accentColorHex: "F59E0B",
            isPro: true,
            subCategory: "Blockchain",
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .leaf,
                decorativeFrame: .colorCard,
                bannerText: "CRYPTO PAY",
                frameBrandColors: ["F59E0B", "D97706"]
            ),
            defaultContent: "bitcoin:1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa?amount=0.005"
        ),
        QRTemplate(
            id: "biz_crypto_eth",
            name: "Ethereum Wallet",
            category: .business,
            title: "Ethereum Transfer",
            subtitle: "WEB3 SMART WALLET",
            categoryIcon: "diamond.fill",
            categoryLabel: "BUSINESS",
            footerText: "SEND ETH",
            gradientHexColors: ["627EEA", "3C45A5"],
            gradientStops: nil,
            accentColorHex: "627EEA",
            isPro: false,
            subCategory: "Blockchain",
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .leaf,
                decorativeFrame: .cornerBrackets,
                bannerText: "ETH TRANSFER",
                frameBrandColors: ["627EEA", "3C45A5"]
            ),
            defaultContent: "ethereum:0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe"
        ),
        QRTemplate(
            id: "biz_coupon_deal",
            name: "Flash Coupon 20%",
            category: .business,
            title: "Exclusive Promo",
            subtitle: "SCAN TO REDEEM DISCOUNT",
            categoryIcon: "tag.fill",
            categoryLabel: "BUSINESS",
            footerText: "REDEEM NOW",
            gradientHexColors: ["EF4444", "F97316"],
            gradientStops: nil,
            accentColorHex: "EF4444",
            isPro: false,
            subCategory: "Coupon",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .rounded,
                decorativeFrame: .dashedBorder,
                bannerText: "CLAIM 20% OFF",
                frameBrandColors: ["EF4444", "F97316"]
            ),
            defaultContent: "https://deals.shop/promo/SAVE20"
        ),
        QRTemplate(
            id: "biz_coupon_stamp",
            name: "VIP Voucher Stamp",
            category: .business,
            title: "Loyalty Stamp",
            subtitle: "MEMBER REWARD REBATE",
            categoryIcon: "seal.fill",
            categoryLabel: "BUSINESS",
            footerText: "VERIFY STAMP",
            gradientHexColors: ["059669", "10B981"],
            gradientStops: nil,
            accentColorHex: "059669",
            isPro: true,
            subCategory: "Coupon",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .shield,
                eyeStyle: .square,
                decorativeFrame: .stampBorder,
                bannerText: "SPECIAL VOUCHER",
                frameBrandColors: ["059669", "10B981"]
            ),
            defaultContent: "https://rewards.club/voucher/vip882"
        ),
        QRTemplate(
            id: "biz_pay_instant",
            name: "Instant Tap Pay",
            category: .business,
            title: "Contactless Pay",
            subtitle: "ZERO HASSLE CHECKOUT",
            categoryIcon: "creditcard.fill",
            categoryLabel: "BUSINESS",
            footerText: "PAY SECURELY",
            gradientHexColors: ["2563EB", "1D4ED8"],
            gradientStops: nil,
            accentColorHex: "2563EB",
            isPro: false,
            subCategory: "Pay",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .colorCard,
                bannerText: "SCAN TO PAY",
                frameBrandColors: ["2563EB", "1D4ED8"]
            ),
            defaultContent: "https://pay.stripe.com/qr/instant-992"
        ),
        QRTemplate(
            id: "biz_pay_checkout",
            name: "Express Checkout",
            category: .business,
            title: "Express Pay",
            subtitle: "FAST & VERIFIED",
            categoryIcon: "dollarsign.circle.fill",
            categoryLabel: "BUSINESS",
            footerText: "COMPLETE ORDER",
            gradientHexColors: ["059669"],
            gradientStops: nil,
            accentColorHex: "059669",
            isPro: false,
            subCategory: "Pay",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .scanMeBanner,
                bannerText: "TOUCHLESS PAY",
                frameBrandColors: ["059669"]
            ),
            defaultContent: "https://checkout.apex.io/pay/order-401"
        ),
        QRTemplate(
            id: "biz_review_google",
            name: "Review on Google",
            category: .business,
            title: "5-Star Feedback",
            subtitle: "RATE OUR SERVICE",
            categoryIcon: "star.fill",
            categoryLabel: "BUSINESS",
            footerText: "LEAVE A REVIEW",
            gradientHexColors: ["4285F4", "34A853"],
            gradientStops: nil,
            accentColorHex: "4285F4",
            isPro: false,
            subCategory: "Review",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .rounded,
                decorativeFrame: .socialHeaderFrame,
                bannerText: "REVIEW US ON GOOGLE",
                frameBrandColors: ["4285F4", "34A853"]
            ),
            defaultContent: "https://g.page/r/your-google-place-id/review"
        ),
        QRTemplate(
            id: "biz_exec_card",
            name: "Corporate Executive",
            category: .business,
            title: "Digital Business Card",
            subtitle: "SAVE CONTACT DIRECTLY",
            categoryIcon: "person.crop.rectangle.fill",
            categoryLabel: "BUSINESS",
            footerText: "SAVE CONTACT",
            gradientHexColors: ["1E293B", "334155"],
            gradientStops: nil,
            accentColorHex: "38BDF8",
            isPro: false,
            subCategory: "Corporate",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .doubleLine,
                bannerText: "BUSINESS CARD",
                frameBrandColors: ["1E293B", "334155"]
            ),
            defaultContent: "BEGIN:VCARD\\nVERSION:3.0\\nFN:Alex Vance\\nORG:Apex Tech\\nTITLE:CEO\\nTEL:+15550192831\\nEMAIL:alex@apextech.com\\nEND:VCARD"
        ),
        QRTemplate(
            id: "biz_realtor_tour",
            name: "Luxury Property Tour",
            category: .business,
            title: "Virtual Open House",
            subtitle: "3D WALKTHROUGH & SPECS",
            categoryIcon: "house.fill",
            categoryLabel: "BUSINESS",
            footerText: "VIEW PROPERTY",
            gradientHexColors: ["78716C", "44403C"],
            gradientStops: nil,
            accentColorHex: "D97706",
            isPro: true,
            subCategory: "Corporate",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .leaf,
                decorativeFrame: .cornerFlourish,
                bannerText: "3D HOME TOUR",
                frameBrandColors: ["78716C", "44403C"]
            ),
            defaultContent: "https://skylinehomes.re/villa-402"
        ),
        QRTemplate(
            id: "biz_fitness_pass",
            name: "Gym Trial Pass",
            category: .business,
            title: "Fitness Center",
            subtitle: "7-DAY COMPLIMENTARY ACCESS",
            categoryIcon: "figure.run",
            categoryLabel: "BUSINESS",
            footerText: "GET PASS",
            gradientHexColors: ["F43F5E", "E11D48"],
            gradientStops: nil,
            accentColorHex: "F43F5E",
            isPro: false,
            subCategory: "Store",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .ribbonBanner,
                bannerText: "FREE TRIAL PASS",
                frameBrandColors: ["F43F5E", "E11D48"]
            ),
            defaultContent: "https://peakgym.club/pass"
        ),
        QRTemplate(
            id: "wifi_home_solid",
            name: "Home Gigabit Wi-Fi",
            category: .wifi,
            title: "Home Network",
            subtitle: "ONE-TAP AUTO CONNECT",
            categoryIcon: "wifi",
            categoryLabel: "WI-FI",
            footerText: "CONNECT",
            gradientHexColors: ["2563EB", "1D4ED8"],
            gradientStops: nil,
            accentColorHex: "2563EB",
            isPro: false,
            subCategory: "Home",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .rounded,
                decorativeFrame: .solidBorder,
                bannerText: "CONNECT TO WI-FI",
                frameBrandColors: ["2563EB"]
            ),
            defaultContent: "WIFI:S:Home_Gigabit_5G;T:WPA;P:SuperSecretPass2026;;"
        ),
        QRTemplate(
            id: "wifi_scan_connect",
            name: "Quick Connect Wi-Fi",
            category: .wifi,
            title: "Wi-Fi Hub",
            subtitle: "SCAN TO JOIN INSTANTLY",
            categoryIcon: "wifi",
            categoryLabel: "WI-FI",
            footerText: "CONNECT NOW",
            gradientHexColors: ["0284C7", "0369A1"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: false,
            subCategory: "Home",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .rounded,
                decorativeFrame: .scanMeBanner,
                bannerText: "SCAN TO CONNECT",
                frameBrandColors: ["0284C7"]
            ),
            defaultContent: "WIFI:S:Guest_FastWiFi;T:WPA;P:guestAccess888;;"
        ),
        QRTemplate(
            id: "wifi_cafe_guest",
            name: "Café Guest Wi-Fi",
            category: .wifi,
            title: "Coffee Shop Wi-Fi",
            subtitle: "FREE BROADBAND ACCESS",
            categoryIcon: "cup.and.saucer.fill",
            categoryLabel: "WI-FI",
            footerText: "CONNECT FREE",
            gradientHexColors: ["92400E", "78350F"],
            gradientStops: nil,
            accentColorHex: "F59E0B",
            isPro: false,
            subCategory: "Cafe",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .rounded,
                decorativeFrame: .colorCard,
                bannerText: "FREE CAFE WI-FI",
                frameBrandColors: ["92400E", "78350F"]
            ),
            defaultContent: "WIFI:S:ArtisanCoffee_Guest;T:WPA;P:coffee2026;;"
        ),
        QRTemplate(
            id: "wifi_top_badge",
            name: "Wi-Fi Portal Banner",
            category: .wifi,
            title: "Guest Portal",
            subtitle: "COMPLIMENTARY ACCESS",
            categoryIcon: "wifi",
            categoryLabel: "WI-FI",
            footerText: "JOIN GUEST",
            gradientHexColors: ["10B981", "059669"],
            gradientStops: nil,
            accentColorHex: "10B981",
            isPro: false,
            subCategory: "Guest",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .leaf,
                decorativeFrame: .topBanner,
                bannerText: "WIFI · CONNECT",
                frameBrandColors: ["10B981"]
            ),
            defaultContent: "WIFI:S:Lounge_Guest;T:nopass;P:;;"
        ),
        QRTemplate(
            id: "wifi_office_net",
            name: "Corporate Office",
            category: .wifi,
            title: "Enterprise Secured",
            subtitle: "WPA3 ENTERPRISE SECURITY",
            categoryIcon: "network",
            categoryLabel: "WI-FI",
            footerText: "AUTHENTICATE",
            gradientHexColors: ["1E293B", "0F172A"],
            gradientStops: nil,
            accentColorHex: "38BDF8",
            isPro: false,
            subCategory: "Corporate",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .square,
                decorativeFrame: .cornerBrackets,
                bannerText: "SECURED WI-FI",
                frameBrandColors: ["1E293B"]
            ),
            defaultContent: "WIFI:S:ApexHQ_Corp;T:WPA;P:enterprisePass2026;;"
        ),
        QRTemplate(
            id: "wifi_fiber_neon",
            name: "Cyberpunk Fiber 10G",
            category: .wifi,
            title: "Gigabit Fiber",
            subtitle: "ULTRA-LOW LATENCY STREAMING",
            categoryIcon: "bolt.horizontal.fill",
            categoryLabel: "WI-FI",
            footerText: "FAST SPEED",
            gradientHexColors: ["7C3AED", "C026D3"],
            gradientStops: nil,
            accentColorHex: "C026D3",
            isPro: true,
            subCategory: "Fast",
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .leaf,
                decorativeFrame: .neonGlowRing,
                bannerText: "10G FIBER SPEED",
                frameBrandColors: ["7C3AED", "C026D3"]
            ),
            defaultContent: "WIFI:S:QuantumFiber_10G;T:WPA;P:photonWave99;;"
        ),
        QRTemplate(
            id: "wifi_hotel_lounge",
            name: "Resort Lounge Wi-Fi",
            category: .wifi,
            title: "Resort Lounge",
            subtitle: "HIGH-SPEED HOTEL NETWORK",
            categoryIcon: "wifi.router.fill",
            categoryLabel: "WI-FI",
            footerText: "CONNECT NOW",
            gradientHexColors: ["0284C7", "0D9488"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: true,
            subCategory: "Guest",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .rounded,
                decorativeFrame: .gradientCard,
                bannerText: "GUEST ACCESS",
                frameBrandColors: ["0284C7", "0D9488"]
            ),
            defaultContent: "WIFI:S:GrandResort_Guest;T:WPA;P:welcomeGuest2026;;"
        ),
        QRTemplate(
            id: "wifi_event_dashed",
            name: "Expo Convention Wi-Fi",
            category: .wifi,
            title: "Convention Expo",
            subtitle: "OPEN EVENT BROADBAND",
            categoryIcon: "antenna.radiowaves.left.and.right",
            categoryLabel: "WI-FI",
            footerText: "ONE TAP JOIN",
            gradientHexColors: ["8B5CF6", "6D28D9"],
            gradientStops: nil,
            accentColorHex: "8B5CF6",
            isPro: false,
            subCategory: "Guest",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .circular,
                decorativeFrame: .dashedBorder,
                bannerText: "EXPO GUEST WIFI",
                frameBrandColors: ["8B5CF6"]
            ),
            defaultContent: "WIFI:S:Expo2026_Guest;T:nopass;P:;;"
        ),
        QRTemplate(
            id: "wifi_double_blue",
            name: "Studio Production Wi-Fi",
            category: .wifi,
            title: "Production Studio",
            subtitle: "BROADCAST PRIORITY BAND",
            categoryIcon: "lock.shield.fill",
            categoryLabel: "WI-FI",
            footerText: "BROADCAST PASS",
            gradientHexColors: ["3B82F6", "1D4ED8"],
            gradientStops: nil,
            accentColorHex: "3B82F6",
            isPro: false,
            subCategory: "Corporate",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .rounded,
                decorativeFrame: .doubleLine,
                bannerText: "STUDIO NETWORK",
                frameBrandColors: ["3B82F6"]
            ),
            defaultContent: "WIFI:S:StudioStream_Private;T:WPA;P:prodCastPass42;;"
        ),
        QRTemplate(
            id: "wifi_waves_fiber",
            name: "Coastal Wave Wi-Fi",
            category: .wifi,
            title: "Beachfront Network",
            subtitle: "FREE PUBLIC HOTSPOT",
            categoryIcon: "wifi",
            categoryLabel: "WI-FI",
            footerText: "HOTSPOT ACCESS",
            gradientHexColors: ["06B6D4", "0284C7"],
            gradientStops: nil,
            accentColorHex: "06B6D4",
            isPro: true,
            subCategory: "Fast",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .circular,
                decorativeFrame: .wavesBorder,
                bannerText: "HIGH SPEED WIFI",
                frameBrandColors: ["06B6D4"]
            ),
            defaultContent: "WIFI:S:CoastalHotspot_Free;T:nopass;P:;;"
        ),
        QRTemplate(
            id: "ev_wedding_hearts",
            name: "Wedding Celebration",
            category: .event,
            title: "Save Our Date",
            subtitle: "JOIN OUR SPECIAL DAY",
            categoryIcon: "heart.fill",
            categoryLabel: "EVENT",
            footerText: "CELEBRATE",
            gradientHexColors: ["FB7185", "E11D48"],
            gradientStops: nil,
            accentColorHex: "FB7185",
            isPro: true,
            subCategory: "Wedding",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .rounded,
                decorativeFrame: .cornerHearts,
                bannerText: "SAVE OUR DATE",
                frameBrandColors: ["FB7185", "E11D48"]
            ),
            defaultContent: "https://sarah-and-daniel.wedding"
        ),
        QRTemplate(
            id: "ev_birthday_stars",
            name: "Birthday Party Bash",
            category: .event,
            title: "Birthday Party",
            subtitle: "YOU'RE INVITED",
            categoryIcon: "party.popper.fill",
            categoryLabel: "EVENT",
            footerText: "RSVP NOW",
            gradientHexColors: ["F59E0B", "F43F5E"],
            gradientStops: nil,
            accentColorHex: "F59E0B",
            isPro: true,
            subCategory: "Birthday",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .circular,
                decorativeFrame: .cornerStars,
                bannerText: "HAPPY BIRTHDAY",
                frameBrandColors: ["F59E0B", "F43F5E"]
            ),
            defaultContent: "https://partystream.live/invite/leo30"
        ),
        QRTemplate(
            id: "ev_concert_neon",
            name: "Live Concert Tour",
            category: .event,
            title: "Live Music Tour",
            subtitle: "ENTRY PASS & SEAT MAP",
            categoryIcon: "music.mic",
            categoryLabel: "EVENT",
            footerText: "GET TICKETS",
            gradientHexColors: ["EC4899", "8B5CF6"],
            gradientStops: nil,
            accentColorHex: "EC4899",
            isPro: false,
            subCategory: "Concert",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .neonGlowRing,
                bannerText: "VIP CONCERT PASS",
                frameBrandColors: ["EC4899", "8B5CF6"]
            ),
            defaultContent: "https://livetour2026.com/ticket/gate-a"
        ),
        QRTemplate(
            id: "ev_vip_gala",
            name: "Black-Tie Gala",
            category: .event,
            title: "VIP Charity Gala",
            subtitle: "EXCLUSIVE EVENING",
            categoryIcon: "ticket.fill",
            categoryLabel: "EVENT",
            footerText: "RSVP CARD",
            gradientHexColors: ["D97706", "1C1917"],
            gradientStops: nil,
            accentColorHex: "D97706",
            isPro: true,
            subCategory: "Gala",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .cornerFlourish,
                bannerText: "EXCLUSIVE GALA",
                frameBrandColors: ["D97706", "1C1917"]
            ),
            defaultContent: "https://gala2026.org/invite/vip"
        ),
        QRTemplate(
            id: "ev_party_banner",
            name: "Weekend Party Night",
            category: .event,
            title: "Weekend Social",
            subtitle: "MUSIC & DRINKS",
            categoryIcon: "sparkles",
            categoryLabel: "EVENT",
            footerText: "JOIN EVENT",
            gradientHexColors: ["9333EA", "DB2777"],
            gradientStops: nil,
            accentColorHex: "9333EA",
            isPro: false,
            subCategory: "Party",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .rounded,
                decorativeFrame: .fullBanner,
                bannerText: "JOIN THE PARTY",
                frameBrandColors: ["9333EA", "DB2777"]
            ),
            defaultContent: "https://partynight.club/event/saturday"
        ),
        QRTemplate(
            id: "ev_charity_ribbon",
            name: "Charity Fundraiser",
            category: .event,
            title: "Hope Foundation",
            subtitle: "DONATE & EMPOWER",
            categoryIcon: "gift.fill",
            categoryLabel: "EVENT",
            footerText: "DONATE NOW",
            gradientHexColors: ["10B981", "059669"],
            gradientStops: nil,
            accentColorHex: "10B981",
            isPro: false,
            subCategory: "Gala",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .rounded,
                decorativeFrame: .ribbonBanner,
                bannerText: "SUPPORT CAUSE",
                frameBrandColors: ["10B981", "059669"]
            ),
            defaultContent: "https://hopefoundation.org/gala"
        ),
        QRTemplate(
            id: "ev_tech_summit",
            name: "Tech Summit 2026",
            category: .event,
            title: "Developer Keynote",
            subtitle: "CONFERENCE SCHEDULE",
            categoryIcon: "calendar.badge.clock",
            categoryLabel: "EVENT",
            footerText: "VIEW AGENDA",
            gradientHexColors: ["3B82F6", "1D4ED8"],
            gradientStops: nil,
            accentColorHex: "3B82F6",
            isPro: false,
            subCategory: "Conference",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .cornerBrackets,
                bannerText: "KEYNOTE & TALKS",
                frameBrandColors: ["3B82F6", "1D4ED8"]
            ),
            defaultContent: "https://techsummit2026.io/agenda"
        ),
        QRTemplate(
            id: "ev_marathon_race",
            name: "City Marathon 42K",
            category: .event,
            title: "Runner Check-in",
            subtitle: "TIMING CHIP & BIB PASS",
            categoryIcon: "figure.run",
            categoryLabel: "EVENT",
            footerText: "RACE PASS",
            gradientHexColors: ["EA580C", "F97316"],
            gradientStops: nil,
            accentColorHex: "EA580C",
            isPro: false,
            subCategory: "Party",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .wavesBorder,
                bannerText: "OFFICIAL RUNNER PASS",
                frameBrandColors: ["EA580C", "F97316"]
            ),
            defaultContent: "https://citymarathon.run/bib/509"
        ),
        QRTemplate(
            id: "ev_invitation_card",
            name: "Golden Invitation",
            category: .event,
            title: "Special Invitation",
            subtitle: "CORDIALLY INVITED",
            categoryIcon: "envelope.open.fill",
            categoryLabel: "EVENT",
            footerText: "OPEN INVITE",
            gradientHexColors: ["F43F5E", "FB7185", "FDA4AF"],
            gradientStops: nil,
            accentColorHex: "F43F5E",
            isPro: true,
            subCategory: "Wedding",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .rounded,
                decorativeFrame: .gradientCard,
                bannerText: "YOU'RE INVITED",
                frameBrandColors: ["F43F5E", "FB7185", "FDA4AF"]
            ),
            defaultContent: "https://invitationhub.app/card/exclusive"
        ),
        QRTemplate(
            id: "ev_club_neon",
            name: "Nightclub VIP Guest",
            category: .event,
            title: "After-Hours Club",
            subtitle: "VIP ACCESS TICKET",
            categoryIcon: "moon.stars.fill",
            categoryLabel: "EVENT",
            footerText: "ENTER CLUB",
            gradientHexColors: ["00F2FE", "7C3AED"],
            gradientStops: nil,
            accentColorHex: "00F2FE",
            isPro: true,
            subCategory: "Party",
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .leaf,
                decorativeFrame: .neonGlowRing,
                bannerText: "CLUB GUESTLIST",
                frameBrandColors: ["00F2FE", "7C3AED"]
            ),
            defaultContent: "https://afterhours.club/vip/entry-pass"
        ),
        QRTemplate(
            id: "clr_scanme_classic",
            name: "Classic Scan Me",
            category: .colorful,
            title: "Direct Link",
            subtitle: "HIGH-CONTRAST SCAN",
            categoryIcon: "qrcode",
            categoryLabel: "COLORFUL",
            footerText: "SCAN ME",
            gradientHexColors: ["111827", "1F2937"],
            gradientStops: nil,
            accentColorHex: "111827",
            isPro: false,
            subCategory: "Minimal",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .scanMeBanner,
                bannerText: "SCAN ME",
                frameBrandColors: ["111827"]
            ),
            defaultContent: "https://qrshield.app/start"
        ),
        QRTemplate(
            id: "clr_rainbow_burst",
            name: "Rainbow Halo",
            category: .colorful,
            title: "Vibrant Rainbow",
            subtitle: "MULTI-TONE GRADIENT BORDER",
            categoryIcon: "paintpalette.fill",
            categoryLabel: "COLORFUL",
            footerText: "EXPLORE",
            gradientHexColors: ["EF4444", "F59E0B", "10B981", "3B82F6", "8B5CF6"],
            gradientStops: nil,
            accentColorHex: "EF4444",
            isPro: true,
            subCategory: "Gradient",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .circular,
                decorativeFrame: .gradientBorder,
                bannerText: "DISCOVER",
                frameBrandColors: ["EF4444", "F59E0B", "10B981", "3B82F6", "8B5CF6"]
            ),
            defaultContent: "https://creativeart.studio/rainbow"
        ),
        QRTemplate(
            id: "clr_love_card",
            name: "Love Note Card",
            category: .colorful,
            title: "Sweetheart Message",
            subtitle: "SEND A SECRET LOVE NOTE",
            categoryIcon: "heart.fill",
            categoryLabel: "COLORFUL",
            footerText: "FOR MY LOVE",
            gradientHexColors: ["BE123C", "E11D48"],
            gradientStops: nil,
            accentColorHex: "E11D48",
            isPro: true,
            subCategory: "Hearts",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .rounded,
                decorativeFrame: .colorCard,
                bannerText: "I LOVE YOU",
                frameBrandColors: ["BE123C", "E11D48"]
            ),
            defaultContent: "https://mypassion.love/secret-note"
        ),
        QRTemplate(
            id: "clr_corner_hearts",
            name: "Romantic Hearts",
            category: .colorful,
            title: "Heart Corner Flair",
            subtitle: "GENTLE ROSE MOTIF",
            categoryIcon: "heart.circle.fill",
            categoryLabel: "COLORFUL",
            footerText: "VIEW MESSAGE",
            gradientHexColors: ["FB7185", "FDA4AF"],
            gradientStops: nil,
            accentColorHex: "FB7185",
            isPro: false,
            subCategory: "Hearts",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .leaf,
                decorativeFrame: .cornerHearts,
                bannerText: "FOR YOU",
                frameBrandColors: ["FB7185"]
            ),
            defaultContent: "https://hearts.gift/love/note"
        ),
        QRTemplate(
            id: "clr_corner_stars",
            name: "Gold Star Sparkle",
            category: .colorful,
            title: "Sparkle Magic",
            subtitle: "CELEBRATION STARS",
            categoryIcon: "star.fill",
            categoryLabel: "COLORFUL",
            footerText: "DISCOVER",
            gradientHexColors: ["FBBF24", "D97706"],
            gradientStops: nil,
            accentColorHex: "FBBF24",
            isPro: false,
            subCategory: "Artistic",
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .circular,
                decorativeFrame: .cornerStars,
                bannerText: "MAGIC MOMENT",
                frameBrandColors: ["FBBF24"]
            ),
            defaultContent: "https://sparkle.magic/wishes"
        ),
        QRTemplate(
            id: "clr_geo_matrix",
            name: "Geometric Matrix",
            category: .colorful,
            title: "Tech Geo Frame",
            subtitle: "FUTURISTIC TRIANGLE EDGES",
            categoryIcon: "cube.fill",
            categoryLabel: "COLORFUL",
            footerText: "EXPLORE MATRIX",
            gradientHexColors: ["0284C7", "3B82F6"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: true,
            subCategory: "Artistic",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .geometricFrame,
                bannerText: "EXPLORE",
                frameBrandColors: ["0284C7", "3B82F6"]
            ),
            defaultContent: "https://matrix.digital/explore"
        ),
        QRTemplate(
            id: "clr_retro_stamp",
            name: "Vintage Postage Stamp",
            category: .colorful,
            title: "Airmail Postage",
            subtitle: "AUTHENTIC PERFORATED STAMP",
            categoryIcon: "envelope.fill",
            categoryLabel: "COLORFUL",
            footerText: "MAIL SCAN",
            gradientHexColors: ["DC2626", "B91C1C"],
            gradientStops: nil,
            accentColorHex: "DC2626",
            isPro: false,
            subCategory: "Artistic",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .stampBorder,
                bannerText: "SPECIAL POST",
                frameBrandColors: ["DC2626"]
            ),
            defaultContent: "https://airmail.delivery/post/920"
        ),
        QRTemplate(
            id: "clr_neon_cyan",
            name: "Electric Cyan",
            category: .colorful,
            title: "Cyber Halo",
            subtitle: "HIGH INTENSITY GLOW",
            categoryIcon: "bolt.circle.fill",
            categoryLabel: "COLORFUL",
            footerText: "INITIALIZE",
            gradientHexColors: ["06B6D4", "00F2FE"],
            gradientStops: nil,
            accentColorHex: "06B6D4",
            isPro: true,
            subCategory: "Neon",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .circular,
                decorativeFrame: .neonGlowRing,
                bannerText: "CYBER ACCESS",
                frameBrandColors: ["06B6D4", "00F2FE"]
            ),
            defaultContent: "https://cyberaccess.network/sync"
        ),
        QRTemplate(
            id: "clr_corner_dots",
            name: "Studio Minimal Dots",
            category: .colorful,
            title: "Minimal Elegance",
            subtitle: "CLEAN FOUR-CORNER ACCENT",
            categoryIcon: "circle.grid.2x2",
            categoryLabel: "COLORFUL",
            footerText: "SCAN LINK",
            gradientHexColors: ["4B5563", "1F2937"],
            gradientStops: nil,
            accentColorHex: "4B5563",
            isPro: false,
            subCategory: "Minimal",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .circular,
                decorativeFrame: .cornerDots,
                bannerText: "SCAN CODE",
                frameBrandColors: ["4B5563"]
            ),
            defaultContent: "https://studiominimal.design"
        ),
        QRTemplate(
            id: "clr_double_purple",
            name: "Royal Purple Border",
            category: .colorful,
            title: "Regal Framing",
            subtitle: "PRECISION PARALLEL STROKES",
            categoryIcon: "crown.fill",
            categoryLabel: "COLORFUL",
            footerText: "ACCESS PASS",
            gradientHexColors: ["7C3AED", "6D28D9"],
            gradientStops: nil,
            accentColorHex: "7C3AED",
            isPro: false,
            subCategory: "Artistic",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .doubleLine,
                bannerText: "PREMIUM ACCESS",
                frameBrandColors: ["7C3AED"]
            ),
            defaultContent: "https://royalclub.exclusive/member"
        ),
        QRTemplate(
            id: "clr_ocean_waves",
            name: "Oceanic Wave Flow",
            category: .colorful,
            title: "Deep Aqua Waves",
            subtitle: "CURVED WATER RIPPLE EDGE",
            categoryIcon: "water.waves",
            categoryLabel: "COLORFUL",
            footerText: "DIVE IN",
            gradientHexColors: ["0284C7", "06B6D4"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: false,
            subCategory: "Gradient",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .wavesBorder,
                bannerText: "DIVE IN",
                frameBrandColors: ["0284C7", "06B6D4"]
            ),
            defaultContent: "https://aquasurf.ocean/tides"
        ),
        QRTemplate(
            id: "clr_luxury_gold",
            name: "Golden Baroque Flourish",
            category: .colorful,
            title: "Baroque Flourish",
            subtitle: "HAND-CRAFTED SWIRL CORNERS",
            categoryIcon: "sparkles",
            categoryLabel: "COLORFUL",
            footerText: "VIP SUITE",
            gradientHexColors: ["F59E0B", "B45309"],
            gradientStops: nil,
            accentColorHex: "F59E0B",
            isPro: true,
            subCategory: "Artistic",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .leaf,
                decorativeFrame: .cornerFlourish,
                bannerText: "GOLD COLLECTION",
                frameBrandColors: ["F59E0B", "B45309"]
            ),
            defaultContent: "https://goldencollection.luxe/suite"
        )
    ]

    // Curated high-engagement popular templates shown on Home screen
    static var popularTemplates: [QRTemplate] {
        let popularIds = ["ig_sunset_glow", "yt_red_banner", "clr_scanme_classic", "wifi_home_solid", "wa_direct_chat", "biz_menu_cafe", "ev_wedding_hearts", "fb_connect_header", "biz_coupon_deal", "clr_rainbow_burst"]
        let list = popularIds.compactMap { pid in
            predefinedTemplates.first(where: { $0.id == pid })
        }
        return list.isEmpty ? Array(predefinedTemplates.prefix(6)) : list
    }
}
