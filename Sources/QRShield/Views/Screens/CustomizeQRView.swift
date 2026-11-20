import SwiftUI
import PhotosUI

public struct ShareSheet: UIViewControllerRepresentable {
    public let activityItems: [Any]
    public init(activityItems: [Any]) {
        self.activityItems = activityItems
    }
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

public enum QRTextFontOption: String, CaseIterable, Identifiable {
    case standard = "Default"
    case rounded = "Rounded"
    case serif = "Serif"
    case monospaced = "Mono"
    
    public var id: String { rawValue }
    
    public var fontDesign: Font.Design {
        switch self {
        case .standard: return .default
        case .rounded: return .rounded
        case .serif: return .serif
        case .monospaced: return .monospaced
        }
    }
}

public struct CustomizeQRView: View {
    public let content: String
    public let contentType: QRContentType
    @State public var styleConfig: QRStyleConfig
    @State public var selectedTemplate: QRTemplate?
    public var onBack: () -> Void
    public var onSaved: () -> Void
    
    // Initial state kept for reset
    private let initialStyleConfig: QRStyleConfig
    private let initialTemplate: QRTemplate?
    
    // 5-Tab Bar State: Default is .template
    @State private var activeTab: CustomizerTab = .template
    
    // Tab 1 (Template) Subcategories
    public enum TemplateSubCategory: String, CaseIterable, Identifiable {
        case popular = "Popular"
        case social = "Social"
        case business = "Business"
        case wifi = "Wifi"
        case event = "Event"
        
        public var id: String { rawValue }
    }
    @State private var selectedSubCategory: TemplateSubCategory = .popular
    
    // Tab 2 (Logo) State
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    // Tab 4 (Text) State
    @State private var customLabelText: String = ""
    @State private var showTextAbove: Bool = false
    @State private var selectedFontOption: QRTextFontOption = .standard
    @State private var selectedTextColorHex: String = "111827"
    
    // Export & Sharing
    @State private var showShareSheet: Bool = false
    @State private var showExportSuccessModal: Bool = false
    @State private var renderedUIImage: UIImage? = nil
    
    public enum CustomizerTab: String, CaseIterable, Identifiable {
        case template = "Template"
        case logo = "Logo"
        case color = "Color"
        case text = "Text"
        case style = "Style"
        
        public var id: String { rawValue }
        
        public var iconName: String {
            switch self {
            case .template: return "square.grid.2x2.fill"
            case .logo: return "app.badge.fill"
            case .color: return "paintpalette.fill"
            case .text: return "textformat"
            case .style: return "sparkles"
            }
        }
    }
    
    public init(
        content: String,
        contentType: QRContentType = .website,
        styleConfig: QRStyleConfig = QRStyleConfig(),
        selectedTemplate: QRTemplate? = nil,
        onBack: @escaping () -> Void,
        onSaved: @escaping () -> Void
    ) {
        self.content = content
        self.contentType = contentType
        let initialConfig = selectedTemplate?.styleConfig ?? styleConfig
        self._styleConfig = State(initialValue: initialConfig)
        self._selectedTemplate = State(initialValue: selectedTemplate)
        self.initialStyleConfig = initialConfig
        self.initialTemplate = selectedTemplate
        self.onBack = onBack
        self.onSaved = onSaved
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 1. Top Navigation Bar
            topNavigationBar
            
            // 2. Centered Live QR Code Preview Card
            liveQRPreviewCard
            
            // 3. 5-Tab Icon Toolbar bounded by thin top and bottom dividers
            fiveTabIconToolbar
            
            // 4. Customization Content Panels
            Group {
                switch activeTab {
                case .template:
                    templatePanelView
                case .logo:
                    logoPanelView
                case .color:
                    colorPanelView
                case .text:
                    textPanelView
                case .style:
                    stylePanelView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $showShareSheet) {
            if let img = renderedUIImage {
                ShareSheet(activityItems: [img])
            }
        }
        .sheet(isPresented: $showExportSuccessModal) {
            exportSuccessSheet
        }
    }
    
    // MARK: - 1. Top Navigation Bar
    private var topNavigationBar: some View {
        HStack {
            // Clean purple back chevron icon (<, #6D28D9) without circular background
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "6D28D9"))
                    .frame(width: 36, height: 36, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Fixed title "Customize" (18px, SemiBold, #111827)
            Text("Customize")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "111827"))
            
            Spacer()
            
            // Compact rounded rectangular purple button (border-radius: 8px, #6D28D9 fill) with white "Save" text (14px, SemiBold)
            Button(action: saveQRCode) {
                Text("Save")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color(hex: "6D28D9"))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    // MARK: - 2. Centered Live QR Code Preview Card
    private var liveQRPreviewCard: some View {
        VStack(spacing: 6) {
            if showTextAbove && !customLabelText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(customLabelText)
                    .font(.system(size: 14, weight: .bold, design: selectedFontOption.fontDesign))
                    .foregroundColor(Color(hex: selectedTextColorHex))
                    .lineLimit(1)
                    .transition(.opacity)
            }
            
            QRDisplayView(
                content: content,
                styleConfig: styleConfig,
                size: 210
            )
            
            if !showTextAbove && !customLabelText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(customLabelText)
                    .font(.system(size: 14, weight: .bold, design: selectedFontOption.fontDesign))
                    .foregroundColor(Color(hex: selectedTextColorHex))
                    .lineLimit(1)
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    // MARK: - 3. 5-Tab Icon Toolbar
    private var fiveTabIconToolbar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "E5E7EB"))
                .frame(height: 1)
            
            HStack(spacing: 0) {
                ForEach(CustomizerTab.allCases) { tab in
                    tabBarItem(tab)
                }
            }
            .padding(.vertical, 8)
            
            Rectangle()
                .fill(Color(hex: "E5E7EB"))
                .frame(height: 1)
        }
    }
    
    private func tabBarItem(_ tab: CustomizerTab) -> some View {
        let isSelected = activeTab == tab
        return Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            withAnimation(.easeInOut(duration: 0.18)) {
                activeTab = tab
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isSelected ? Color(hex: "6D28D9") : Color(hex: "F3F4F6"))
                        .frame(width: 36, height: 36)
                    
                    if tab == .text {
                        Text("T")
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .foregroundColor(isSelected ? .white : Color(hex: "6B7280"))
                    } else {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(isSelected ? .white : Color(hex: "6B7280"))
                    }
                }
                
                Text(tab.rawValue)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color(hex: "6D28D9") : Color(hex: "6B7280"))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Tab 1: Template Panel View
    private var templatePanelView: some View {
        VStack(spacing: 0) {
            // Horizontal Sub-Category Filter Bar
            HStack(spacing: 10) {
                // Circular purple reset icon on left (resets customizations)
                Button(action: {
                    let feedback = UIImpactFeedbackGenerator(style: .light)
                    feedback.impactOccurred()
                    withAnimation {
                        styleConfig = initialStyleConfig
                        selectedTemplate = initialTemplate
                        customLabelText = ""
                        showTextAbove = false
                    }
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "6D28D9"))
                        .frame(width: 32, height: 32)
                        .background(Color(hex: "6D28D9").opacity(0.12))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                
                // Category Chips: Popular (active default), Social, Business, Wifi, Event
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(TemplateSubCategory.allCases) { cat in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedSubCategory = cat
                                }
                            }) {
                                Text(cat.rawValue)
                                    .font(.system(size: 12, weight: selectedSubCategory == cat ? .bold : .medium))
                                    .foregroundColor(selectedSubCategory == cat ? .white : Color(hex: "4B5563"))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(
                                        Capsule()
                                            .fill(selectedSubCategory == cat ? Color(hex: "6D28D9") : Color(hex: "F3F4F6"))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Rectangle()
                .fill(Color(hex: "E5E7EB"))
                .frame(height: 1)
            
            // Scrollable Grid of clean white-background template cards
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 14
                ) {
                    ForEach(templatesForCurrentCategory) { tmpl in
                        templateGridCard(tmpl)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
    }
    
    private var templatesForCurrentCategory: [QRTemplate] {
        switch selectedSubCategory {
        case .popular:
            return QRTemplate.popularTemplates
        case .social:
            return QRTemplate.predefinedTemplates.filter { $0.category == .socialMedia }
        case .business:
            return QRTemplate.predefinedTemplates.filter { $0.category == .business }
        case .wifi:
            return QRTemplate.predefinedTemplates.filter { $0.category == .wifi }
        case .event:
            return QRTemplate.predefinedTemplates.filter { $0.category == .event }
        }
    }
    
    private func templateGridCard(_ template: QRTemplate) -> some View {
        let isSelected = selectedTemplate?.id == template.id
        return Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTemplate = template
                styleConfig = template.styleConfig
            }
        }) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                    
                    if let image = QRCodeGeneratorService.shared.generateQRCode(
                        from: template.defaultContent,
                        style: template.styleConfig,
                        size: CGSize(width: 240, height: 240)
                    ) {
                        Image(uiImage: image)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .padding(8)
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isSelected ? Color(hex: "6D28D9") : Color(hex: "E5E7EB"), lineWidth: isSelected ? 2.5 : 1)
                )
                .shadow(color: isSelected ? Color(hex: "6D28D9").opacity(0.2) : Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                
                Text(template.name)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color(hex: "6D28D9") : Color(hex: "374151"))
                    .lineLimit(1)
            }
        }
        .buttonStyle(SpringCardButtonStyle())
    }
    
    // MARK: - Tab 2: Logo Panel View
    private var logoPanelView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Center Icon / Logo")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "4B5563"))
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(QRLogoType.allCases) { logo in
                            if logo == .custom {
                                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                    logoItemBadge(for: logo)
                                }
                                .onChange(of: selectedPhotoItem) { newItem in
                                    guard let newItem else { return }
                                    Task {
                                        if let data = try? await newItem.loadTransferable(type: Data.self),
                                           let _ = UIImage(data: data) {
                                            await MainActor.run {
                                                styleConfig.logoType = .custom
                                                styleConfig.customLogoData = data
                                            }
                                        }
                                    }
                                }
                            } else {
                                Button(action: {
                                    let feedback = UIImpactFeedbackGenerator(style: .light)
                                    feedback.impactOccurred()
                                    styleConfig.logoType = logo
                                }) {
                                    logoItemBadge(for: logo)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                }
            }
            .padding(.bottom, 24)
        }
    }
    
    private func logoItemBadge(for logo: QRLogoType) -> some View {
        let isSelected = styleConfig.logoType == logo
        return VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(logo == .none ? Color(hex: "F3F4F6") : logo.badgeBackgroundColor)
                    .frame(width: 44, height: 44)
                
                if let icon = logo.systemIcon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(logo == .none ? Color(hex: "9CA3AF") : .white)
                } else {
                    Image(systemName: "slash.circle")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
            }
            .overlay(
                Circle()
                    .stroke(isSelected ? Color(hex: "6D28D9") : Color.clear, lineWidth: 2.5)
                    .scaleEffect(1.15)
            )
            
            Text(logo.rawValue)
                .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? Color(hex: "6D28D9") : Color(hex: "6B7280"))
        }
    }
    
    // MARK: - Tab 3: Color Panel View
    private var colorPanelView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Color & Gradient Palette")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "4B5563"))
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(QRColorTheme.allCases) { theme in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                styleConfig.colorTheme = theme
                            }) {
                                VStack(spacing: 6) {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: theme.hexColors.map { Color(hex: $0) },
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 42, height: 42)
                                        .overlay(
                                            Circle()
                                                .stroke(styleConfig.colorTheme == theme ? Color(hex: "6D28D9") : Color.clear, lineWidth: 3)
                                                .scaleEffect(1.2)
                                        )
                                    
                                    Text(theme.rawValue)
                                        .font(.system(size: 10, weight: styleConfig.colorTheme == theme ? .bold : .medium))
                                        .foregroundColor(styleConfig.colorTheme == theme ? Color(hex: "6D28D9") : Color(hex: "6B7280"))
                                        .lineLimit(1)
                                }
                                .frame(width: 68)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - Tab 4: Text Panel View
    private var textPanelView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                // Text input field with Clear ("None") button
                HStack(spacing: 8) {
                    HStack {
                        Image(systemName: "textformat")
                            .foregroundColor(Color(hex: "9CA3AF"))
                        
                        TextField("Enter label (e.g. Scan Me)", text: $customLabelText)
                            .font(.system(size: 14))
                        
                        if !customLabelText.isEmpty {
                            Button(action: { customLabelText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color(hex: "9CA3AF"))
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(hex: "F3F4F6"))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        customLabelText = ""
                    }) {
                        Text("None")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(customLabelText.isEmpty ? Color(hex: "6D28D9") : Color(hex: "6B7280"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(customLabelText.isEmpty ? Color(hex: "6D28D9").opacity(0.12) : Color(hex: "F3F4F6"))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                
                // Position Selector: Below / Above
                HStack(spacing: 12) {
                    Text("Position:")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "4B5563"))
                    
                    Button(action: { showTextAbove = false }) {
                        Text("Below QR")
                            .font(.system(size: 12, weight: !showTextAbove ? .bold : .medium))
                            .foregroundColor(!showTextAbove ? .white : Color(hex: "4B5563"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(!showTextAbove ? Color(hex: "6D28D9") : Color(hex: "F3F4F6")))
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { showTextAbove = true }) {
                        Text("Above QR")
                            .font(.system(size: 12, weight: showTextAbove ? .bold : .medium))
                            .foregroundColor(showTextAbove ? .white : Color(hex: "4B5563"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(showTextAbove ? Color(hex: "6D28D9") : Color(hex: "F3F4F6")))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                
                // Font Selector
                VStack(alignment: .leading, spacing: 6) {
                    Text("Font Style:")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "4B5563"))
                    
                    HStack(spacing: 8) {
                        ForEach(QRTextFontOption.allCases) { opt in
                            Button(action: {
                                selectedFontOption = opt
                            }) {
                                Text(opt.rawValue)
                                    .font(.system(size: 12, weight: selectedFontOption == opt ? .bold : .medium, design: opt.fontDesign))
                                    .foregroundColor(selectedFontOption == opt ? .white : Color(hex: "4B5563"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(selectedFontOption == opt ? Color(hex: "6D28D9") : Color(hex: "F3F4F6"))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                // Text Color Selector
                VStack(alignment: .leading, spacing: 6) {
                    Text("Text Color:")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "4B5563"))
                    
                    HStack(spacing: 12) {
                        ForEach(["111827", "6D28D9", "2563EB", "059669", "DC2626", "D97706"], id: \.self) { hex in
                            Button(action: {
                                selectedTextColorHex = hex
                            }) {
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedTextColorHex == hex ? Color(hex: "6D28D9") : Color.clear, lineWidth: 2.5)
                                            .scaleEffect(1.25)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - Tab 5: Style Panel View
    private var stylePanelView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // Dot Shape Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dot Shape")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "4B5563"))
                    
                    HStack(spacing: 14) {
                        ForEach(QRDotStyle.allCases) { style in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                styleConfig.dotStyle = style
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(styleConfig.dotStyle == style ? Color(hex: "6D28D9").opacity(0.12) : Color(hex: "F3F4F6"))
                                            .frame(width: 52, height: 52)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(styleConfig.dotStyle == style ? Color(hex: "6D28D9") : Color.clear, lineWidth: 2)
                                            )
                                        
                                        styleDotPreview(style)
                                    }
                                    
                                    Text(style.rawValue)
                                        .font(.system(size: 11, weight: styleConfig.dotStyle == style ? .bold : .medium))
                                        .foregroundColor(styleConfig.dotStyle == style ? Color(hex: "6D28D9") : Color(hex: "4B5563"))
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                // Corner Eye Shape Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Corner Eye Style")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "4B5563"))
                    
                    HStack(spacing: 14) {
                        ForEach(QREyeStyle.allCases) { eye in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                styleConfig.eyeStyle = eye
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(styleConfig.eyeStyle == eye ? Color(hex: "6D28D9").opacity(0.12) : Color(hex: "F3F4F6"))
                                            .frame(width: 52, height: 52)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(styleConfig.eyeStyle == eye ? Color(hex: "6D28D9") : Color.clear, lineWidth: 2)
                                            )
                                        
                                        eyePreview(eye)
                                    }
                                    
                                    Text(eye.rawValue)
                                        .font(.system(size: 11, weight: styleConfig.eyeStyle == eye ? .bold : .medium))
                                        .foregroundColor(styleConfig.eyeStyle == eye ? Color(hex: "6D28D9") : Color(hex: "4B5563"))
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 14)
            .padding(.bottom, 24)
        }
    }
    
    @ViewBuilder
    private func styleDotPreview(_ style: QRDotStyle) -> some View {
        let col = Color(hex: "1F2937")
        switch style {
        case .square:
            Rectangle().fill(col).frame(width: 14, height: 14)
        case .rounded:
            RoundedRectangle(cornerRadius: 4).fill(col).frame(width: 14, height: 14)
        case .circular:
            Circle().fill(col).frame(width: 14, height: 14)
        case .diamond:
            Rectangle().fill(col).frame(width: 12, height: 12).rotationEffect(.degrees(45))
        }
    }
    
    @ViewBuilder
    private func eyePreview(_ eye: QREyeStyle) -> some View {
        let col = Color(hex: "1F2937")
        switch eye {
        case .rounded:
            RoundedRectangle(cornerRadius: 5).stroke(col, lineWidth: 2.5).frame(width: 16, height: 16)
        case .square:
            Rectangle().stroke(col, lineWidth: 2.5).frame(width: 16, height: 16)
        case .circular:
            Circle().stroke(col, lineWidth: 2.5).frame(width: 16, height: 16)
        case .leaf:
            UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 0, bottomTrailingRadius: 7, topTrailingRadius: 0)
                .stroke(col, lineWidth: 2.5)
                .frame(width: 16, height: 16)
        }
    }
    
    // MARK: - Save Action
    private func saveQRCode() {
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        let title: String
        if let template = selectedTemplate {
            title = template.name
        } else {
            switch contentType {
            case .website: title = "Custom Link"
            case .wifi: title = "Custom Wi-Fi"
            case .contact: title = "Contact Card"
            case .social: title = "Social Profile"
            default: title = "\(contentType.rawValue) Code"
            }
        }
        
        let item = QRCodeItem(
            title: title,
            contentPreview: String(content.prefix(32)),
            rawContent: content,
            contentType: contentType,
            category: selectedTemplate?.category ?? contentType.category,
            createdAt: Date(),
            isFavorite: false,
            styleConfig: styleConfig,
            templateId: selectedTemplate?.id
        )
        
        QRStorageService.shared.save(item: item)
        
        // Export High-Resolution UIImage
        let exportedImage = QRCodeGeneratorService.shared.generateQRCode(
            from: content,
            style: styleConfig,
            size: CGSize(width: 1024, height: 1024)
        )
        
        if let cardImage = exportedImage {
            UIImageWriteToSavedPhotosAlbum(cardImage, nil, nil, nil)
            renderedUIImage = cardImage
        }
        
        showExportSuccessModal = true
    }
    
    // MARK: - Export Success Sheet
    private var exportSuccessSheet: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color(hex: "D1D5DB"))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
            
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "10B981"))
                    .font(.system(size: 22))
                Text("Saved to Camera Roll & Library!")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
            }
            .padding(.top, 4)
            
            // Image Preview
            if let img = renderedUIImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: Color.black.opacity(0.18), radius: 14, x: 0, y: 8)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                // Share Button
                Button(action: {
                    showExportSuccessModal = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showShareSheet = true
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .bold))
                        Text("Share QR Code")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(hex: "6D28D9"))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                
                // View in My Codes
                Button(action: {
                    showExportSuccessModal = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onSaved()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 15, weight: .semibold))
                        Text("View in My Codes")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(Color(hex: "6D28D9"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(hex: "6D28D9").opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                
                // Done Button
                Button(action: {
                    showExportSuccessModal = false
                    onBack()
                }) {
                    Text("Done")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "6B7280"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .presentationDetents([.fraction(0.72), .large])
    }
}
