import SwiftUI

// MARK: - Generator Category & Item Models

public enum GeneratorCategory: String, CaseIterable, Identifiable {
    case qrCode = "QR Code"
    case business = "Business"
    case barcode = "Barcode"
    case social = "Social"
    
    public var id: String { rawValue }
}

public struct GeneratorItem: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let iconName: String
    public let category: GeneratorCategory
    public let isPro: Bool
    public let contentType: QRContentType
    public let placeholder: String
    public let prefix: String?
    
    public init(
        id: String,
        title: String,
        iconName: String,
        category: GeneratorCategory,
        isPro: Bool = false,
        contentType: QRContentType,
        placeholder: String = "",
        prefix: String? = nil
    ) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.category = category
        self.isPro = isPro
        self.contentType = contentType
        self.placeholder = placeholder
        self.prefix = prefix
    }
}

public enum GeneratorCatalog {
    public static let items: [GeneratorItem] = [
        // Category 1 — QR Code (9 Items — Free / Default Expanded)
        GeneratorItem(id: "url", title: "Web URL", iconName: "link", category: .qrCode, isPro: false, contentType: .website, placeholder: "https://example.com", prefix: "https://"),
        GeneratorItem(id: "contact", title: "Contact", iconName: "person.crop.circle", category: .qrCode, isPro: false, contentType: .contact, placeholder: "John Doe"),
        GeneratorItem(id: "wifi", title: "Wifi", iconName: "wifi", category: .qrCode, isPro: false, contentType: .wifi, placeholder: "My Home Wi-Fi"),
        GeneratorItem(id: "text", title: "Text", iconName: "doc.text", category: .qrCode, isPro: false, contentType: .text, placeholder: "Type your message or notes..."),
        GeneratorItem(id: "email", title: "Email", iconName: "envelope", category: .qrCode, isPro: false, contentType: .email, placeholder: "hello@example.com"),
        GeneratorItem(id: "sms", title: "SMS", iconName: "bubble.left", category: .qrCode, isPro: false, contentType: .phone, placeholder: "+1 (555) 000-0000"),
        GeneratorItem(id: "phone", title: "Phone", iconName: "phone", category: .qrCode, isPro: false, contentType: .phone, placeholder: "+1 (555) 000-0000"),
        GeneratorItem(id: "location", title: "Location", iconName: "mappin.and.ellipse", category: .qrCode, isPro: false, contentType: .location, placeholder: "San Francisco, CA"),
        GeneratorItem(id: "event", title: "Event", iconName: "calendar", category: .qrCode, isPro: false, contentType: .text, placeholder: "Tech Meetup 2026"),

        // Category 2 — Business (12 Items — Pro)
        GeneratorItem(id: "bitcoin", title: "Bitcoin", iconName: "bitcoinsign.circle", category: .business, isPro: true, contentType: .text, placeholder: "Bitcoin wallet address", prefix: "bitcoin:"),
        GeneratorItem(id: "ethereum", title: "Ethereum", iconName: "rhombus.fill", category: .business, isPro: true, contentType: .text, placeholder: "0x... Ethereum address", prefix: "ethereum:"),
        GeneratorItem(id: "paypal", title: "PayPal", iconName: "wallet.pass", category: .business, isPro: true, contentType: .website, placeholder: "username", prefix: "https://paypal.me/"),
        GeneratorItem(id: "venmo", title: "Venmo", iconName: "arrow.left.arrow.right", category: .business, isPro: true, contentType: .website, placeholder: "username", prefix: "https://venmo.com/"),
        GeneratorItem(id: "cashapp", title: "Cash App", iconName: "dollarsign.square", category: .business, isPro: true, contentType: .website, placeholder: "cashtag", prefix: "https://cash.app/$"),
        GeneratorItem(id: "stripe", title: "Stripe", iconName: "creditcard", category: .business, isPro: true, contentType: .website, placeholder: "buy.stripe.com/...", prefix: "https://"),
        GeneratorItem(id: "appstore", title: "App Store", iconName: "arrow.down.app", category: .business, isPro: true, contentType: .website, placeholder: "apps.apple.com/app/...", prefix: "https://apps.apple.com/"),
        GeneratorItem(id: "appstorereviews", title: "App Store reviews", iconName: "star.square", category: .business, isPro: true, contentType: .website, placeholder: "App review URL or ID", prefix: "https://"),
        GeneratorItem(id: "googlemaps", title: "Google Maps", iconName: "map", category: .business, isPro: true, contentType: .website, placeholder: "maps.google.com/...", prefix: "https://maps.google.com/"),
        GeneratorItem(id: "googleplacereviews", title: "Google Place reviews", iconName: "mappin.and.ellipse", category: .business, isPro: true, contentType: .website, placeholder: "Google Place review link", prefix: "https://"),
        GeneratorItem(id: "zoom", title: "Zoom", iconName: "video", category: .business, isPro: true, contentType: .website, placeholder: "zoom.us/j/...", prefix: "https://zoom.us/j/"),
        GeneratorItem(id: "googlemeet", title: "Google Meet", iconName: "person.3.sequence", category: .business, isPro: true, contentType: .website, placeholder: "meet.google.com/...", prefix: "https://meet.google.com/"),

        // Category 3 — Barcode (15 Items — Pro)
        GeneratorItem(id: "ean13", title: "EAN-13", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "13-digit barcode (e.g. 5901234123457)"),
        GeneratorItem(id: "ean8", title: "EAN-8", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "8-digit barcode (e.g. 96385074)"),
        GeneratorItem(id: "upca", title: "UPC-A", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "12-digit UPC (e.g. 012345678905)"),
        GeneratorItem(id: "upce", title: "UPC-E", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "8-digit UPC (e.g. 01234565)"),
        GeneratorItem(id: "code128", title: "Code 128", iconName: "barcode.viewfinder", category: .barcode, isPro: true, contentType: .text, placeholder: "Code 128 alphanumeric data"),
        GeneratorItem(id: "code39", title: "Code 39", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "CODE39 alphanumeric text"),
        GeneratorItem(id: "code93", title: "Code 93", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "Code 93 encoded data"),
        GeneratorItem(id: "itf14", title: "ITF-14", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "14-digit ITF shipping barcode"),
        GeneratorItem(id: "interleaved2of5", title: "Interleaved 2 of 5", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "Numeric digits"),
        GeneratorItem(id: "codabar", title: "Codabar", iconName: "barcode", category: .barcode, isPro: true, contentType: .text, placeholder: "A123456789B"),
        GeneratorItem(id: "aztec", title: "Aztec", iconName: "viewfinder.circle", category: .barcode, isPro: true, contentType: .text, placeholder: "Aztec 2D matrix data"),
        GeneratorItem(id: "datamatrix", title: "Data Matrix", iconName: "square.grid.3x3.fill", category: .barcode, isPro: true, contentType: .text, placeholder: "Data Matrix 2D payload"),
        GeneratorItem(id: "pdf417", title: "PDF417", iconName: "tablecells", category: .barcode, isPro: true, contentType: .text, placeholder: "PDF417 stacked data"),
        GeneratorItem(id: "microqr", title: "Micro QR", iconName: "qrcode", category: .barcode, isPro: true, contentType: .text, placeholder: "Compact Micro QR text or link"),
        GeneratorItem(id: "micropdf417", title: "Micro PDF417", iconName: "tablecells.fill", category: .barcode, isPro: true, contentType: .text, placeholder: "Micro PDF417 data"),

        // Category 4 — Social (19 Items — Pro)
        GeneratorItem(id: "youtube", title: "YouTube", iconName: "play.rectangle", category: .social, isPro: true, contentType: .social, placeholder: "@channel or username", prefix: "https://youtube.com/@"),
        GeneratorItem(id: "facebook", title: "Facebook", iconName: "hand.thumbsup", category: .social, isPro: true, contentType: .social, placeholder: "username or page ID", prefix: "https://facebook.com/"),
        GeneratorItem(id: "whatsapp", title: "WhatsApp", iconName: "bubble.left.and.bubble.right", category: .social, isPro: true, contentType: .phone, placeholder: "+1 (555) 000-0000", prefix: "https://wa.me/"),
        GeneratorItem(id: "instagram", title: "Instagram", iconName: "camera", category: .social, isPro: true, contentType: .social, placeholder: "username", prefix: "https://instagram.com/"),
        GeneratorItem(id: "tiktok", title: "TikTok", iconName: "music.note", category: .social, isPro: true, contentType: .social, placeholder: "username", prefix: "https://tiktok.com/@"),
        GeneratorItem(id: "wechat", title: "WeChat", iconName: "bubble.left.and.text.bubble.right", category: .social, isPro: true, contentType: .social, placeholder: "WeChat ID", prefix: "weixin://dl/chat?"),
        GeneratorItem(id: "telegram", title: "Telegram", iconName: "paperplane", category: .social, isPro: true, contentType: .social, placeholder: "username", prefix: "https://t.me/"),
        GeneratorItem(id: "snapchat", title: "Snapchat", iconName: "sparkles.rectangle.stack", category: .social, isPro: true, contentType: .social, placeholder: "username", prefix: "https://snapchat.com/add/"),
        GeneratorItem(id: "x", title: "X", iconName: "number", category: .social, isPro: true, contentType: .social, placeholder: "username", prefix: "https://x.com/"),
        GeneratorItem(id: "spotify", title: "Spotify", iconName: "headphones", category: .social, isPro: true, contentType: .website, placeholder: "open.spotify.com/...", prefix: "https://open.spotify.com/"),
        GeneratorItem(id: "pinterest", title: "Pinterest", iconName: "pin", category: .social, isPro: true, contentType: .social, placeholder: "username", prefix: "https://pinterest.com/"),
        GeneratorItem(id: "linkedin", title: "LinkedIn", iconName: "briefcase", category: .social, isPro: true, contentType: .social, placeholder: "username", prefix: "https://linkedin.com/in/"),
        GeneratorItem(id: "reddit", title: "Reddit", iconName: "bubble.middle.bottom", category: .social, isPro: true, contentType: .social, placeholder: "u/username or r/sub", prefix: "https://reddit.com/"),
        GeneratorItem(id: "discord", title: "Discord", iconName: "gamecontroller", category: .social, isPro: true, contentType: .website, placeholder: "discord.gg/inviteCode", prefix: "https://discord.gg/"),
        GeneratorItem(id: "threads", title: "Threads", iconName: "at", category: .social, isPro: true, contentType: .social, placeholder: "username", prefix: "https://threads.net/@"),
        GeneratorItem(id: "line", title: "LINE", iconName: "message", category: .social, isPro: true, contentType: .social, placeholder: "LINE ID", prefix: "https://line.me/ti/p/~"),
        GeneratorItem(id: "viber", title: "Viber", iconName: "phone.arrow.up.right", category: .social, isPro: true, contentType: .phone, placeholder: "+15550000000", prefix: "viber://chat?number="),
        GeneratorItem(id: "kakaotalk", title: "KakaoTalk", iconName: "bubble.left.circle", category: .social, isPro: true, contentType: .social, placeholder: "KakaoTalk ID", prefix: "https://open.kakao.com/"),
        GeneratorItem(id: "github", title: "GitHub", iconName: "chevron.left.forwardslash.chevron.right", category: .social, isPro: true, contentType: .website, placeholder: "username", prefix: "https://github.com/")
    ]
    
    public static func items(for category: GeneratorCategory) -> [GeneratorItem] {
        items.filter { $0.category == category }
    }
}

// MARK: - Generator View (Expandable Accordion Layout)

public struct GenerateQRView: View {
    public var title: String
    public var selectedTemplate: QRTemplate?
    public var onBack: (() -> Void)?
    public var onOpenPro: (() -> Void)?
    public var onProceedToCustomize: (String, QRContentType, QRTemplate?) -> Void
    
    // Accordion State: QR Code is expanded by default, others collapsed
    @State private var expandedSections: Set<GeneratorCategory> = [.qrCode]
    @State private var selectedItem: GeneratorItem? = nil
    @State private var scrollOffsetY: CGFloat = 0
    
    public init(
        title: String = "Generator",
        selectedTemplate: QRTemplate? = nil,
        onBack: (() -> Void)? = nil,
        onOpenPro: (() -> Void)? = nil,
        onProceedToCustomize: @escaping (String, QRContentType, QRTemplate?) -> Void
    ) {
        self.title = title
        self.selectedTemplate = selectedTemplate
        self.onBack = onBack
        self.onOpenPro = onOpenPro
        self.onProceedToCustomize = onProceedToCustomize
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Sticky Top Navigation Bar
            topNavigationBar
            
            // Scrollable Content with Collapsible Accordion Sections
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Geometry tracker for scroll transition
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geo.frame(in: .named("generatorScroll")).minY
                        )
                    }
                    .frame(height: 0)
                    
                    // Large 28px Screen Title
                    Text(title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                        .padding(.bottom, 12)
                    
                    // Selected Template Badge Header (if came from template selection)
                    if let t = selectedTemplate {
                        selectedTemplateBanner(t)
                    }
                    
                    // 4 Vertical Collapsible Accordion Sections
                    VStack(spacing: 0) {
                        ForEach(GeneratorCategory.allCases) { category in
                            accordionSection(category)
                        }
                    }
                    .padding(.bottom, 90)
                }
            }
            .coordinateSpace(name: "generatorScroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffsetY = value
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "06141B").ignoresSafeArea())
        // Half Sheet for Entering Item Content
        .sheet(item: $selectedItem) { item in
            GeneratorItemInputSheet(
                item: item,
                selectedTemplate: selectedTemplate,
                onCreate: { payload, type in
                    selectedItem = nil
                    onProceedToCustomize(payload, type, selectedTemplate)
                }
            )
            .presentationDetents([.fraction(0.68), .large])
            .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Top Navigation Bar
    private var topNavigationBar: some View {
        HStack {
            if let onBack = onBack {
                Button(action: {
                    let feedback = UIImpactFeedbackGenerator(style: .light)
                    feedback.impactOccurred()
                    onBack()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "11212D"))
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(hex: "253745"), lineWidth: 1)
                        )
                }
            } else {
                Color.clear.frame(width: 38, height: 38)
            }
            
            Spacer()
            
            // Centered 18px navigation title on scroll
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "CCD0CF"))
                .opacity(min(max((-scrollOffsetY - 15) / 25, 0), 1))
            
            Spacer()
            
            // Circular Crown / Pro Badge Button
            Button(action: {
                let feedback = UIImpactFeedbackGenerator(style: .medium)
                feedback.impactOccurred()
                onOpenPro?()
            }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "11212D"))
                        .frame(width: 38, height: 38)
                        .overlay(
                            Circle().stroke(Color(hex: "253745"), lineWidth: 1)
                        )
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color(hex: "06141B"))
    }
    
    // MARK: - Selected Template Banner
    private func selectedTemplateBanner(_ t: QRTemplate) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: t.gradientHexColors.map { Color(hex: $0) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: t.categoryIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(t.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    Text(t.category.rawValue)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: "253745"))
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .clipShape(Capsule())
                }
                
                Text("Select an item below to populate this design")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "9BA8AB"))
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(hex: "11212D"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "253745"), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
    
    // MARK: - Accordion Section View
    private func accordionSection(_ category: GeneratorCategory) -> some View {
        let isExpanded = expandedSections.contains(category)
        let items = GeneratorCatalog.items(for: category)
        
        return VStack(spacing: 0) {
            // Full-width tappable Section Header Row
            Button(action: {
                let feedback = UIImpactFeedbackGenerator(style: .light)
                feedback.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                    if expandedSections.contains(category) {
                        expandedSections.remove(category)
                    } else {
                        expandedSections.insert(category)
                    }
                }
            }) {
                HStack {
                    Text(category.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "9BA8AB"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            // 3-Column Card Grid when expanded
            if isExpanded {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(items) { item in
                        generatorCard(item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, 18)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            Divider()
                .background(Color(hex: "253745"))
                .padding(.horizontal, 20)
        }
    }
    
    // MARK: - 3-Column Card Component
    private func generatorCard(_ item: GeneratorItem) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            selectedItem = item
        }) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 10) {
                    // Center icon container: 42x42 badge, cornerRadius 12, #253745 fill
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(hex: "253745"))
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: item.iconName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    }
                    
                    // Centered, clean 1-2 line title in #CCD0CF (13px, Medium)
                    Text(item.title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)
                        .padding(.horizontal, 4)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Optional Pro / Lock badge
                if item.isPro {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 106)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(hex: "11212D"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(hex: "253745"), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(SpringCardButtonStyle())
    }
}

// MARK: - PreferenceKey for Scroll Tracking
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Universal Item Input Half Sheet
public struct GeneratorItemInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    public let item: GeneratorItem
    public let selectedTemplate: QRTemplate?
    public var onCreate: (String, QRContentType) -> Void
    
    // Input state variables
    @State private var textInput: String = ""
    @State private var secondaryInput: String = ""
    @State private var tertiaryInput: String = ""
    @State private var quaternaryInput: String = ""
    @State private var quinaryInput: String = ""
    @State private var wifiSecurity: String = "WPA"
    @State private var showPassword: Bool = false
    
    public init(
        item: GeneratorItem,
        selectedTemplate: QRTemplate? = nil,
        onCreate: @escaping (String, QRContentType) -> Void
    ) {
        self.item = item
        self.selectedTemplate = selectedTemplate
        self.onCreate = onCreate
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(hex: "253745"))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: item.iconName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(item.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "CCD0CF"))
                        
                        if item.isPro {
                            Text("PRO")
                                .font(.system(size: 10, weight: .black))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "4A5C6A"))
                                .foregroundColor(Color(hex: "CCD0CF"))
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text(item.category.rawValue)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "9BA8AB"))
                }
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "9BA8AB"))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 12)
            
            Divider()
                .background(Color(hex: "253745"))
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            // Scrollable Inputs
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    inputFields
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            
            // Bottom Create Button
            VStack(spacing: 0) {
                Button(action: {
                    let feedback = UIImpactFeedbackGenerator(style: .medium)
                    feedback.impactOccurred()
                    let payload = compilePayload()
                    onCreate(payload, item.contentType)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 16, weight: .bold))
                        Text("Create")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(hex: "4A5C6A"))
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 16)
            }
            .background(Color(hex: "11212D"))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(hex: "253745")),
                alignment: .top
            )
        }
        .background(Color(hex: "11212D").ignoresSafeArea())
        .onAppear {
            if let t = selectedTemplate, !t.defaultContent.isEmpty {
                textInput = t.defaultContent
            }
        }
    }
    
    // MARK: - Input Fields Per Item
    @ViewBuilder
    private var inputFields: some View {
        switch item.id {
        case "wifi":
            fieldBlock(label: "NETWORK NAME (SSID)") {
                styledTextField(placeholder: "Enter Wi-Fi name", text: $textInput, icon: "wifi")
            }
            fieldBlock(label: "PASSWORD") {
                HStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 15))
                    
                    if showPassword {
                        TextField("Enter password", text: $secondaryInput)
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    } else {
                        SecureField("Enter password", text: $secondaryInput)
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color(hex: "9BA8AB"))
                            .font(.system(size: 14))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            fieldBlock(label: "SECURITY TYPE") {
                HStack(spacing: 8) {
                    ForEach(["WPA", "WEP", "None"], id: \.self) { enc in
                        Button(action: { wifiSecurity = enc }) {
                            Text(enc == "None" ? "Open" : enc)
                                .font(.system(size: 13, weight: wifiSecurity == enc ? .bold : .medium))
                                .foregroundColor(wifiSecurity == enc ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 38)
                                .background(
                                    Capsule().fill(wifiSecurity == enc ? Color(hex: "4A5C6A") : Color(hex: "253745"))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
        case "contact":
            HStack(spacing: 10) {
                fieldBlock(label: "FIRST NAME") {
                    styledTextField(placeholder: "John", text: $textInput, icon: nil)
                }
                fieldBlock(label: "LAST NAME") {
                    styledTextField(placeholder: "Doe", text: $secondaryInput, icon: nil)
                }
            }
            fieldBlock(label: "PHONE NUMBER") {
                styledTextField(placeholder: "+1 (555) 123-4567", text: $tertiaryInput, icon: "phone.fill", keyboardType: .phonePad)
            }
            fieldBlock(label: "EMAIL ADDRESS") {
                styledTextField(placeholder: "john@example.com", text: $quaternaryInput, icon: "envelope.fill", keyboardType: .emailAddress)
            }
            fieldBlock(label: "ORGANIZATION / COMPANY") {
                styledTextField(placeholder: "Company name", text: $quinaryInput, icon: "briefcase.fill")
            }
            
        case "text":
            fieldBlock(label: "MESSAGE OR PLAIN TEXT") {
                TextEditor(text: $textInput)
                    .frame(height: 120)
                    .padding(8)
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .scrollContentBackground(.hidden)
                    .background(Color(hex: "06141B"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "253745"), lineWidth: 1)
                    )
            }
            
        case "email":
            fieldBlock(label: "RECIPIENT EMAIL") {
                styledTextField(placeholder: "recipient@example.com", text: $textInput, icon: "envelope.fill", keyboardType: .emailAddress)
            }
            fieldBlock(label: "SUBJECT") {
                styledTextField(placeholder: "Email Subject", text: $secondaryInput, icon: "pencil")
            }
            fieldBlock(label: "MESSAGE") {
                styledTextField(placeholder: "Message text...", text: $tertiaryInput, icon: "text.alignleft")
            }
            
        case "sms":
            fieldBlock(label: "RECIPIENT PHONE NUMBER") {
                styledTextField(placeholder: "+1 (555) 000-0000", text: $textInput, icon: "phone.fill", keyboardType: .phonePad)
            }
            fieldBlock(label: "PRE-FILLED SMS MESSAGE") {
                styledTextField(placeholder: "Optional text message...", text: $secondaryInput, icon: "bubble.left.fill")
            }
            
        case "phone", "viber":
            fieldBlock(label: "PHONE NUMBER") {
                styledTextField(placeholder: "+1 (555) 000-0000", text: $textInput, icon: "phone.fill", keyboardType: .phonePad)
            }
            
        case "location", "googleplacereviews":
            fieldBlock(label: "LOCATION NAME OR ADDRESS") {
                styledTextField(placeholder: "e.g. Times Square, New York", text: $textInput, icon: "mappin.and.ellipse")
            }
            HStack(spacing: 10) {
                fieldBlock(label: "LATITUDE (OPTIONAL)") {
                    styledTextField(placeholder: "37.7749", text: $secondaryInput, icon: nil, keyboardType: .decimalPad)
                }
                fieldBlock(label: "LONGITUDE (OPTIONAL)") {
                    styledTextField(placeholder: "-122.4194", text: $tertiaryInput, icon: nil, keyboardType: .decimalPad)
                }
            }
            
        case "event":
            fieldBlock(label: "EVENT TITLE") {
                styledTextField(placeholder: "e.g. Annual Design Summit", text: $textInput, icon: "calendar")
            }
            fieldBlock(label: "LOCATION OR MEETING LINK") {
                styledTextField(placeholder: "e.g. Hall B or Zoom URL", text: $secondaryInput, icon: "location.fill")
            }
            fieldBlock(label: "DESCRIPTION OR WEBSITE") {
                styledTextField(placeholder: "https://event.example.com", text: $tertiaryInput, icon: "link")
            }
            
        case "bitcoin":
            fieldBlock(label: "BITCOIN WALLET ADDRESS") {
                styledTextField(placeholder: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa", text: $textInput, icon: "bitcoinsign.circle")
            }
            fieldBlock(label: "AMOUNT IN BTC (OPTIONAL)") {
                styledTextField(placeholder: "0.05", text: $secondaryInput, icon: "dollarsign", keyboardType: .decimalPad)
            }
            
        case "ethereum":
            fieldBlock(label: "ETHEREUM WALLET ADDRESS") {
                styledTextField(placeholder: "0x71C...497", text: $textInput, icon: "rhombus.fill")
            }
            fieldBlock(label: "AMOUNT IN ETH (OPTIONAL)") {
                styledTextField(placeholder: "1.0", text: $secondaryInput, icon: "dollarsign", keyboardType: .decimalPad)
            }
            
        default:
            // Standard generic input for Barcodes, Social handles, Business links & URLs
            fieldBlock(label: "\(item.title.uppercased()) VALUE") {
                HStack(spacing: 10) {
                    if let prefix = item.prefix {
                        Text(prefix)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "4A5C6A"))
                    } else {
                        Image(systemName: item.iconName)
                            .foregroundColor(Color(hex: "4A5C6A"))
                            .font(.system(size: 15))
                    }
                    
                    TextField(item.placeholder.isEmpty ? "Enter content" : item.placeholder, text: $textInput)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .autocapitalization(.none)
                    
                    if !textInput.isEmpty {
                        Button(action: { textInput = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(hex: "9BA8AB"))
                                .font(.system(size: 14))
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
        }
    }
    
    // MARK: - Payload Compiler
    private func compilePayload() -> String {
        switch item.id {
        case "wifi":
            let auth = wifiSecurity == "None" ? "nopass" : wifiSecurity
            let ssid = textInput.isEmpty ? "MyWiFi" : textInput
            return "WIFI:T:\(auth);S:\(ssid);P:\(secondaryInput);;"
            
        case "contact":
            let fn = textInput.isEmpty ? "John" : textInput
            let ln = secondaryInput.isEmpty ? "Doe" : secondaryInput
            var vcard = "BEGIN:VCARD\nVERSION:3.0\nN:\(ln);\(fn);;;\nFN:\(fn) \(ln)\n"
            if !tertiaryInput.isEmpty { vcard += "TEL;TYPE=CELL:\(tertiaryInput)\n" }
            if !quaternaryInput.isEmpty { vcard += "EMAIL:\(quaternaryInput)\n" }
            if !quinaryInput.isEmpty { vcard += "ORG:\(quinaryInput)\n" }
            vcard += "END:VCARD"
            return vcard
            
        case "text":
            return textInput.isEmpty ? "Hello from QR Shield" : textInput
            
        case "email":
            let mail = textInput.isEmpty ? "contact@qrshield.app" : textInput
            let sub = secondaryInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let body = tertiaryInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "mailto:\(mail)?subject=\(sub)&body=\(body)"
            
        case "sms":
            let phone = textInput.filter { "0123456789+".contains($0) }
            let msg = secondaryInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "smsto:\(phone):\(msg)"
            
        case "phone":
            let clean = textInput.filter { "0123456789+".contains($0) }
            return "tel:\(clean.isEmpty ? "+15551234567" : clean)"
            
        case "location":
            let name = textInput.isEmpty ? "Location" : textInput
            if let lat = Double(secondaryInput), let lon = Double(tertiaryInput) {
                return "geo:\(lat),\(lon)?q=\(lat),\(lon)(\(name))"
            }
            return "https://maps.apple.com/?q=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            
        case "event":
            return "BEGIN:VEVENT\nSUMMARY:\(textInput)\nLOCATION:\(secondaryInput)\nDESCRIPTION:\(tertiaryInput)\nEND:VEVENT"
            
        case "bitcoin":
            var btc = "bitcoin:\(textInput.isEmpty ? "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa" : textInput)"
            if !secondaryInput.isEmpty { btc += "?amount=\(secondaryInput)" }
            return btc
            
        case "ethereum":
            var eth = "ethereum:\(textInput.isEmpty ? "0x0000000000000000000000000000000000000000" : textInput)"
            if !secondaryInput.isEmpty { eth += "?value=\(secondaryInput)" }
            return eth
            
        default:
            var val = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
            if let prefix = item.prefix {
                let cleaned = val.trimmingCharacters(in: CharacterSet(charactersIn: "@/# "))
                if cleaned.isEmpty {
                    return "\(prefix)qrshield"
                }
                if val.hasPrefix("http://") || val.hasPrefix("https://") {
                    return val
                }
                return "\(prefix)\(cleaned)"
            }
            if val.isEmpty {
                return item.placeholder.isEmpty ? "QR Shield Item" : item.placeholder
            }
            return val
        }
    }
    
    // MARK: - Helper UI Builders
    private func fieldBlock<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "9BA8AB"))
                .tracking(1.0)
            
            content()
        }
    }
    
    private func styledTextField(
        placeholder: String,
        text: Binding<String>,
        icon: String?,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        HStack(spacing: 10) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: "4A5C6A"))
                    .font(.system(size: 15))
            }
            
            TextField(placeholder, text: text)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "CCD0CF"))
                .keyboardType(keyboardType)
                .autocapitalization(.none)
            
            if !text.wrappedValue.isEmpty {
                Button(action: { text.wrappedValue = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(hex: "06141B"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
    }
}
