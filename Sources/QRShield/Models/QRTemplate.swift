import SwiftUI

public enum QRTemplateCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case social = "Social"
    case wifi = "Wi-Fi"
    case business = "Business"
    case event = "Event"
    
    public var id: String { rawValue }
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
    public let badgeText: String?
    public let badgePosition: TemplateBadgePosition
    public let styleConfig: QRStyleConfig
    public let defaultTitle: String
    public let defaultContent: String
    public let previewGradientHex: [String]
    public let accentColorHex: String
    
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
        self.badgeText = badgeText
        self.badgePosition = badgePosition
        self.styleConfig = styleConfig
        self.defaultTitle = defaultTitle
        self.defaultContent = defaultContent
        self.previewGradientHex = previewGradientHex
        self.accentColorHex = accentColorHex
    }
}

public extension QRTemplate {
    static let predefinedTemplates: [QRTemplate] = [
        // ==========================================
        // 1. SOCIAL CATEGORY (11 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "instagram",
            name: "Instagram Sunset",
            category: .social,
            badgeText: nil,
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .instagram
            ),
            defaultTitle: "My Instagram",
            defaultContent: "https://instagram.com/qrshield",
            previewGradientHex: ["F58529", "DD2A7B", "8134AF"]
        ),
        QRTemplate(
            id: "youtube",
            name: "YouTube Channel",
            category: .social,
            badgeText: nil,
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .youtube
            ),
            defaultTitle: "YouTube Channel",
            defaultContent: "https://youtube.com/@qrshield",
            previewGradientHex: ["EF4444", "B91C1C"]
        ),
        QRTemplate(
            id: "whatsapp",
            name: "WhatsApp Chat",
            category: .social,
            badgeText: nil,
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .whatsapp
            ),
            defaultTitle: "WhatsApp Contact",
            defaultContent: "https://wa.me/15551234567",
            previewGradientHex: ["10B981", "059669"]
        ),
        QRTemplate(
            id: "tiktok",
            name: "TikTok Creator",
            category: .social,
            badgeText: "TIKTOK",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .midnightDark,
                backgroundColorHex: "000000",
                logoType: .none
            ),
            defaultTitle: "TikTok Profile",
            defaultContent: "https://tiktok.com/@qrshield",
            previewGradientHex: ["00F2FE", "4FACFE", "000000"],
            accentColorHex: "00F2FE"
        ),
        QRTemplate(
            id: "twitter_x",
            name: "X (Twitter)",
            category: .social,
            badgeText: "𝕏",
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultTitle: "X Profile",
            defaultContent: "https://x.com/qrshield",
            previewGradientHex: ["18181B", "09090B"]
        ),
        QRTemplate(
            id: "linkedin",
            name: "LinkedIn Pro",
            category: .social,
            badgeText: nil,
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .link
            ),
            defaultTitle: "LinkedIn Network",
            defaultContent: "https://linkedin.com/in/qrshield",
            previewGradientHex: ["0A66C2", "004182"]
        ),
        QRTemplate(
            id: "telegram",
            name: "Telegram Channel",
            category: .social,
            badgeText: nil,
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .link
            ),
            defaultTitle: "Telegram Group",
            defaultContent: "https://t.me/qrshield",
            previewGradientHex: ["229ED9", "1E88E5"]
        ),
        QRTemplate(
            id: "spotify",
            name: "Spotify Sound",
            category: .social,
            badgeText: "MUSIC",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "121212",
                logoType: .none
            ),
            defaultTitle: "Spotify Playlist",
            defaultContent: "https://open.spotify.com/playlist/qrshield",
            previewGradientHex: ["1DB954", "191414"],
            accentColorHex: "1DB954"
        ),
        QRTemplate(
            id: "snapchat",
            name: "Snapchat Code",
            category: .social,
            badgeText: "SNAP",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFC00",
                logoType: .none
            ),
            defaultTitle: "Snapchat Add",
            defaultContent: "https://snapchat.com/add/qrshield",
            previewGradientHex: ["FFFC00", "F59E0B"],
            accentColorHex: "000000"
        ),
        QRTemplate(
            id: "discord",
            name: "Discord Server",
            category: .social,
            badgeText: nil,
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .star
            ),
            defaultTitle: "Discord Server",
            defaultContent: "https://discord.gg/qrshield",
            previewGradientHex: ["5865F2", "4752C4"]
        ),
        QRTemplate(
            id: "threads",
            name: "Threads Feed",
            category: .social,
            badgeText: "@threads",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultTitle: "Threads Page",
            defaultContent: "https://threads.net/@qrshield",
            previewGradientHex: ["27272A", "09090B"]
        ),
        
        // ==========================================
        // 2. WI-FI CATEGORY (11 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "wifi_home",
            name: "Home Cozy Wi-Fi",
            category: .wifi,
            badgeText: nil,
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi
            ),
            defaultTitle: "Home Wi-Fi",
            defaultContent: "WIFI:T:WPA;S:Home_Network;P:MySafePass123;;",
            previewGradientHex: ["06B6D4", "3B82F6"]
        ),
        QRTemplate(
            id: "wifi_office",
            name: "Office Enterprise",
            category: .wifi,
            badgeText: "OFFICE",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi
            ),
            defaultTitle: "Corporate Wi-Fi",
            defaultContent: "WIFI:T:WPA;S:Office_Guest;P:CorpSecure2026;;",
            previewGradientHex: ["1E3A8A", "3B82F6"]
        ),
        QRTemplate(
            id: "wifi_cafe",
            name: "Cafe & Lounge",
            category: .wifi,
            badgeText: "☕ CAFE",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi
            ),
            defaultTitle: "Cafe Free Wi-Fi",
            defaultContent: "WIFI:T:WPA;S:Cafe_Lounge;P:FreshCoffee99;;",
            previewGradientHex: ["B45309", "D97706", "F59E0B"]
        ),
        QRTemplate(
            id: "wifi_5g",
            name: "5G Ultra Speed",
            category: .wifi,
            badgeText: "5G ULTRA",
            badgePosition: .ribbon,
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi
            ),
            defaultTitle: "5G High Speed",
            defaultContent: "WIFI:T:WPA;S:Ultra_5G_Node;P:SpeedMax2026;;",
            previewGradientHex: ["7C3AED", "C026D3"]
        ),
        QRTemplate(
            id: "wifi_guest",
            name: "Guest Access Pass",
            category: .wifi,
            badgeText: "GUEST PASS",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "F0FDF4",
                logoType: .wifi
            ),
            defaultTitle: "Guest Network",
            defaultContent: "WIFI:T:WPA;S:Welcome_Guest;P:Welcome2026;;",
            previewGradientHex: ["059669", "10B981"]
        ),
        QRTemplate(
            id: "wifi_hotel",
            name: "Grand Hotel & Resort",
            category: .wifi,
            badgeText: "HOTEL VIP",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFBEB",
                logoType: .wifi
            ),
            defaultTitle: "Resort Wi-Fi",
            defaultContent: "WIFI:T:WPA;S:Grand_Hotel_VIP;P:RoomKeyAccess;;",
            previewGradientHex: ["D97706", "78350F"],
            accentColorHex: "F59E0B"
        ),
        QRTemplate(
            id: "wifi_airport",
            name: "Airport Sky Port",
            category: .wifi,
            badgeText: "✈ AIRPORT",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi
            ),
            defaultTitle: "Airport Wi-Fi",
            defaultContent: "WIFI:T:WPA;S:Terminal_Free_WiFi;P:FlySafe2026;;",
            previewGradientHex: ["0284C7", "0369A1"]
        ),
        QRTemplate(
            id: "wifi_gaming",
            name: "Low-Ping Gaming",
            category: .wifi,
            badgeText: "ZERO PING",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .midnightDark,
                backgroundColorHex: "0A0A0A",
                logoType: .wifi
            ),
            defaultTitle: "Gaming Wi-Fi",
            defaultContent: "WIFI:T:WPA;S:Fiber_Gaming_5GHz;P:FragMaster99;;",
            previewGradientHex: ["10B981", "047857", "000000"],
            accentColorHex: "10B981"
        ),
        QRTemplate(
            id: "wifi_secure",
            name: "Shield Cyber Safe",
            category: .wifi,
            badgeText: "SECURE",
            badgePosition: .centerLogo,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .shield
            ),
            defaultTitle: "Secure Corporate",
            defaultContent: "WIFI:T:WPA;S:Encrypted_WPA3;P:VaultPass2026;;",
            previewGradientHex: ["6366F1", "4F46E5"]
        ),
        QRTemplate(
            id: "wifi_fiber",
            name: "Gigabit Fiber",
            category: .wifi,
            badgeText: "1000 Mbps",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi
            ),
            defaultTitle: "Fiber Gigabit",
            defaultContent: "WIFI:T:WPA;S:Fiber_Gigabit_Optic;P:OpticFiberPass;;",
            previewGradientHex: ["06B6D4", "0284C7"]
        ),
        QRTemplate(
            id: "wifi_public",
            name: "Public City Wi-Fi",
            category: .wifi,
            badgeText: "FREE CITY",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi
            ),
            defaultTitle: "Public Network",
            defaultContent: "WIFI:T:nopass;S:City_Free_WiFi;P:;;",
            previewGradientHex: ["F97316", "EA580C"]
        ),
        
        // ==========================================
        // 3. BUSINESS CATEGORY (11 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "black_friday",
            name: "Black Friday %",
            category: .business,
            badgeText: "Black Friday %",
            badgePosition: .bannerLeft,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                frameStyle: .cardBorder
            ),
            defaultTitle: "Black Friday Sale",
            defaultContent: "https://myshop.com/blackfriday",
            previewGradientHex: ["1F2937", "111827"],
            accentColorHex: "FBBF24"
        ),
        QRTemplate(
            id: "sale",
            name: "Flash SALE",
            category: .business,
            badgeText: "SALE",
            badgePosition: .badgeBottom,
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
            id: "business_vcard",
            name: "Executive vCard",
            category: .business,
            badgeText: "VCARD",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .midnightDark,
                backgroundColorHex: "FFFFFF",
                logoType: .link
            ),
            defaultTitle: "Business Card",
            defaultContent: "BEGIN:VCARD\nVERSION:3.0\nN:Smith;Alex;;;\nFN:Alex Smith\nORG:Apex Group\nTITLE:CEO\nTEL:+15550199\nEND:VCARD",
            previewGradientHex: ["312E81", "1E1B4B"]
        ),
        QRTemplate(
            id: "business_menu",
            name: "Gourmet Restaurant Menu",
            category: .business,
            badgeText: "🍴 MENU",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFBEB",
                logoType: .none
            ),
            defaultTitle: "Dining Menu",
            defaultContent: "https://bistromenu.com/today",
            previewGradientHex: ["78350F", "92400E", "B45309"],
            accentColorHex: "FDE68A"
        ),
        QRTemplate(
            id: "business_realestate",
            name: "Luxury Real Estate",
            category: .business,
            badgeText: "FOR SALE",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultTitle: "Property Tour",
            defaultContent: "https://luxuryestates.com/villa108",
            previewGradientHex: ["064E3B", "047857"]
        ),
        QRTemplate(
            id: "business_payment",
            name: "Quick Pay Terminal",
            category: .business,
            badgeText: "💳 PAY HERE",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultTitle: "Payment Portal",
            defaultContent: "https://pay.stripe.com/invoice_qrshield",
            previewGradientHex: ["6366F1", "4338CA"]
        ),
        QRTemplate(
            id: "business_discount",
            name: "50% Discount Coupon",
            category: .business,
            badgeText: "50% OFF",
            badgePosition: .ribbon,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultTitle: "VIP Voucher",
            defaultContent: "https://myshop.com/coupon/save50",
            previewGradientHex: ["EA580C", "C2410C"]
        ),
        QRTemplate(
            id: "business_startup",
            name: "Tech Startup",
            category: .business,
            badgeText: "LAUNCH",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .royalPurple,
                backgroundColorHex: "FFFFFF",
                logoType: .star
            ),
            defaultTitle: "Product Launch",
            defaultContent: "https://unicornapp.io/demo",
            previewGradientHex: ["8B5CF6", "6D28D9"]
        ),
        QRTemplate(
            id: "business_medical",
            name: "Medical Clinic",
            category: .business,
            badgeText: "HEALTH",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "F0FDFA",
                logoType: .shield
            ),
            defaultTitle: "Patient Portal",
            defaultContent: "https://medclinic.health/portal",
            previewGradientHex: ["0D9488", "0F766E"]
        ),
        QRTemplate(
            id: "business_review",
            name: "Customer Review ⭐",
            category: .business,
            badgeText: "★ RATE US ★",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .star
            ),
            defaultTitle: "Google Reviews",
            defaultContent: "https://g.page/r/qrshield/review",
            previewGradientHex: ["F59E0B", "D97706"]
        ),
        QRTemplate(
            id: "business_boutique",
            name: "Retail Boutique",
            category: .business,
            badgeText: "NEW IN",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFF1F2",
                logoType: .none
            ),
            defaultTitle: "Lookbook Collection",
            defaultContent: "https://boutiquestyle.com/new",
            previewGradientHex: ["E11D48", "BE123C"]
        ),
        
        // ==========================================
        // 4. EVENT CATEGORY (11 TEMPLATES)
        // ==========================================
        QRTemplate(
            id: "hearts",
            name: "Valentine Love",
            category: .event,
            badgeText: "♥ LOVE",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFF1F2",
                logoType: .heart
            ),
            defaultTitle: "Special Surprise",
            defaultContent: "https://qrshield.app/love",
            previewGradientHex: ["F43F5E", "FB7185"]
        ),
        QRTemplate(
            id: "waves",
            name: "Ocean Music Festival",
            category: .event,
            badgeText: "BEACH FEST",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .oceanBlue,
                backgroundColorHex: "F0F9FF",
                logoType: .shield,
                frameStyle: .neonGlow
            ),
            defaultTitle: "Beach Festival",
            defaultContent: "https://beachfestival.com/lineup",
            previewGradientHex: ["0EA5E9", "2563EB"]
        ),
        QRTemplate(
            id: "event_vip_pass",
            name: "VIP Access Pass",
            category: .event,
            badgeText: "★ VIP PASS ★",
            badgePosition: .ribbon,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "18181B",
                logoType: .none
            ),
            defaultTitle: "VIP Entry Ticket",
            defaultContent: "https://events.ticket.io/vip/8839",
            previewGradientHex: ["27272A", "09090B"],
            accentColorHex: "FBBF24"
        ),
        QRTemplate(
            id: "event_wedding",
            name: "Wedding Invitation",
            category: .event,
            badgeText: "RSVP",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFF5F5",
                logoType: .heart
            ),
            defaultTitle: "Wedding RSVP",
            defaultContent: "https://ourweddingday.info/rsvp",
            previewGradientHex: ["FB7185", "E11D48"]
        ),
        QRTemplate(
            id: "event_tech_conf",
            name: "DevCon Summit 2026",
            category: .event,
            badgeText: "</DEVCON>",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .royalPurple,
                backgroundColorHex: "0F172A",
                logoType: .none
            ),
            defaultTitle: "Conference Schedule",
            defaultContent: "https://devcon2026.tech/schedule",
            previewGradientHex: ["38BDF8", "818CF8", "C084FC"],
            accentColorHex: "38BDF8"
        ),
        QRTemplate(
            id: "event_birthday",
            name: "Birthday Party Bash",
            category: .event,
            badgeText: "PARTY! 🎂",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .star
            ),
            defaultTitle: "Party Location & Time",
            defaultContent: "https://partyinvitation.app/alex25",
            previewGradientHex: ["F59E0B", "EC4899"]
        ),
        QRTemplate(
            id: "event_concert",
            name: "Live Concert Tour",
            category: .event,
            badgeText: "LIVE STAGE",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .royalPurple,
                backgroundColorHex: "111827",
                logoType: .none
            ),
            defaultTitle: "Concert Tickets",
            defaultContent: "https://soundlive.fm/tour2026",
            previewGradientHex: ["8B5CF6", "EC4899", "3B82F6"]
        ),
        QRTemplate(
            id: "event_cinema",
            name: "Movie Gala Premiere",
            category: .event,
            badgeText: "PREMIERE",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .youtubeRed,
                backgroundColorHex: "000000",
                logoType: .none
            ),
            defaultTitle: "Cinema Screening",
            defaultContent: "https://cinemaplex.com/premiere/pass",
            previewGradientHex: ["991B1B", "1F2937"]
        ),
        QRTemplate(
            id: "event_marathon",
            name: "City Marathon 42K",
            category: .event,
            badgeText: "42K RUN",
            badgePosition: .badgeBottom,
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultTitle: "Runner Tracking",
            defaultContent: "https://citymarathon.run/bib/509",
            previewGradientHex: ["EAB308", "EF4444"]
        ),
        QRTemplate(
            id: "event_art_gallery",
            name: "Modern Art Exhibition",
            category: .event,
            badgeText: "GALLERY",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none
            ),
            defaultTitle: "Exhibition Guide",
            defaultContent: "https://artgallery.org/exhibit",
            previewGradientHex: ["4B5563", "111827"]
        ),
        QRTemplate(
            id: "event_new_year",
            name: "New Year Eve 2027",
            category: .event,
            badgeText: "COUNTDOWN",
            badgePosition: .badgeTop,
            styleConfig: QRStyleConfig(
                dotStyle: .diamond,
                colorTheme: .royalPurple,
                backgroundColorHex: "09090B",
                logoType: .star
            ),
            defaultTitle: "NYE Celebration",
            defaultContent: "https://nye-gala.event/tickets",
            previewGradientHex: ["F59E0B", "7C3AED"],
            accentColorHex: "FBBF24"
        )
    ]
}
