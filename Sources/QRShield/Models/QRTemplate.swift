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
    public let categoryIcon: String
    public let categoryLabel: String
    public let footerText: String
    public let gradientHexColors: [String]
    public let gradientStops: [Double]?
    public let accentColorHex: String
    public let isPro: Bool
    public let subCategory: String?
    public let styleConfig: QRStyleConfig
    public let defaultContent: String
    
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
            id: "pop_scanme_black",
            name: "Classic Scan Me",
            category: .popular,
            title: "Classic Scan Me",
            subtitle: "HIGH-CONTRAST PILL",
            categoryIcon: "qrcode",
            categoryLabel: "POPULAR",
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
                decorativeFrame: .scanMeBottom,
                bannerText: "SCAN ME"
            ),
            defaultContent: "https://qrshield.app/start"
        ),
        QRTemplate(
            id: "pop_ig_sunset",
            name: "Instagram Sunset",
            category: .popular,
            title: "Instagram",
            subtitle: "FOLLOW US",
            categoryIcon: "camera.fill",
            categoryLabel: "POPULAR",
            footerText: "FOLLOW US",
            gradientHexColors: ["F58529", "DD2A7B", "8134AF"],
            gradientStops: nil,
            accentColorHex: "DD2A7B",
            isPro: false,
            subCategory: "Social",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .instagram,
                eyeStyle: .rounded,
                decorativeFrame: .instagramCard,
                bannerText: "FOLLOW US"
            ),
            defaultContent: "https://instagram.com/qrshield"
        ),
        QRTemplate(
            id: "pop_fb_blue",
            name: "Facebook Blue",
            category: .popular,
            title: "Facebook Official",
            subtitle: "LIKE & FOLLOW",
            categoryIcon: "hand.thumbsup.fill",
            categoryLabel: "POPULAR",
            footerText: "FOLLOW US ON",
            gradientHexColors: ["1877F2", "0D65D9"],
            gradientStops: nil,
            accentColorHex: "1877F2",
            isPro: false,
            subCategory: "Social",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .facebook,
                eyeStyle: .rounded,
                decorativeFrame: .facebookCard,
                bannerText: "FOLLOW US ON"
            ),
            defaultContent: "https://facebook.com/qrshield"
        ),
        QRTemplate(
            id: "pop_wifi_hub",
            name: "Wi-Fi Connect Hub",
            category: .popular,
            title: "Wi-Fi Network",
            subtitle: "SCAN TO CONNECT",
            categoryIcon: "wifi",
            categoryLabel: "POPULAR",
            footerText: "CONNECT",
            gradientHexColors: ["0284C7", "0369A1"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: false,
            subCategory: "Wi-Fi",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .wifi,
                eyeStyle: .rounded,
                decorativeFrame: .wifiCard,
                bannerText: "SCAN TO CONNECT"
            ),
            defaultContent: "WIFI:S:Home_Gigabit_5G;T:WPA;P:SuperSecretPass2026;;"
        ),
        QRTemplate(
            id: "pop_google_review",
            name: "Google 5-Star Review",
            category: .popular,
            title: "Review Us",
            subtitle: "5-STAR FEEDBACK",
            categoryIcon: "star.fill",
            categoryLabel: "POPULAR",
            footerText: "REVIEW US",
            gradientHexColors: ["4285F4", "34A853"],
            gradientStops: nil,
            accentColorHex: "4285F4",
            isPro: false,
            subCategory: "Business",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .rounded,
                decorativeFrame: .googleReview,
                bannerText: "REVIEW US ON GOOGLE"
            ),
            defaultContent: "https://g.page/r/your-google-place-id/review"
        ),
        QRTemplate(
            id: "pop_love_hearts",
            name: "Double Hearts",
            category: .popular,
            title: "Sweetheart Note",
            subtitle: "ROMANTIC SURPRISE",
            categoryIcon: "heart.fill",
            categoryLabel: "POPULAR",
            footerText: "I LOVE YOU",
            gradientHexColors: ["E11D48", "BE123C"],
            gradientStops: nil,
            accentColorHex: "E11D48",
            isPro: true,
            subCategory: "Occasion",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .rounded,
                decorativeFrame: .loveHearts,
                bannerText: "I LOVE YOU"
            ),
            defaultContent: "https://hearts.love/special-note"
        ),
        QRTemplate(
            id: "pop_sticky_note",
            name: "Yellow Sticky Note",
            category: .popular,
            title: "Post-It Note",
            subtitle: "WITH SCOTCH TAPE",
            categoryIcon: "note.text",
            categoryLabel: "POPULAR",
            footerText: "SCAN ME",
            gradientHexColors: ["FDE047", "FACC15"],
            gradientStops: nil,
            accentColorHex: "FDE047",
            isPro: true,
            subCategory: "Creative",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .stickyNote,
                bannerText: "SCAN ME"
            ),
            defaultContent: "https://stickynote.io/memo-402"
        ),
        QRTemplate(
            id: "pop_cafe_mug",
            name: "Coffee Mug Menu",
            category: .popular,
            title: "Café Drink Menu",
            subtitle: "ORDER FROM TABLE",
            categoryIcon: "cup.and.saucer.fill",
            categoryLabel: "POPULAR",
            footerText: "SCAN ME",
            gradientHexColors: ["1C1917", "78350F"],
            gradientStops: nil,
            accentColorHex: "78350F",
            isPro: false,
            subCategory: "Business",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .coffeeMug,
                bannerText: "SCAN ME"
            ),
            defaultContent: "https://artisancafe.com/menu"
        ),
        QRTemplate(
            id: "pop_birthday_bash",
            name: "Birthday Party Bash",
            category: .popular,
            title: "Happy Birthday",
            subtitle: "BALLOONS & CAKE",
            categoryIcon: "party.popper.fill",
            categoryLabel: "POPULAR",
            footerText: "INVITATION",
            gradientHexColors: ["0284C7", "38BDF8"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: true,
            subCategory: "Occasion",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .circular,
                decorativeFrame: .birthdayParty,
                bannerText: "YOU'RE INVITED"
            ),
            defaultContent: "https://partyhub.live/invite/leo30"
        ),
        QRTemplate(
            id: "biz_menu_mug",
            name: "Café Coffee Mug",
            category: .business,
            title: "Artisan Coffee",
            subtitle: "DRINKS & PASTRIES",
            categoryIcon: "cup.and.saucer.fill",
            categoryLabel: "BUSINESS",
            footerText: "VIEW MENU",
            gradientHexColors: ["78350F", "92400E"],
            gradientStops: nil,
            accentColorHex: "78350F",
            isPro: false,
            subCategory: "Menu",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .coffeeMug,
                bannerText: "CAFE MENU"
            ),
            defaultContent: "https://artisancafe.com/menu"
        ),
        QRTemplate(
            id: "biz_menu_fries",
            name: "French Fries Box",
            category: .business,
            title: "Fast Food Combo",
            subtitle: "BURGERS & FRIES",
            categoryIcon: "fork.knife",
            categoryLabel: "BUSINESS",
            footerText: "ORDER NOW",
            gradientHexColors: ["EF4444", "DC2626"],
            gradientStops: nil,
            accentColorHex: "EF4444",
            isPro: false,
            subCategory: "Menu",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .frenchFries,
                bannerText: "ORDER FOOD"
            ),
            defaultContent: "https://burgershop.com/combo"
        ),
        QRTemplate(
            id: "biz_menu_popcorn",
            name: "Popcorn Carton",
            category: .business,
            title: "Movie Concessions",
            subtitle: "SNACKS & DRINKS",
            categoryIcon: "film.fill",
            categoryLabel: "BUSINESS",
            footerText: "SNACKS",
            gradientHexColors: ["DC2626", "B91C1C"],
            gradientStops: nil,
            accentColorHex: "DC2626",
            isPro: true,
            subCategory: "Menu",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .popcornBox,
                bannerText: "CONCESSIONS"
            ),
            defaultContent: "https://cinemafood.com/snacks"
        ),
        QRTemplate(
            id: "biz_menu_icecream",
            name: "Ice Cream Sundae",
            category: .business,
            title: "Sweet Desserts",
            subtitle: "GELATO & SUNDAES",
            categoryIcon: "heart.fill",
            categoryLabel: "BUSINESS",
            footerText: "FLAVORS",
            gradientHexColors: ["F472B6", "FB7185"],
            gradientStops: nil,
            accentColorHex: "F472B6",
            isPro: true,
            subCategory: "Menu",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .circular,
                decorativeFrame: .iceCream,
                bannerText: "SWEET MENU"
            ),
            defaultContent: "https://sweetcream.cafe/flavors"
        ),
        QRTemplate(
            id: "biz_menu_bistro",
            name: "Bistro Dining Menu",
            category: .business,
            title: "Chef's Menu",
            subtitle: "TABLE SERVICE QR",
            categoryIcon: "fork.knife",
            categoryLabel: "BUSINESS",
            footerText: "VIEW MENU",
            gradientHexColors: ["D97706", "B45309"],
            gradientStops: nil,
            accentColorHex: "D97706",
            isPro: false,
            subCategory: "Menu",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .leaf,
                decorativeFrame: .topBanner,
                bannerText: "DIGITAL MENU"
            ),
            defaultContent: "https://bistromoderne.com/menu"
        ),
        QRTemplate(
            id: "biz_store_gift",
            name: "Gift Present Box",
            category: .business,
            title: "Boutique Gift",
            subtitle: "EXCLUSIVE COLLECTION",
            categoryIcon: "gift.fill",
            categoryLabel: "BUSINESS",
            footerText: "SHOP GIFTS",
            gradientHexColors: ["0D9488", "14B8A6"],
            gradientStops: nil,
            accentColorHex: "0D9488",
            isPro: true,
            subCategory: "Store",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .rounded,
                decorativeFrame: .giftBox,
                bannerText: "SPECIAL GIFT"
            ),
            defaultContent: "https://giftboutique.co/products"
        ),
        QRTemplate(
            id: "biz_store_retail",
            name: "Store Catalog",
            category: .business,
            title: "Product Catalog",
            subtitle: "NEW SEASON ARRIVALS",
            categoryIcon: "bag.fill",
            categoryLabel: "BUSINESS",
            footerText: "SHOP NOW",
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
                decorativeFrame: .roundedBorderBanner,
                bannerText: "SHOP CATALOG"
            ),
            defaultContent: "https://retailshop.store/catalog"
        ),
        QRTemplate(
            id: "biz_crypto_btc",
            name: "Bitcoin Wallet",
            category: .business,
            title: "Crypto Payment",
            subtitle: "BITCOIN WALLET ADDRESS",
            categoryIcon: "bitcoinsign.circle.fill",
            categoryLabel: "BUSINESS",
            footerText: "PAY WITH BTC",
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
                decorativeFrame: .viewfinder,
                bannerText: "CRYPTO PAY"
            ),
            defaultContent: "bitcoin:1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa?amount=0.005"
        ),
        QRTemplate(
            id: "biz_crypto_eth",
            name: "Ethereum Smart Pay",
            category: .business,
            title: "Ethereum Network",
            subtitle: "WEB3 TRANSFER",
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
                decorativeFrame: .neonGlow,
                bannerText: "ETH TRANSFER"
            ),
            defaultContent: "ethereum:0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe"
        ),
        QRTemplate(
            id: "biz_coupon_deal",
            name: "Flash Coupon 20%",
            category: .business,
            title: "Discount Voucher",
            subtitle: "CLAIM 20% OFF TODAY",
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
                decorativeFrame: .ticketCoupon,
                bannerText: "20% OFF · CLAIM"
            ),
            defaultContent: "https://deals.shop/promo/SAVE20"
        ),
        QRTemplate(
            id: "biz_voucher_vip",
            name: "VIP Voucher Pass",
            category: .business,
            title: "Member Rebate",
            subtitle: "SPECIAL REWARD VOUCHER",
            categoryIcon: "seal.fill",
            categoryLabel: "BUSINESS",
            footerText: "VERIFY PASS",
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
                decorativeFrame: .ticketCoupon,
                bannerText: "$10 REBATE · REDEEM"
            ),
            defaultContent: "https://rewards.club/voucher/vip882"
        ),
        QRTemplate(
            id: "biz_pay_instant",
            name: "Instant Contactless Pay",
            category: .business,
            title: "Contactless Pay",
            subtitle: "FAST & SECURE CHECKOUT",
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
                eyeStyle: .rounded,
                decorativeFrame: .scanMeBottom,
                bannerText: "SCAN TO PAY"
            ),
            defaultContent: "https://pay.stripe.com/qr/instant-992"
        ),
        QRTemplate(
            id: "biz_pay_checkout",
            name: "Express Checkout",
            category: .business,
            title: "Express Pay",
            subtitle: "TAP & FINISH ORDER",
            categoryIcon: "dollarsign.circle.fill",
            categoryLabel: "BUSINESS",
            footerText: "COMPLETE ORDER",
            gradientHexColors: ["059669", "047857"],
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
                decorativeFrame: .roundedBorderBanner,
                bannerText: "PAY ORDER"
            ),
            defaultContent: "https://checkout.apex.io/pay/order-401"
        ),
        QRTemplate(
            id: "biz_google_review_card",
            name: "Google 5-Star Feedback",
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
                decorativeFrame: .googleReview,
                bannerText: "REVIEW US ON GOOGLE"
            ),
            defaultContent: "https://g.page/r/your-google-place-id/review"
        ),
        QRTemplate(
            id: "biz_exec_card",
            name: "Corporate Executive",
            category: .business,
            title: "Digital vCard",
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
                decorativeFrame: .viewfinder,
                bannerText: "EXECUTIVE VCARD"
            ),
            defaultContent: "BEGIN:VCARD\\nVERSION:3.0\\nFN:Alex Vance\\nORG:Apex Tech\\nTITLE:CEO\\nTEL:+15550192831\\nEMAIL:alex@apextech.com\\nEND:VCARD"
        ),
        QRTemplate(
            id: "soc_ig_sunset",
            name: "Instagram Sunset",
            category: .socialMedia,
            title: "Instagram",
            subtitle: "FOLLOW OUR PROFILE",
            categoryIcon: "camera.fill",
            categoryLabel: "SOCIAL",
            footerText: "FOLLOW US",
            gradientHexColors: ["F58529", "DD2A7B", "8134AF"],
            gradientStops: nil,
            accentColorHex: "DD2A7B",
            isPro: false,
            subCategory: "Instagram",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .instagramSunset,
                backgroundColorHex: "FFFFFF",
                logoType: .instagram,
                eyeStyle: .rounded,
                decorativeFrame: .instagramCard,
                bannerText: "FOLLOW US"
            ),
            defaultContent: "https://instagram.com/qrshield"
        ),
        QRTemplate(
            id: "soc_ig_story",
            name: "Insta Story Frame",
            category: .socialMedia,
            title: "Instagram Story",
            subtitle: "DAILY REELS & POSTS",
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
                decorativeFrame: .roundedBorderBanner,
                bannerText: "INSTAGRAM"
            ),
            defaultContent: "https://instagram.com/qrshield"
        ),
        QRTemplate(
            id: "soc_fb_official",
            name: "Facebook Official",
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
                decorativeFrame: .facebookCard,
                bannerText: "FOLLOW US ON"
            ),
            defaultContent: "https://facebook.com/qrshield"
        ),
        QRTemplate(
            id: "soc_fb_pill",
            name: "Facebook Blue Pill",
            category: .socialMedia,
            title: "Facebook Community",
            subtitle: "JOIN CONVERSATION",
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
                decorativeFrame: .scanMeBottom,
                bannerText: "LIKE ON FACEBOOK"
            ),
            defaultContent: "https://facebook.com/qrshield"
        ),
        QRTemplate(
            id: "soc_yt_channel",
            name: "YouTube Subscribe",
            category: .socialMedia,
            title: "YouTube Channel",
            subtitle: "NEW VIDEOS WEEKLY",
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
                decorativeFrame: .youtubeCard,
                bannerText: "SUBSCRIBE"
            ),
            defaultContent: "https://youtube.com/@qrshield"
        ),
        QRTemplate(
            id: "soc_yt_watch",
            name: "YouTube Watch Now",
            category: .socialMedia,
            title: "YouTube Video",
            subtitle: "WATCH FULL EPISODE",
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
                decorativeFrame: .scanMeBottom,
                bannerText: "WATCH NOW"
            ),
            defaultContent: "https://youtube.com/@qrshield"
        ),
        QRTemplate(
            id: "soc_wa_chat",
            name: "WhatsApp Chat Bubble",
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
                decorativeFrame: .chatBubble,
                bannerText: "CHAT WITH US"
            ),
            defaultContent: "https://wa.me/15551234567"
        ),
        QRTemplate(
            id: "soc_wa_pill",
            name: "WhatsApp Green Pill",
            category: .socialMedia,
            title: "WhatsApp Helpline",
            subtitle: "24/7 CUSTOMER SUPPORT",
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
                decorativeFrame: .scanMeBottom,
                bannerText: "MESSAGE US"
            ),
            defaultContent: "https://wa.me/15551234567"
        ),
        QRTemplate(
            id: "soc_li_connect",
            name: "LinkedIn Connect",
            category: .socialMedia,
            title: "LinkedIn Profile",
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
                decorativeFrame: .linkedInCard,
                bannerText: "CONNECT"
            ),
            defaultContent: "https://linkedin.com/in/qrshield"
        ),
        QRTemplate(
            id: "soc_tt_cyber",
            name: "TikTok Neon Cyber",
            category: .socialMedia,
            title: "TikTok Creator",
            subtitle: "VIRAL SHORT VIDEOS",
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
                decorativeFrame: .neonGlow,
                bannerText: "WATCH ON TIKTOK"
            ),
            defaultContent: "https://tiktok.com/@qrshield"
        ),
        QRTemplate(
            id: "soc_x_viewfinder",
            name: "X Minimal Focus",
            category: .socialMedia,
            title: "X Profile",
            subtitle: "REAL-TIME POSTS",
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
                decorativeFrame: .viewfinder,
                bannerText: "FOLLOW @US"
            ),
            defaultContent: "https://x.com/qrshield"
        ),
        QRTemplate(
            id: "soc_sp_stream",
            name: "Spotify Stream",
            category: .socialMedia,
            title: "Spotify Playlist",
            subtitle: "LISTEN IN HIGH-FIDELITY",
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
                decorativeFrame: .roundedBorderBanner,
                bannerText: "LISTEN ON SPOTIFY"
            ),
            defaultContent: "https://open.spotify.com/artist/qrshield"
        ),
        QRTemplate(
            id: "wifi_home_hub",
            name: "Home Wi-Fi Network",
            category: .wifi,
            title: "Home Wi-Fi",
            subtitle: "AUTO-CONNECT WPA3",
            categoryIcon: "wifi",
            categoryLabel: "WI-FI",
            footerText: "CONNECT",
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
                decorativeFrame: .wifiCard,
                bannerText: "SCAN TO CONNECT"
            ),
            defaultContent: "WIFI:S:Home_Gigabit_5G;T:WPA;P:SuperSecretPass2026;;"
        ),
        QRTemplate(
            id: "wifi_cafe_guest",
            name: "Café Guest Wi-Fi",
            category: .wifi,
            title: "Coffee Shop Wi-Fi",
            subtitle: "FREE BROADBAND",
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
                decorativeFrame: .wifiCard,
                bannerText: "FREE CAFE ACCESS"
            ),
            defaultContent: "WIFI:S:ArtisanCoffee_Guest;T:WPA;P:coffee2026;;"
        ),
        QRTemplate(
            id: "wifi_office_viewfinder",
            name: "Office Secured",
            category: .wifi,
            title: "Enterprise Network",
            subtitle: "CORPORATE CREDENTIALS",
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
                decorativeFrame: .viewfinder,
                bannerText: "SECURED WI-FI"
            ),
            defaultContent: "WIFI:S:ApexHQ_Corp;T:WPA;P:enterprisePass2026;;"
        ),
        QRTemplate(
            id: "wifi_fiber_cyber",
            name: "Cyberpunk Fiber 10G",
            category: .wifi,
            title: "Gigabit Fiber",
            subtitle: "LOW LATENCY STREAMING",
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
                decorativeFrame: .neonGlow,
                bannerText: "10G FIBER SPEED"
            ),
            defaultContent: "WIFI:S:QuantumFiber_10G;T:WPA;P:photonWave99;;"
        ),
        QRTemplate(
            id: "wifi_quick_pill",
            name: "Instant Wi-Fi Pill",
            category: .wifi,
            title: "Instant Join",
            subtitle: "ZERO CONFIGURATION",
            categoryIcon: "wifi",
            categoryLabel: "WI-FI",
            footerText: "SCAN TO JOIN",
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
                decorativeFrame: .scanMeBottom,
                bannerText: "SCAN TO JOIN WI-FI"
            ),
            defaultContent: "WIFI:S:Guest_FastWiFi;T:WPA;P:guestAccess888;;"
        ),
        QRTemplate(
            id: "ev_wedding_romance",
            name: "Romantic Wedding Invite",
            category: .event,
            title: "Save Our Date",
            subtitle: "JOIN OUR SPECIAL DAY",
            categoryIcon: "heart.fill",
            categoryLabel: "EVENT",
            footerText: "CELEBRATE",
            gradientHexColors: ["E11D48", "BE123C"],
            gradientStops: nil,
            accentColorHex: "E11D48",
            isPro: true,
            subCategory: "Wedding",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .rounded,
                decorativeFrame: .loveHearts,
                bannerText: "SAVE OUR DATE"
            ),
            defaultContent: "https://sarah-and-daniel.wedding"
        ),
        QRTemplate(
            id: "ev_birthday_bunting",
            name: "Birthday Party Bash",
            category: .event,
            title: "Birthday Party",
            subtitle: "YOU'RE INVITED",
            categoryIcon: "party.popper.fill",
            categoryLabel: "EVENT",
            footerText: "RSVP NOW",
            gradientHexColors: ["0284C7", "38BDF8"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: true,
            subCategory: "Birthday",
            styleConfig: QRStyleConfig(
                dotStyle: .circular,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .star,
                eyeStyle: .circular,
                decorativeFrame: .birthdayParty,
                bannerText: "YOU'RE INVITED"
            ),
            defaultContent: "https://partystream.live/invite/leo30"
        ),
        QRTemplate(
            id: "ev_floral_elegance",
            name: "Botanical Rose Wreath",
            category: .event,
            title: "Floral Celebration",
            subtitle: "GARDEN CEREMONY",
            categoryIcon: "sparkles",
            categoryLabel: "EVENT",
            footerText: "INVITATION",
            gradientHexColors: ["FB7185", "FDA4AF"],
            gradientStops: nil,
            accentColorHex: "FB7185",
            isPro: true,
            subCategory: "Wedding",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .leaf,
                decorativeFrame: .floralWreath,
                bannerText: "OUR WEDDING"
            ),
            defaultContent: "https://gardenwedding.events/ceremony"
        ),
        QRTemplate(
            id: "ev_concert_cyber",
            name: "Live Concert VIP",
            category: .event,
            title: "Live Music Tour",
            subtitle: "STAGE ACCESS PASS",
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
                decorativeFrame: .neonGlow,
                bannerText: "VIP CONCERT PASS"
            ),
            defaultContent: "https://livetour2026.com/ticket/gate-a"
        ),
        QRTemplate(
            id: "ev_party_banner",
            name: "Weekend Party Night",
            category: .event,
            title: "Weekend Social",
            subtitle: "COCKTAILS & DJ SET",
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
                decorativeFrame: .topBanner,
                bannerText: "JOIN THE PARTY"
            ),
            defaultContent: "https://partynight.club/event/saturday"
        ),
        QRTemplate(
            id: "ev_charity_present",
            name: "Charity Fundraiser",
            category: .event,
            title: "Hope Gala",
            subtitle: "DONATE & EMPOWER",
            categoryIcon: "gift.fill",
            categoryLabel: "EVENT",
            footerText: "DONATE NOW",
            gradientHexColors: ["059669", "10B981"],
            gradientStops: nil,
            accentColorHex: "059669",
            isPro: false,
            subCategory: "Gala",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .rounded,
                decorativeFrame: .giftBox,
                bannerText: "DONATE NOW"
            ),
            defaultContent: "https://hopefoundation.org/gala"
        ),
        QRTemplate(
            id: "clr_sticky_memo",
            name: "Canary Sticky Memo",
            category: .colorful,
            title: "Yellow Memo Note",
            subtitle: "WITH SCOTCH TAPE",
            categoryIcon: "note.text",
            categoryLabel: "COLORFUL",
            footerText: "SCAN ME",
            gradientHexColors: ["FDE047", "FACC15"],
            gradientStops: nil,
            accentColorHex: "FDE047",
            isPro: true,
            subCategory: "Creative",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .classicBlack,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .stickyNote,
                bannerText: "SCAN ME"
            ),
            defaultContent: "https://memos.quick/read-801"
        ),
        QRTemplate(
            id: "clr_scanme_bold",
            name: "Bold Scan Me Pill",
            category: .colorful,
            title: "Direct Link",
            subtitle: "BOLD PILL CALLOUT",
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
                decorativeFrame: .scanMeBottom,
                bannerText: "SCAN ME"
            ),
            defaultContent: "https://qrshield.app/start"
        ),
        QRTemplate(
            id: "clr_love_note",
            name: "Sweetheart Love Note",
            category: .colorful,
            title: "Love Card",
            subtitle: "WITH TWIN HEARTS",
            categoryIcon: "heart.fill",
            categoryLabel: "COLORFUL",
            footerText: "I LOVE YOU",
            gradientHexColors: ["E11D48", "BE123C"],
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
                decorativeFrame: .loveHearts,
                bannerText: "I LOVE YOU"
            ),
            defaultContent: "https://mypassion.love/secret-note"
        ),
        QRTemplate(
            id: "clr_floral_frame",
            name: "Pastel Floral Wreath",
            category: .colorful,
            title: "Rose Wreath",
            subtitle: "BOTANICAL CORNER EMBELLISHMENT",
            categoryIcon: "sparkles",
            categoryLabel: "COLORFUL",
            footerText: "DISCOVER",
            gradientHexColors: ["FB7185", "FDA4AF"],
            gradientStops: nil,
            accentColorHex: "FB7185",
            isPro: false,
            subCategory: "Artistic",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .sunsetOrange,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .leaf,
                decorativeFrame: .floralWreath,
                bannerText: "FOR YOU"
            ),
            defaultContent: "https://hearts.gift/love/note"
        ),
        QRTemplate(
            id: "clr_tech_focus",
            name: "Tech Focus Viewfinder",
            category: .colorful,
            title: "Viewfinder Focus",
            subtitle: "CLEAN CAMERA BRACKETS",
            categoryIcon: "viewfinder",
            categoryLabel: "COLORFUL",
            footerText: "SCAN ME",
            gradientHexColors: ["0284C7", "0369A1"],
            gradientStops: nil,
            accentColorHex: "0284C7",
            isPro: false,
            subCategory: "Minimal",
            styleConfig: QRStyleConfig(
                dotStyle: .square,
                colorTheme: .oceanBlue,
                backgroundColorHex: "FFFFFF",
                logoType: .none,
                eyeStyle: .square,
                decorativeFrame: .viewfinder,
                bannerText: "FOCUS & SCAN"
            ),
            defaultContent: "https://focuspoint.tech/camera"
        ),
        QRTemplate(
            id: "clr_coupon_ticket",
            name: "Coupon Ticket Stub",
            category: .colorful,
            title: "Tear-off Coupon",
            subtitle: "PERFORATED STAMP EDGES",
            categoryIcon: "tag.fill",
            categoryLabel: "COLORFUL",
            footerText: "CLAIM NOW",
            gradientHexColors: ["059669", "10B981"],
            gradientStops: nil,
            accentColorHex: "059669",
            isPro: false,
            subCategory: "Artistic",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .emeraldGreen,
                backgroundColorHex: "FFFFFF",
                logoType: .shield,
                eyeStyle: .rounded,
                decorativeFrame: .ticketCoupon,
                bannerText: "20% OFF · CLAIM"
            ),
            defaultContent: "https://coupons.discount/claim"
        ),
        QRTemplate(
            id: "clr_neon_cyber",
            name: "Electric Cyan Glow",
            category: .colorful,
            title: "Cyber Halo",
            subtitle: "DEEP MIDNIGHT GLOW",
            categoryIcon: "bolt.circle.fill",
            categoryLabel: "COLORFUL",
            footerText: "CYBER ACCESS",
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
                decorativeFrame: .neonGlow,
                bannerText: "CYBER ACCESS"
            ),
            defaultContent: "https://cyberaccess.network/sync"
        ),
        QRTemplate(
            id: "clr_gift_present",
            name: "Surprise Gift Bow",
            category: .colorful,
            title: "Gift Presentation",
            subtitle: "CRIMSON SATIN BOW",
            categoryIcon: "gift.fill",
            categoryLabel: "COLORFUL",
            footerText: "OPEN GIFT",
            gradientHexColors: ["E11D48", "BE123C"],
            gradientStops: nil,
            accentColorHex: "E11D48",
            isPro: true,
            subCategory: "Artistic",
            styleConfig: QRStyleConfig(
                dotStyle: .rounded,
                colorTheme: .youtubeRed,
                backgroundColorHex: "FFFFFF",
                logoType: .heart,
                eyeStyle: .rounded,
                decorativeFrame: .giftBox,
                bannerText: "SURPRISE GIFT"
            ),
            defaultContent: "https://surprise.gift/open"
        )
    ]

    // Curated high-engagement popular templates shown on Home screen
    static var popularTemplates: [QRTemplate] {
        let popularIds = ["pop_scanme_black", "pop_ig_sunset", "pop_fb_blue", "pop_wifi_hub", "pop_google_review", "pop_love_hearts", "pop_sticky_note", "pop_cafe_mug", "pop_birthday_bash"]
        let list = popularIds.compactMap { pid in
            predefinedTemplates.first(where: { $0.id == pid })
        }
        return list.isEmpty ? Array(predefinedTemplates.prefix(6)) : list
    }
}
