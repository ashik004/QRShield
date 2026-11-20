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

public struct CustomizeQRView: View {
    public let content: String
    public let contentType: QRContentType
    @State public var styleConfig: QRStyleConfig
    public var selectedTemplate: QRTemplate?
    public var onBack: () -> Void
    public var onSaved: () -> Void
    
    @State private var activeTab: CustomizerTab = .style
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showShareSheet: Bool = false
    @State private var showExportSuccessModal: Bool = false
    @State private var renderedUIImage: UIImage? = nil
    
    public enum CustomizerTab: String, CaseIterable, Identifiable {
        case style = "Style"
        case color = "Color"
        case logo = "Logo"
        case frame = "Frame"
        
        public var id: String { rawValue }
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
        self._styleConfig = State(initialValue: selectedTemplate?.styleConfig ?? styleConfig)
        self.selectedTemplate = selectedTemplate
        self.onBack = onBack
        self.onSaved = onSaved
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "1F2937"))
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(selectedTemplate != nil ? selectedTemplate!.name : "Customize")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Button(action: {
                    let feedback = UIImpactFeedbackGenerator(style: .light)
                    feedback.impactOccurred()
                    exportAndShare()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.shieldPurple)
                        .frame(width: 38, height: 38)
                        .background(Color.shieldPurple.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Central QR Preview Card: Clean Solid White Card matching Template Previews
                    QRDisplayView(
                        content: content,
                        styleConfig: styleConfig,
                        size: 260
                    )
                    .padding(.top, 10)
                    
                    // Segmented Tabs: [ Style | Color | Logo | Frame ]
                    HStack(spacing: 8) {
                        ForEach(CustomizerTab.allCases) { tab in
                            tabButton(tab)
                        }
                    }
                    .padding(4)
                    .background(Color(hex: "F3F4F6"))
                    .clipShape(Capsule())
                    .padding(.horizontal, 20)
                    
                    // Sub-options panel
                    Group {
                        switch activeTab {
                        case .style:
                            styleOptionsView
                        case .color:
                            colorOptionsView
                        case .logo:
                            logoOptionsView
                        case .frame:
                            frameOptionsView
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 90)
                    
                    Spacer(minLength: 20)
                }
            }
            
            // Bottom Save & Export Button
            VStack(spacing: 0) {
                Button(action: saveQRCode) {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.down.to.line")
                            .font(.system(size: 16, weight: .bold))
                        Text("Save & Export")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: Color.shieldPurple.opacity(0.35), radius: 10, x: 0, y: 5)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color.white.shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: -4))
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
                    .background(Color.shieldPurple)
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
                    .foregroundColor(Color.shieldPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.shieldPurple.opacity(0.1))
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
    
    // MARK: - Tab Button Component
    private func tabButton(_ tab: CustomizerTab) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                activeTab = tab
            }
        }) {
            Text(tab.rawValue)
                .font(.system(size: 13, weight: activeTab == tab ? .bold : .medium))
                .foregroundColor(activeTab == tab ? .white : Color(hex: "6B7280"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(activeTab == tab ? Color.shieldPurple : Color.clear)
                )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Options Panels
    private var styleOptionsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(QRDotStyle.allCases) { style in
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        styleConfig.dotStyle = style
                    }) {
                        VStack(spacing: 6) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(styleConfig.dotStyle == style ? Color.shieldPurple.opacity(0.12) : Color(hex: "F3F4F6"))
                                    .frame(width: 52, height: 52)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(styleConfig.dotStyle == style ? Color.shieldPurple : Color.clear, lineWidth: 2)
                                    )
                                
                                styleDotPreview(style)
                            }
                            
                            Text(style.rawValue)
                                .font(.system(size: 11, weight: styleConfig.dotStyle == style ? .bold : .medium))
                                .foregroundColor(styleConfig.dotStyle == style ? Color.shieldPurple : Color(hex: "4B5563"))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
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
    
    private var colorOptionsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(QRColorTheme.allCases) { theme in
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        styleConfig.colorTheme = theme
                    }) {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: theme.hexColors.map { Color(hex: $0) },
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(styleConfig.colorTheme == theme ? Color.shieldPurple : Color.clear, lineWidth: 3)
                                        .scaleEffect(1.2)
                                )
                            
                            Text(theme.rawValue)
                                .font(.system(size: 10, weight: styleConfig.colorTheme == theme ? .bold : .medium))
                                .foregroundColor(styleConfig.colorTheme == theme ? Color.shieldPurple : Color(hex: "6B7280"))
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
    }
    
    private var logoOptionsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(QRLogoType.allCases) { logo in
                    if logo == .custom {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            logoBadge(for: logo)
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
                            logoBadge(for: logo)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
    }
    
    private func logoBadge(for logo: QRLogoType) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(logo == .none ? Color(hex: "F3F4F6") : logo.badgeBackgroundColor)
                    .frame(width: 42, height: 42)
                
                if let icon = logo.systemIcon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(logo == .none ? Color(hex: "9CA3AF") : .white)
                } else {
                    Image(systemName: "slash.circle")
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
            }
            .overlay(
                Circle()
                    .stroke(styleConfig.logoType == logo ? Color.shieldPurple : Color.clear, lineWidth: 2.5)
                    .scaleEffect(1.15)
            )
            
            Text(logo.rawValue)
                .font(.system(size: 10, weight: styleConfig.logoType == logo ? .bold : .medium))
                .foregroundColor(styleConfig.logoType == logo ? Color.shieldPurple : Color(hex: "6B7280"))
        }
    }
    
    private var frameOptionsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(QRFrameStyle.allCases) { frame in
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        styleConfig.frameStyle = frame
                    }) {
                        Text(frame.rawValue)
                            .font(.system(size: 12, weight: styleConfig.frameStyle == frame ? .bold : .medium))
                            .foregroundColor(styleConfig.frameStyle == frame ? .white : Color(hex: "4B5563"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(styleConfig.frameStyle == frame ? Color.shieldPurple : Color(hex: "F3F4F6"))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
    }
    
    private func exportAndShare() {
        renderedUIImage = QRCodeGeneratorService.shared.generateQRCode(
            from: content,
            style: styleConfig,
            size: CGSize(width: 1024, height: 1024)
        )
        
        if renderedUIImage != nil {
            showShareSheet = true
        }
    }
    
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
        
        // Export High-Resolution UIImage using QRCodeGeneratorService
        let exportedImage = QRCodeGeneratorService.shared.generateQRCode(
            from: content,
            style: styleConfig,
            size: CGSize(width: 1024, height: 1024)
        )
        
        if let cardImage = exportedImage {
            UIImageWriteToSavedPhotosAlbum(cardImage, nil, nil, nil)
            renderedUIImage = cardImage
        }
        
        // Immediately present the export sheet so the user sees the rendered QR code with no blank screen!
        showExportSuccessModal = true
    }
}
