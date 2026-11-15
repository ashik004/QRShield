import SwiftUI
import PhotosUI

public struct CustomizeQRView: View {
    public let content: String
    public let contentType: QRContentType
    @State public var styleConfig: QRStyleConfig
    public var onBack: () -> Void
    public var onSaved: () -> Void
    
    @State private var activeTab: CustomizerTab = .style
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showSaveSuccessToast: Bool = false
    @State private var showShareSheet: Bool = false
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
        onBack: @escaping () -> Void,
        onSaved: @escaping () -> Void
    ) {
        self.content = content
        self.contentType = contentType
        self._styleConfig = State(initialValue: styleConfig)
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
                
                Text("Customize")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Color.clear.frame(width: 38, height: 38)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Central QR Preview Card
                    QRDisplayView(
                        content: content,
                        styleConfig: styleConfig,
                        size: 240
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
            
            // Bottom Save Button
            VStack(spacing: 0) {
                Button(action: saveQRCode) {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.down.to.line")
                            .font(.system(size: 16, weight: .bold))
                        Text("Save")
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
        .overlay(
            // Toast Notification
            Group {
                if showSaveSuccessToast {
                    VStack {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("QR Code Saved to My Codes & Photos!")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color(hex: "1F2937")))
                        .shadow(radius: 8)
                        .padding(.top, 50)
                        
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        )
    }
    
    private func tabButton(_ tab: CustomizerTab) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                activeTab = tab
            }
        }) {
            Text(tab.rawValue)
                .font(.system(size: 13, weight: activeTab == tab ? .bold : .medium))
                .foregroundColor(activeTab == tab ? .white : Color(hex: "4B5563"))
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(
                    activeTab == tab ?
                    Capsule().fill(Color.shieldPurple) :
                    nil
                )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Sub-Options Panels
    
    private var styleOptionsView: some View {
        HStack(spacing: 12) {
            ForEach(QRDotStyle.allCases) { style in
                Button(action: {
                    let feedback = UIImpactFeedbackGenerator(style: .light)
                    feedback.impactOccurred()
                    styleConfig.dotStyle = style
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: style.iconName)
                            .font(.system(size: 26))
                            .foregroundColor(styleConfig.dotStyle == style ? Color.shieldPurple : Color(hex: "6B7280"))
                        
                        Text(style.rawValue)
                            .font(.system(size: 11, weight: styleConfig.dotStyle == style ? .bold : .medium))
                            .foregroundColor(styleConfig.dotStyle == style ? Color.shieldPurple : Color(hex: "6B7280"))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(styleConfig.dotStyle == style ? Color(hex: "F3F0FF") : Color(hex: "F9FAFB"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(styleConfig.dotStyle == style ? Color.shieldPurple : Color(hex: "E5E7EB"), lineWidth: 1.5)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var colorOptionsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(QRColorTheme.allCases) { theme in
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        styleConfig.colorTheme = theme
                    }) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: theme.gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(styleConfig.colorTheme == theme ? Color.shieldPurple : Color.clear, lineWidth: 3)
                                    .scaleEffect(1.2)
                            )
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
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    styleConfig.customLogoData = data
                                    styleConfig.logoType = .custom
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
    
    private func saveQRCode() {
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        let title: String
        switch contentType {
        case .website: title = "Custom Link"
        case .wifi: title = "Custom Wi-Fi"
        case .contact: title = "Contact Card"
        case .social: title = "Social Profile"
        default: title = "\(contentType.rawValue) Code"
        }
        
        let item = QRCodeItem(
            title: title,
            contentPreview: String(content.prefix(32)),
            rawContent: content,
            contentType: contentType,
            category: contentType.category,
            createdAt: Date(),
            isFavorite: false,
            styleConfig: styleConfig
        )
        
        QRStorageService.shared.save(item: item)
        
        // Render and save to Photos
        if let image = QRCodeGeneratorService.shared.generateQRCode(from: content, style: styleConfig) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            renderedUIImage = image
        }
        
        withAnimation {
            showSaveSuccessToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation {
                showSaveSuccessToast = false
            }
            onSaved()
        }
    }
}
