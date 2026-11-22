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
        case business = "Business"
        case colorful = "Colorful"
        case social = "Social"
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
    @State private var selectedTextColorHex: String = "CCD0CF"
    
    // Live Preview State (Zero-lag synchronous + cancellable task)
    @State private var livePreviewImage: UIImage? = nil
    @State private var renderTask: Task<Void, Never>? = nil
    
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
            // 1. Top Navigation Bar (#06141B background)
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
        .background(Color(hex: "06141B").ignoresSafeArea())
        .onAppear {
            updateQRPreview(with: styleConfig)
        }
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
            // Clean back chevron icon (<, #CCD0CF)
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .frame(width: 36, height: 36, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Fixed title "Customize" (18px, SemiBold, #CCD0CF)
            Text("Customize")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "CCD0CF"))
            
            Spacer()
            
            // Compact rounded rectangular button (border-radius: 8px, #4A5C6A fill) with white #CCD0CF "Save" text
            Button(action: saveQRCode) {
                Text("Save")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color(hex: "4A5C6A"))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color(hex: "06141B"))
    }
    
    // MARK: - 2. Centered Live QR Code Preview Card
    private var liveQRPreviewCard: some View {
        QRDisplayView(
            content: content,
            styleConfig: styleConfig,
            previewImage: livePreviewImage,
            size: 210
        )
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    // MARK: - 3. 5-Tab Icon Toolbar
    private var fiveTabIconToolbar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "253745"))
                .frame(height: 1)
            
            HStack(spacing: 0) {
                ForEach(CustomizerTab.allCases) { tab in
                    tabBarItem(tab)
                }
            }
            .padding(.vertical, 8)
            .background(Color(hex: "11212D"))
            
            Rectangle()
                .fill(Color(hex: "253745"))
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
                        .fill(isSelected ? Color(hex: "4A5C6A") : Color(hex: "253745"))
                        .frame(width: 36, height: 36)
                    
                    if tab == .text {
                        Text("T")
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                    } else {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                    }
                }
                
                Text(tab.rawValue)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Live Preview Updating (Solves Stale State & Off-By-One Race Condition)
    private func updateQRPreview(
        template: QRTemplate? = nil,
        logo: QRLogoType? = nil,
        customLogoData: Data? = nil,
        color: QRColorTheme? = nil,
        dotShape: QRDotStyle? = nil,
        eyeStyle: QREyeStyle? = nil,
        text: String? = nil,
        textPositionAbove: Bool? = nil,
        textFont: String? = nil,
        textColorHex: String? = nil,
        decorativeFrame: QRDecorativeFrame? = nil,
        with explicitConfig: QRStyleConfig? = nil
    ) {
        // 1. Cancel in-flight background QR render task immediately
        renderTask?.cancel()
        
        // 2. Build newly configured style config directly
        var newConfig = explicitConfig ?? styleConfig
        if let template = template {
            selectedTemplate = template
            newConfig = template.styleConfig
            // Carry forward existing custom text settings
            newConfig.customText = styleConfig.customText
            newConfig.textPositionAbove = styleConfig.textPositionAbove
            newConfig.textFont = styleConfig.textFont
            newConfig.textColorHex = styleConfig.textColorHex
        }
        if let frame = decorativeFrame {
            newConfig.decorativeFrame = frame
        }
        if let logo = logo {
            newConfig.logoType = logo
            if logo == .none {
                newConfig.customLogoData = nil
            }
        }
        if let data = customLogoData {
            newConfig.logoType = .custom
            newConfig.customLogoData = data
        }
        if let color = color {
            newConfig.colorTheme = color
        }
        if let dotShape = dotShape {
            newConfig.dotStyle = dotShape
        }
        if let eyeStyle = eyeStyle {
            newConfig.eyeStyle = eyeStyle
        }
        if let text = text {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            newConfig.customText = trimmed.isEmpty ? nil : text
        }
        if let textPositionAbove = textPositionAbove {
            newConfig.textPositionAbove = textPositionAbove
        }
        if let textFont = textFont {
            newConfig.textFont = textFont
        }
        if let textColorHex = textColorHex {
            newConfig.textColorHex = textColorHex
        }
        
        // 3. Immediately assign to state for UI selection highlights
        self.styleConfig = newConfig
        
        // 4. Generate QR code immediately with the new configuration
        let targetConfig = newConfig
        let targetContent = content
        
        // Immediate synchronous generation / cache lookup
        if let direct = QRCodeGeneratorService.shared.generateQRCode(
            from: targetContent,
            style: targetConfig,
            size: CGSize(width: 630, height: 630)
        ) {
            self.livePreviewImage = direct
        } else {
            renderTask = Task { @MainActor in
                guard !Task.isCancelled else { return }
                let rendered = QRCodeGeneratorService.shared.generateQRCode(
                    from: targetContent,
                    style: targetConfig,
                    size: CGSize(width: 630, height: 630)
                )
                guard !Task.isCancelled else { return }
                self.livePreviewImage = rendered
            }
        }
    }
    
    // MARK: - Tab 1: Template Panel View
    private var templatePanelView: some View {
        VStack(spacing: 0) {
            // Horizontal Sub-Category Filter Bar (#11212D background)
            HStack(spacing: 10) {
                // Circular reset icon on left (resets customizations)
                Button(action: {
                    let feedback = UIImpactFeedbackGenerator(style: .light)
                    feedback.impactOccurred()
                    customLabelText = ""
                    showTextAbove = false
                    selectedFontOption = .standard
                    selectedTextColorHex = "CCD0CF"
                    var resetConfig = initialStyleConfig
                    resetConfig.customText = nil
                    resetConfig.textPositionAbove = false
                    resetConfig.textFont = "Default"
                    resetConfig.textColorHex = "CCD0CF"
                    selectedTemplate = initialTemplate
                    updateQRPreview(with: resetConfig)
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .frame(width: 32, height: 32)
                        .background(Color(hex: "253745"))
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
                                    .foregroundColor(selectedSubCategory == cat ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(
                                        Capsule()
                                            .fill(selectedSubCategory == cat ? Color(hex: "4A5C6A") : Color(hex: "253745"))
                                    )
                                    .overlay(
                                        Capsule()
                                            .stroke(selectedSubCategory == cat ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(hex: "11212D"))
            
            Rectangle()
                .fill(Color(hex: "253745"))
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
        case .business:
            return QRTemplate.predefinedTemplates.filter { $0.category == .business }
        case .colorful:
            return QRTemplate.predefinedTemplates.filter { $0.category == .colorful }
        case .social:
            return QRTemplate.predefinedTemplates.filter { $0.category == .socialMedia }
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
            updateQRPreview(template: template)
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
                            .padding(template.styleConfig.decorativeFrame != .none ? 2 : 8)
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isSelected ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: isSelected ? 2.5 : 1)
                )
                .overlay(
                    Group {
                        if template.isPro {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("PRO")
                                        .font(.system(size: 8, weight: .black))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 2)
                                        .background(
                                            Capsule().fill(
                                                LinearGradient(
                                                    colors: [Color(hex: "F59E0B"), Color(hex: "D97706")],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                        )
                                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                                        .padding(4)
                                }
                                Spacer()
                            }
                        }
                    }
                )
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2)
                
                Text(template.name)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
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
                    .foregroundColor(Color(hex: "CCD0CF"))
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
                                                updateQRPreview(customLogoData: data)
                                            }
                                        }
                                    }
                                }
                            } else {
                                Button(action: {
                                    let feedback = UIImpactFeedbackGenerator(style: .light)
                                    feedback.impactOccurred()
                                    updateQRPreview(logo: logo)
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
            Group {
                if logo == .none {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "11212D"))
                            .frame(width: 44, height: 44)
                        Image(systemName: "slash.circle")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "9BA8AB"))
                    }
                } else if logo == .custom {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "253745"))
                            .frame(width: 44, height: 44)
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    }
                } else if let brand = BrandType.match(from: logo.rawValue) {
                    BrandLogoView(brand: brand, size: 44, cornerRadius: 22)
                } else {
                    ZStack {
                        Circle()
                            .fill(logo.badgeBackgroundColor)
                            .frame(width: 44, height: 44)
                        if let icon = logo.systemIcon {
                            Image(systemName: icon)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .overlay(
                Circle()
                    .stroke(isSelected ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: isSelected ? 2.5 : 1)
                    .scaleEffect(1.15)
            )
            
            Text(logo.rawValue)
                .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
        }
    }
    
    // MARK: - Tab 3: Color Panel View
    private var colorPanelView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Color & Gradient Palette")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(QRColorTheme.allCases) { theme in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                updateQRPreview(color: theme)
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
                                                .stroke(styleConfig.colorTheme == theme ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: 3)
                                                .scaleEffect(1.2)
                                        )
                                    
                                    Text(theme.rawValue)
                                        .font(.system(size: 10, weight: styleConfig.colorTheme == theme ? .bold : .medium))
                                        .foregroundColor(styleConfig.colorTheme == theme ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
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
                            .foregroundColor(Color(hex: "9BA8AB"))
                        
                        TextField("Enter label (e.g. Scan Me)", text: $customLabelText)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "CCD0CF"))
                            .onChange(of: customLabelText) { newText in
                                updateQRPreview(text: newText)
                            }
                        
                        if !customLabelText.isEmpty {
                            Button(action: {
                                customLabelText = ""
                                updateQRPreview(text: "")
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color(hex: "9BA8AB"))
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(hex: "11212D"))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color(hex: "253745"), lineWidth: 1)
                    )
                    
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        customLabelText = ""
                        updateQRPreview(text: "")
                    }) {
                        Text("None")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(customLabelText.isEmpty ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(customLabelText.isEmpty ? Color(hex: "4A5C6A") : Color(hex: "253745"))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color(hex: "253745"), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                
                // Position Selector: Below / Above
                HStack(spacing: 12) {
                    Text("Position:")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        showTextAbove = false
                        updateQRPreview(textPositionAbove: false)
                    }) {
                        Text("Below QR")
                            .font(.system(size: 12, weight: !styleConfig.textPositionAbove ? .bold : .medium))
                            .foregroundColor(!styleConfig.textPositionAbove ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(!styleConfig.textPositionAbove ? Color(hex: "4A5C6A") : Color(hex: "253745")))
                            .overlay(
                                Capsule()
                                    .stroke(Color(hex: "253745"), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        showTextAbove = true
                        updateQRPreview(textPositionAbove: true)
                    }) {
                        Text("Above QR")
                            .font(.system(size: 12, weight: styleConfig.textPositionAbove ? .bold : .medium))
                            .foregroundColor(styleConfig.textPositionAbove ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(styleConfig.textPositionAbove ? Color(hex: "4A5C6A") : Color(hex: "253745")))
                            .overlay(
                                Capsule()
                                    .stroke(Color(hex: "253745"), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                
                // Font Selector
                VStack(alignment: .leading, spacing: 6) {
                    Text("Font Style:")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    HStack(spacing: 8) {
                        ForEach(QRTextFontOption.allCases) { opt in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                selectedFontOption = opt
                                updateQRPreview(textFont: opt.rawValue)
                            }) {
                                Text(opt.rawValue)
                                    .font(.system(size: 12, weight: styleConfig.textFont == opt.rawValue ? .bold : .medium, design: opt.fontDesign))
                                    .foregroundColor(styleConfig.textFont == opt.rawValue ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(styleConfig.textFont == opt.rawValue ? Color(hex: "4A5C6A") : Color(hex: "253745"))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color(hex: "253745"), lineWidth: 1)
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
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    HStack(spacing: 12) {
                        ForEach(["CCD0CF", "4A5C6A", "253745", "9BA8AB", "10B981", "EF4444"], id: \.self) { hex in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                selectedTextColorHex = hex
                                updateQRPreview(textColorHex: hex)
                            }) {
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Circle()
                                            .stroke(styleConfig.textColorHex == hex ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: 2.5)
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
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    HStack(spacing: 14) {
                        ForEach(QRDotStyle.allCases) { style in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                updateQRPreview(dotShape: style)
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(hex: "11212D"))
                                            .frame(width: 52, height: 52)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(styleConfig.dotStyle == style ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: 2)
                                            )
                                        
                                        styleDotPreview(style)
                                    }
                                    
                                    Text(style.rawValue)
                                        .font(.system(size: 11, weight: styleConfig.dotStyle == style ? .bold : .medium))
                                        .foregroundColor(styleConfig.dotStyle == style ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
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
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    HStack(spacing: 14) {
                        ForEach(QREyeStyle.allCases) { eye in
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                updateQRPreview(eyeStyle: eye)
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(hex: "11212D"))
                                            .frame(width: 52, height: 52)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(styleConfig.eyeStyle == eye ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: 2)
                                            )
                                        
                                        eyePreview(eye)
                                    }
                                    
                                    Text(eye.rawValue)
                                        .font(.system(size: 11, weight: styleConfig.eyeStyle == eye ? .bold : .medium))
                                        .foregroundColor(styleConfig.eyeStyle == eye ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                // Decorative Frame Style Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Decorative Frame")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(QRDecorativeFrame.allCases) { frame in
                                let isSelected = styleConfig.decorativeFrame == frame
                                Button(action: {
                                    let feedback = UIImpactFeedbackGenerator(style: .light)
                                    feedback.impactOccurred()
                                    updateQRPreview(decorativeFrame: frame)
                                }) {
                                    Text(frame.rawValue)
                                        .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                        .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(isSelected ? Color(hex: "4A5C6A") : Color(hex: "11212D"))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .stroke(isSelected ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: 1)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
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
        let col = Color(hex: "CCD0CF")
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
        let col = Color(hex: "CCD0CF")
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
                .fill(Color(hex: "253745"))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
            
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "10B981"))
                    .font(.system(size: 22))
                Text("Saved to Camera Roll & Library!")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "CCD0CF"))
            }
            .padding(.top, 4)
            
            // Image Preview
            if let img = renderedUIImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: Color.black.opacity(0.4), radius: 14, x: 0, y: 8)
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
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(hex: "4A5C6A"))
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
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(hex: "253745"))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                
                // Done Button
                Button(action: {
                    showExportSuccessModal = false
                    onBack()
                }) {
                    Text("Done")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .background(Color(hex: "11212D").ignoresSafeArea())
        .presentationDetents([.fraction(0.72), .large])
    }
}
