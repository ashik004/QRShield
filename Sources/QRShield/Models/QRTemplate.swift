import SwiftUI

public enum QRTemplateCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case socialMedia = "Social"
    case business = "Business"
    case wifi = "Wi-Fi"
    case event = "Event"
    case location = "Location"
    case email = "Email"
    
    public var id: String { rawValue }
    
    public var sfSymbol: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .socialMedia: return "person.2.fill"
        case .business: return "briefcase.fill"
        case .wifi: return "wifi"
        case .event: return "calendar"
        case .location: return "mappin.and.ellipse"
        case .email: return "envelope.fill"
        }
    }
    
    public var defaultBadgeLabel: String {
        switch self {
        case .all: return "ALL"
        case .socialMedia: return "SOCIAL"
        case .business: return "BUSINESS"
        case .wifi: return "WI-FI"
        case .event: return "EVENT"
        case .location: return "LOCATION"
        case .email: return "EMAIL"
        }
    }
}

public extension QRTemplateCategory {
    // Backward compatibility alias for existing code
    static let social = QRTemplateCategory.socialMedia
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
        accentColorHex: String = "FFFFFF"
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
        // ==========================================
        // 1. SOCIAL MEDIA CATEGORY (11 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "instagram_social",
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
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .instagram
            ),
            defaultContent: "https://instagram.com/qrshield"
        ),
        QRTemplate(
            id: "youtube_social",
            name: "YouTube Red",
            category: .socialMedia,
            title: "YouTube",
            subtitle: "WATCH MORE",
            categoryIcon: "play.rectangle.fill",
            categoryLabel: "SOCIAL",
            footerText: "WATCH MORE",
            gradientHexColors: ["EF4444", "F97316", "DC2626"],
            gradientStops: [0.0, 0.58, 1.0],
            accentColorHex: "F97316",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .youtube
            ),
            defaultContent: "https://youtube.com/@qrshield"
        ),
        QRTemplate(
            id: "tiktok_neon",
            name: "TikTok Creator",
            category: .socialMedia,
            title: "TikTok",
            subtitle: "WATCH VIDEOS",
            categoryIcon: "music.note",
            categoryLabel: "SOCIAL",
            footerText: "WATCH NOW",
            gradientHexColors: ["00F2FE", "4FACFE", "000000"],
            accentColorHex: "00F2FE",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://tiktok.com/@qrshield"
        ),
        QRTemplate(
            id: "whatsapp_direct",
            name: "WhatsApp Chat",
            category: .socialMedia,
            title: "WhatsApp",
            subtitle: "CHAT WITH US",
            categoryIcon: "message.fill",
            categoryLabel: "SOCIAL",
            footerText: "CHAT NOW",
            gradientHexColors: ["10B981", "059669", "047857"],
            accentColorHex: "10B981",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .whatsapp
            ),
            defaultContent: "https://wa.me/15551234567"
        ),
        QRTemplate(
            id: "twitter_x_card",
            name: "X (Twitter)",
            category: .socialMedia,
            title: "X Profile",
            subtitle: "LATEST UPDATES",
            categoryIcon: "bubble.left.and.bubble.right.fill",
            categoryLabel: "SOCIAL",
            footerText: "FOLLOW @US",
            gradientHexColors: ["18181B", "27272A", "09090B"],
            accentColorHex: "38BDF8",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://x.com/qrshield"
        ),
        QRTemplate(
            id: "linkedin_pro",
            name: "LinkedIn Connect",
            category: .socialMedia,
            title: "LinkedIn",
            subtitle: "LET'S CONNECT",
            categoryIcon: "person.crop.circle.fill.badge.plus",
            categoryLabel: "SOCIAL",
            footerText: "CONNECT",
            gradientHexColors: ["0077B5", "0A66C2", "004182"],
            accentColorHex: "0A66C2",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://linkedin.com/in/qrshield"
        ),
        QRTemplate(
            id: "spotify_music",
            name: "Spotify Stream",
            category: .socialMedia,
            title: "Spotify",
            subtitle: "LISTEN NOW",
            categoryIcon: "headphones",
            categoryLabel: "SOCIAL",
            footerText: "STREAM NOW",
            gradientHexColors: ["1DB954", "191414", "121212"],
            accentColorHex: "1DB954",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://open.spotify.com/artist/qrshield"
        ),
        QRTemplate(
            id: "telegram_channel",
            name: "Telegram Channel",
            category: .socialMedia,
            title: "Telegram",
            subtitle: "JOIN COMMUNITY",
            categoryIcon: "paperplane.fill",
            categoryLabel: "SOCIAL",
            footerText: "JOIN US",
            gradientHexColors: ["229ED9", "1E88E5", "1565C0"],
            accentColorHex: "229ED9",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://t.me/qrshield"
        ),
        QRTemplate(
            id: "pinterest_board",
            name: "Pinterest Board",
            category: .socialMedia,
            title: "Pinterest",
            subtitle: "PIN INSPIRATION",
            categoryIcon: "pin.fill",
            categoryLabel: "SOCIAL",
            footerText: "PIN NOW",
            gradientHexColors: ["E60023", "BD081C", "9B0014"],
            accentColorHex: "E60023",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://pinterest.com/qrshield"
        ),
        QRTemplate(
            id: "discord_server",
            name: "Discord Server",
            category: .socialMedia,
            title: "Discord",
            subtitle: "JOIN OUR SERVER",
            categoryIcon: "bubble.left.fill",
            categoryLabel: "SOCIAL",
            footerText: "JOIN SERVER",
            gradientHexColors: ["5865F2", "4752C4", "3C45A5"],
            accentColorHex: "5865F2",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://discord.gg/qrshield"
        ),
        QRTemplate(
            id: "snapchat_spotlight",
            name: "Snapchat Spotlight",
            category: .socialMedia,
            title: "Snapchat",
            subtitle: "ADD ON SNAP",
            categoryIcon: "bell.fill",
            categoryLabel: "SOCIAL",
            footerText: "ADD FRIEND",
            gradientHexColors: ["F59E0B", "FBBF24", "D97706"],
            accentColorHex: "FBBF24",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://snapchat.com/add/qrshield"
        ),

        // ==========================================
        // 2. BUSINESS CATEGORY (10 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "business_executive",
            name: "Corporate Executive",
            category: .business,
            title: "Business Card",
            subtitle: "CONNECT PROFESSIONALLY",
            categoryIcon: "briefcase.fill",
            categoryLabel: "BUSINESS",
            footerText: "SAVE CONTACT",
            gradientHexColors: ["1E293B", "334155", "0F172A"],
            accentColorHex: "38BDF8",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "BEGIN:VCARD\nVERSION:3.0\nFN:Alex Vance\nORG:Apex Tech\nTITLE:CEO\nTEL:+15550192831\nEMAIL:alex@apextech.com\nEND:VCARD"
        ),
        QRTemplate(
            id: "business_startup",
            name: "Tech Startup",
            category: .business,
            title: "Startup Pitch",
            subtitle: "INNOVATIVE SOLUTIONS",
            categoryIcon: "bolt.fill",
            categoryLabel: "BUSINESS",
            footerText: "EXPLORE",
            gradientHexColors: ["4F46E5", "7C3AED", "9333EA"],
            accentColorHex: "A855F7",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://startup.tech/pitch"
        ),
        QRTemplate(
            id: "business_luxury",
            name: "Luxury Boutique",
            category: .business,
            title: "Luxury Brand",
            subtitle: "EXCLUSIVE COLLECTION",
            categoryIcon: "crown.fill",
            categoryLabel: "BUSINESS",
            footerText: "SHOP NOW",
            gradientHexColors: ["1C1917", "44403C", "78716C"],
            accentColorHex: "FBBF24",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maisonluxe.co/collection"
        ),
        QRTemplate(
            id: "business_creative",
            name: "Creative Studio",
            category: .business,
            title: "Design Studio",
            subtitle: "WE CRAFT EXPERIENCES",
            categoryIcon: "sparkles",
            categoryLabel: "BUSINESS",
            footerText: "VIEW WORK",
            gradientHexColors: ["06B6D4", "3B82F6", "1D4ED8"],
            accentColorHex: "06B6D4",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://studioaura.design"
        ),
        QRTemplate(
            id: "business_consulting",
            name: "Strategic Advisory",
            category: .business,
            title: "Advisory Group",
            subtitle: "STRATEGIC INSIGHTS",
            categoryIcon: "chart.line.uptrend.xyaxis",
            categoryLabel: "BUSINESS",
            footerText: "LEARN MORE",
            gradientHexColors: ["047857", "065F46", "064E3B"],
            accentColorHex: "34D399",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://vanguardstrategy.com/insights"
        ),
        QRTemplate(
            id: "business_portfolio",
            name: "Design Portfolio",
            category: .business,
            title: "Creative Folio",
            subtitle: "FEATURED PROJECTS",
            categoryIcon: "star.fill",
            categoryLabel: "BUSINESS",
            footerText: "SEE PORTFOLIO",
            gradientHexColors: ["8B5CF6", "EC4899", "F43F5E"],
            accentColorHex: "F43F5E",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://dribbble.com/qrshield"
        ),
        QRTemplate(
            id: "business_restaurant",
            name: "Gourmet Restaurant",
            category: .business,
            title: "Gourmet Menu",
            subtitle: "DIGITAL DINING MENU",
            categoryIcon: "fork.knife",
            categoryLabel: "BUSINESS",
            footerText: "VIEW MENU",
            gradientHexColors: ["DC2626", "EA580C", "C2410C"],
            accentColorHex: "F97316",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://bistromoderne.com/menu"
        ),
        QRTemplate(
            id: "business_realestate",
            name: "Real Estate Listing",
            category: .business,
            title: "Property Tour",
            subtitle: "VIRTUAL WALKTHROUGH",
            categoryIcon: "house.fill",
            categoryLabel: "BUSINESS",
            footerText: "VIEW PROPERTY",
            gradientHexColors: ["0284C7", "0369A1", "075985"],
            accentColorHex: "38BDF8",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://skylinehomes.re/villa-402"
        ),
        QRTemplate(
            id: "business_wealth",
            name: "Wealth Management",
            category: .business,
            title: "Wealth Advisory",
            subtitle: "SECURE YOUR FUTURE",
            categoryIcon: "dollarsign.circle.fill",
            categoryLabel: "BUSINESS",
            footerText: "SCHEDULE CALL",
            gradientHexColors: ["059669", "0D9488", "115E59"],
            accentColorHex: "2DD4BF",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://crestwealth.com/consult"
        ),
        QRTemplate(
            id: "business_fitness",
            name: "Fitness Club",
            category: .business,
            title: "Fitness Center",
            subtitle: "FREE TRIAL PASS",
            categoryIcon: "figure.run",
            categoryLabel: "BUSINESS",
            footerText: "START TRIAL",
            gradientHexColors: ["F43F5E", "FB7185", "E11D48"],
            accentColorHex: "FB7185",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://peakgym.club/pass"
        ),

        // ==========================================
        // 3. WI-FI CATEGORY (10 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "wifi_home_blue",
            name: "Home Gigabit Wi-Fi",
            category: .wifi,
            title: "Home Network",
            subtitle: "ULTRA FAST WI-FI",
            categoryIcon: "wifi",
            categoryLabel: "WI-FI",
            footerText: "CONNECT NOW",
            gradientHexColors: ["2563EB", "3B82F6", "1D4ED8"],
            accentColorHex: "60A5FA",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:MyHome_5G;T:WPA;P:SuperSecretPass2026;;"
        ),
        QRTemplate(
            id: "wifi_cafe_amber",
            name: "Coffee Shop Guest",
            category: .wifi,
            title: "Café Guest Wi-Fi",
            subtitle: "FREE GUEST ACCESS",
            categoryIcon: "cup.and.saucer.fill",
            categoryLabel: "WI-FI",
            footerText: "TAP TO CONNECT",
            gradientHexColors: ["78350F", "92400E", "B45309"],
            accentColorHex: "F59E0B",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:ArtisanCoffee_Guest;T:WPA;P:coffee2026;;"
        ),
        QRTemplate(
            id: "wifi_enterprise_dark",
            name: "Office Enterprise",
            category: .wifi,
            title: "Office Secured",
            subtitle: "CORPORATE WI-FI",
            categoryIcon: "network",
            categoryLabel: "WI-FI",
            footerText: "CONNECT",
            gradientHexColors: ["0F172A", "1E293B", "334155"],
            accentColorHex: "38BDF8",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:ApexHQ_Corp;T:WPA;P:Enterprise99281;;"
        ),
        QRTemplate(
            id: "wifi_neon_fiber",
            name: "Cyberpunk Fiber",
            category: .wifi,
            title: "Gigabit Fiber",
            subtitle: "LOW LATENCY SPEED",
            categoryIcon: "bolt.horizontal.fill",
            categoryLabel: "WI-FI",
            footerText: "FAST ACCESS",
            gradientHexColors: ["4C1D95", "7C3AED", "C026D3"],
            accentColorHex: "E879F9",
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:QuantumFiber_10G;T:WPA;P:photonWave99;;"
        ),
        QRTemplate(
            id: "wifi_hotel_lounge",
            name: "Hotel Lounge Wi-Fi",
            category: .wifi,
            title: "Lounge Wi-Fi",
            subtitle: "COMPLIMENTARY GUEST",
            categoryIcon: "wifi.router.fill",
            categoryLabel: "WI-FI",
            footerText: "WELCOME",
            gradientHexColors: ["14532D", "166534", "15803D"],
            accentColorHex: "4ADE80",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:GrandResort_Lounge;T:WPA;P:welcomeGuest;;"
        ),
        QRTemplate(
            id: "wifi_coworking",
            name: "Co-Working Space",
            category: .wifi,
            title: "Co-Work Speed",
            subtitle: "SEAMLESS SYNC",
            categoryIcon: "laptopcomputer",
            categoryLabel: "WI-FI",
            footerText: "GET ACCESS",
            gradientHexColors: ["4338CA", "6366F1", "818CF8"],
            accentColorHex: "A5B4FC",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:HubWork_Member;T:WPA;P:creatorPass88;;"
        ),
        QRTemplate(
            id: "wifi_airport",
            name: "Airport Terminal",
            category: .wifi,
            title: "Terminal Wi-Fi",
            subtitle: "STAY CONNECTED",
            categoryIcon: "airplane",
            categoryLabel: "WI-FI",
            footerText: "CONNECT FREE",
            gradientHexColors: ["0369A1", "0284C7", "38BDF8"],
            accentColorHex: "7DD3FC",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:SkyPort_FreeWiFi;T:nopass;P:;;"
        ),
        QRTemplate(
            id: "wifi_library",
            name: "Campus Library",
            category: .wifi,
            title: "Campus Network",
            subtitle: "STUDY QUIET ZONE",
            categoryIcon: "book.fill",
            categoryLabel: "WI-FI",
            footerText: "CONNECT ID",
            gradientHexColors: ["374151", "4B5563", "6B7280"],
            accentColorHex: "9CA3AF",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:Campus_Eduroam;T:WPA;P:scholar2026;;"
        ),
        QRTemplate(
            id: "wifi_event_guest",
            name: "Event Guest Access",
            category: .wifi,
            title: "Event Guest Wi-Fi",
            subtitle: "NO PASSWORD REQUIRED",
            categoryIcon: "antenna.radiowaves.left.and.right",
            categoryLabel: "WI-FI",
            footerText: "ONE TAP JOIN",
            gradientHexColors: ["9333EA", "A855F7", "C084FC"],
            accentColorHex: "E9D5FF",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:Expo2026_Guest;T:nopass;P:;;"
        ),
        QRTemplate(
            id: "wifi_studio_prod",
            name: "Studio Production",
            category: .wifi,
            title: "Studio Network",
            subtitle: "SECURE BROADCAST",
            categoryIcon: "lock.shield.fill",
            categoryLabel: "WI-FI",
            footerText: "AUTHENTICATE",
            gradientHexColors: ["991B1B", "DC2626", "EF4444"],
            accentColorHex: "F87171",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "WIFI:S:StudioStream_Private;T:WPA;P:prodCastPass42;;"
        ),

        // ==========================================
        // 4. EVENT CATEGORY (10 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "event_vip_gala",
            name: "VIP Gala Night",
            category: .event,
            title: "VIP Gala Event",
            subtitle: "EXCLUSIVE INVITATION",
            categoryIcon: "ticket.fill",
            categoryLabel: "EVENT",
            footerText: "RSVP NOW",
            gradientHexColors: ["18181B", "27272A", "09090B"],
            accentColorHex: "F59E0B",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://gala2026.org/invite/vip"
        ),
        QRTemplate(
            id: "event_tech_summit",
            name: "Tech Summit 2026",
            category: .event,
            title: "Tech Summit",
            subtitle: "KEYNOTE & WORKSHOPS",
            categoryIcon: "calendar.badge.clock",
            categoryLabel: "EVENT",
            footerText: "VIEW SCHEDULE",
            gradientHexColors: ["4F46E5", "7C3AED", "2563EB"],
            accentColorHex: "60A5FA",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://techsummit2026.io/agenda"
        ),
        QRTemplate(
            id: "event_live_concert",
            name: "Live Concert Tour",
            category: .event,
            title: "Live Tour 2026",
            subtitle: "CONCERT ENTRY PASS",
            categoryIcon: "music.mic",
            categoryLabel: "EVENT",
            footerText: "VIEW PASS",
            gradientHexColors: ["BE185D", "DB2777", "F43F5E"],
            accentColorHex: "FB7185",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://livetour2026.com/ticket/gate-a"
        ),
        QRTemplate(
            id: "event_wedding_ceremony",
            name: "Wedding Celebration",
            category: .event,
            title: "Save Our Date",
            subtitle: "CELEBRATE WITH US",
            categoryIcon: "heart.fill",
            categoryLabel: "EVENT",
            footerText: "OUR WEDDING",
            gradientHexColors: ["BE123C", "FB7185", "FDA4AF"],
            accentColorHex: "FECDD3",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://sarah-and-daniel.wedding"
        ),
        QRTemplate(
            id: "event_charity_gala",
            name: "Charity Benefit Gala",
            category: .event,
            title: "Charity Benefit",
            subtitle: "SUPPORT OUR MISSION",
            categoryIcon: "gift.fill",
            categoryLabel: "EVENT",
            footerText: "DONATE & BID",
            gradientHexColors: ["065F46", "047857", "0D9488"],
            accentColorHex: "34D399",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://hopefoundation.org/gala"
        ),
        QRTemplate(
            id: "event_esports_champs",
            name: "Gaming Finals",
            category: .event,
            title: "Championship Finals",
            subtitle: "BRACKETS & STREAM",
            categoryIcon: "gamecontroller.fill",
            categoryLabel: "EVENT",
            footerText: "WATCH LIVE",
            gradientHexColors: ["1E1B4B", "312E81", "4338CA"],
            accentColorHex: "818CF8",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://esportsarena.gg/finals2026"
        ),
        QRTemplate(
            id: "event_art_exhibit",
            name: "Modern Art Exhibition",
            category: .event,
            title: "Art Exhibition",
            subtitle: "VERNISSAGE OPENING",
            categoryIcon: "paintpalette.fill",
            categoryLabel: "EVENT",
            footerText: "EXPLORE ART",
            gradientHexColors: ["1C1917", "292524", "44403C"],
            accentColorHex: "D97706",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://modernart.museum/exhibit/future"
        ),
        QRTemplate(
            id: "event_marathon_42k",
            name: "City Marathon 42K",
            category: .event,
            title: "City Marathon",
            subtitle: "RUNNER INFO & TRACKING",
            categoryIcon: "figure.run",
            categoryLabel: "EVENT",
            footerText: "RACE PASS",
            gradientHexColors: ["C2410C", "EA580C", "F97316"],
            accentColorHex: "FDBA74",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://citymarathon.run/bib/509"
        ),
        QRTemplate(
            id: "event_birthday_party",
            name: "Birthday Party Bash",
            category: .event,
            title: "Birthday Party",
            subtitle: "JOIN THE CELEBRATION",
            categoryIcon: "party.popper.fill",
            categoryLabel: "EVENT",
            footerText: "YOU'RE INVITED",
            gradientHexColors: ["7C2D12", "C2410C", "EA580C"],
            accentColorHex: "FDE047",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://partystream.live/invite/leo30"
        ),
        QRTemplate(
            id: "event_pitch_night",
            name: "Demo Day Pitch",
            category: .event,
            title: "Demo Day Pitch",
            subtitle: "VENTURE PITCH NIGHT",
            categoryIcon: "lightbulb.fill",
            categoryLabel: "EVENT",
            footerText: "VIEW PITCHES",
            gradientHexColors: ["0284C7", "2563EB", "1D4ED8"],
            accentColorHex: "93C5FD",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://demoday.accelerate.vc"
        ),

        // ==========================================
        // 5. LOCATION CATEGORY (10 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "location_hq_map",
            name: "Headquarters Map",
            category: .location,
            title: "Find Our HQ",
            subtitle: "GET DIRECTIONS",
            categoryIcon: "mappin.and.ellipse",
            categoryLabel: "LOCATION",
            footerText: "OPEN MAP",
            gradientHexColors: ["0D9488", "0F766E", "115E59"],
            accentColorHex: "2DD4BF",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=One+Infinite+Loop,Cupertino,CA"
        ),
        QRTemplate(
            id: "location_downtown_venue",
            name: "Downtown Venue",
            category: .location,
            title: "Downtown Venue",
            subtitle: "CENTRAL LOCATION",
            categoryIcon: "map.fill",
            categoryLabel: "LOCATION",
            footerText: "VIEW ROUTE",
            gradientHexColors: ["2563EB", "1D4ED8", "1E40AF"],
            accentColorHex: "60A5FA",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=Civic+Center+Plaza,San+Francisco"
        ),
        QRTemplate(
            id: "location_park_trail",
            name: "Scenic Park Trail",
            category: .location,
            title: "National Park",
            subtitle: "TRAILHEAD MAP & GUIDE",
            categoryIcon: "leaf.fill",
            categoryLabel: "LOCATION",
            footerText: "EXPLORE TRAIL",
            gradientHexColors: ["15803D", "166534", "14532D"],
            accentColorHex: "4ADE80",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=Yosemite+Valley+Trailhead"
        ),
        QRTemplate(
            id: "location_rooftop_lounge",
            name: "Skyview Rooftop",
            category: .location,
            title: "Skyview Lounge",
            subtitle: "FLOOR 42 ROOFTOP",
            categoryIcon: "building.2.fill",
            categoryLabel: "LOCATION",
            footerText: "FIND VENUE",
            gradientHexColors: ["4C1D95", "6D28D9", "5B21B6"],
            accentColorHex: "C084FC",
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=Empire+State+Building,NYC"
        ),
        QRTemplate(
            id: "location_heritage_museum",
            name: "Heritage Museum",
            category: .location,
            title: "Heritage Museum",
            subtitle: "MAIN ENTRANCE",
            categoryIcon: "building.columns.fill",
            categoryLabel: "LOCATION",
            footerText: "EXPLORE",
            gradientHexColors: ["78350F", "92400E", "B45309"],
            accentColorHex: "FBBF24",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=Metropolitan+Museum+of+Art,NYC"
        ),
        QRTemplate(
            id: "location_university_campus",
            name: "University Campus",
            category: .location,
            title: "University Hall",
            subtitle: "STUDENT CENTER",
            categoryIcon: "graduationcap.fill",
            categoryLabel: "LOCATION",
            footerText: "CAMPUS MAP",
            gradientHexColors: ["1E293B", "334155", "475569"],
            accentColorHex: "94A3B8",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=Stanford+University+Main+Quad"
        ),
        QRTemplate(
            id: "location_beach_resort",
            name: "Seaside Resort",
            category: .location,
            title: "Seaside Resort",
            subtitle: "OCEANFRONT ACCESS",
            categoryIcon: "sun.max.fill",
            categoryLabel: "LOCATION",
            footerText: "RESORT MAP",
            gradientHexColors: ["0284C7", "06B6D4", "0891B2"],
            accentColorHex: "67E8F9",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=Waikiki+Beach,Honolulu"
        ),
        QRTemplate(
            id: "location_express_parking",
            name: "Express Parking P3",
            category: .location,
            title: "Express Parking",
            subtitle: "P3 LEVEL ACCESS",
            categoryIcon: "car.fill",
            categoryLabel: "LOCATION",
            footerText: "NAVIGATE TO SPOT",
            gradientHexColors: ["374151", "1F2937", "111827"],
            accentColorHex: "F59E0B",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=Terminal+2+Parking,SFO"
        ),
        QRTemplate(
            id: "location_medical_center",
            name: "Medical Clinic",
            category: .location,
            title: "Medical Center",
            subtitle: "EMERGENCY & CLINIC",
            categoryIcon: "cross.case.fill",
            categoryLabel: "LOCATION",
            footerText: "DIRECTIONS",
            gradientHexColors: ["DC2626", "B91C1C", "991B1B"],
            accentColorHex: "FCA5A5",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=UCSF+Medical+Center,San+Francisco"
        ),
        QRTemplate(
            id: "location_festival_gate",
            name: "Festival Entrance",
            category: .location,
            title: "Festival Gate B",
            subtitle: "VIP ENTRANCE POINT",
            categoryIcon: "flag.fill",
            categoryLabel: "LOCATION",
            footerText: "MAP TO GATE",
            gradientHexColors: ["7C3AED", "A855F7", "C026D3"],
            accentColorHex: "F472B6",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "https://maps.apple.com/?q=Coachella+Valley+Festival+Grounds"
        ),

        // ==========================================
        // 6. EMAIL CATEGORY (10 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "email_customer_support",
            name: "Customer Support",
            category: .email,
            title: "Support Desk",
            subtitle: "24/7 DEDICATED HELP",
            categoryIcon: "envelope.fill",
            categoryLabel: "EMAIL",
            footerText: "SEND EMAIL",
            gradientHexColors: ["2563EB", "3B82F6", "1D4ED8"],
            accentColorHex: "93C5FD",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:support@qrshield.app?subject=Support%20Request"
        ),
        QRTemplate(
            id: "email_sales_inquiry",
            name: "Sales Inquiries",
            category: .email,
            title: "Sales Team",
            subtitle: "REQUEST A QUOTE",
            categoryIcon: "cart.fill",
            categoryLabel: "EMAIL",
            footerText: "EMAIL SALES",
            gradientHexColors: ["059669", "10B981", "047857"],
            accentColorHex: "6EE7B7",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:sales@apextech.com?subject=Enterprise%20Inquiry"
        ),
        QRTemplate(
            id: "email_press_media",
            name: "Press & Media",
            category: .email,
            title: "Press Relations",
            subtitle: "MEDIA KIT & INTERVIEWS",
            categoryIcon: "newspaper.fill",
            categoryLabel: "EMAIL",
            footerText: "CONTACT PR",
            gradientHexColors: ["4F46E5", "6366F1", "4338CA"],
            accentColorHex: "A5B4FC",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:press@qrshield.app?subject=Media%20Coverage"
        ),
        QRTemplate(
            id: "email_careers_talent",
            name: "Careers & Talent",
            category: .email,
            title: "Join Our Team",
            subtitle: "SEND YOUR RESUME",
            categoryIcon: "person.badge.plus",
            categoryLabel: "EMAIL",
            footerText: "APPLY NOW",
            gradientHexColors: ["7C3AED", "8B5CF6", "6D28D9"],
            accentColorHex: "C4B5FD",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:careers@apextech.com?subject=Application%20Submission"
        ),
        QRTemplate(
            id: "email_executive_desk",
            name: "Executive Office",
            category: .email,
            title: "Executive Desk",
            subtitle: "CONFIDENTIAL CONTACT",
            categoryIcon: "briefcase.fill",
            categoryLabel: "EMAIL",
            footerText: "DIRECT EMAIL",
            gradientHexColors: ["0F172A", "1E293B", "334155"],
            accentColorHex: "38BDF8",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:executive@apextech.com?subject=Confidential%20Inquiry"
        ),
        QRTemplate(
            id: "email_feedback_box",
            name: "Feedback Box",
            category: .email,
            title: "Feedback Desk",
            subtitle: "TELL US YOUR THOUGHTS",
            categoryIcon: "lightbulb.fill",
            categoryLabel: "EMAIL",
            footerText: "SEND FEEDBACK",
            gradientHexColors: ["EA580C", "F97316", "FB923C"],
            accentColorHex: "FDBA74",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:feedback@qrshield.app?subject=Product%20Feedback"
        ),
        QRTemplate(
            id: "email_partner_network",
            name: "Partner Network",
            category: .email,
            title: "Partner Team",
            subtitle: "COLLABORATE WITH US",
            categoryIcon: "hand.raised.fill",
            categoryLabel: "EMAIL",
            footerText: "BECOME PARTNER",
            gradientHexColors: ["0D9488", "14B8A6", "0F766E"],
            accentColorHex: "5EEAD4",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:partners@qrshield.app?subject=Partnership%20Proposal"
        ),
        QRTemplate(
            id: "email_booking_desk",
            name: "VIP Reservations",
            category: .email,
            title: "Reservation Desk",
            subtitle: "CONFIRM YOUR BOOKING",
            categoryIcon: "calendar.fill",
            categoryLabel: "EMAIL",
            footerText: "EMAIL BOOKING",
            gradientHexColors: ["DB2777", "EC4899", "F43F5E"],
            accentColorHex: "FDA4AF",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:reservations@bistromoderne.com?subject=Table%20Reservation"
        ),
        QRTemplate(
            id: "email_legal_counsel",
            name: "Legal & Privacy",
            category: .email,
            title: "Legal Counsel",
            subtitle: "COMPLIANCE & PRIVACY",
            categoryIcon: "shield.lefthalf.filled",
            categoryLabel: "EMAIL",
            footerText: "LEGAL NOTICE",
            gradientHexColors: ["334155", "1E293B", "0F172A"],
            accentColorHex: "CBD5E1",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:legal@qrshield.app?subject=Legal%20Notice"
        ),
        QRTemplate(
            id: "email_weekly_digest",
            name: "Newsletter Dispatch",
            category: .email,
            title: "Weekly Digest",
            subtitle: "GET CURATED UPDATES",
            categoryIcon: "paperplane.fill",
            categoryLabel: "EMAIL",
            footerText: "SUBSCRIBE",
            gradientHexColors: ["9333EA", "C026D3", "DB2777"],
            accentColorHex: "F472B6",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultContent: "mailto:subscribe@qrshield.app?subject=Subscribe%20Newsletter"
        )
    ]
    
    // Curated high-engagement popular templates shown on Home screen
    static var popularTemplates: [QRTemplate] {
        let popularIds = [
            "instagram_social",
            "youtube_social",
            "wifi_home_blue",
            "whatsapp_direct",
            "business_executive",
            "tiktok_neon"
        ]
        let list = popularIds.compactMap { pid in
            predefinedTemplates.first(where: { $0.id == pid })
        }
        return list.isEmpty ? Array(predefinedTemplates.prefix(6)) : list
    }
}
