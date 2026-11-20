import SwiftUI

/// Exact SVG shine wave curve matching SVG path: M8 245 Q110 190 210 250 T352 225 V412 H8Z
public struct SVGShineWaveShape: Shape {
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        let sx = rect.width / 360.0
        let sy = rect.height / 420.0
        
        var path = Path()
        path.move(to: CGPoint(x: 8 * sx, y: 245 * sy))
        
        // Q110 190 210 250
        path.addQuadCurve(
            to: CGPoint(x: 210 * sx, y: 250 * sy),
            control: CGPoint(x: 110 * sx, y: 190 * sy)
        )
        
        // T352 225: Smooth quadratic reflection of (110, 190) across (210, 250) -> (310, 310)
        path.addQuadCurve(
            to: CGPoint(x: 352 * sx, y: 225 * sy),
            control: CGPoint(x: 310 * sx, y: 310 * sy)
        )
        
        path.addLine(to: CGPoint(x: 352 * sx, y: 412 * sy))
        path.addLine(to: CGPoint(x: 8 * sx, y: 412 * sy))
        path.closeSubpath()
        return path
    }
}

/// Scalable native SwiftUI QR Template Card based on SVG architecture
public struct QRTemplateCardView: View {
    public let template: QRTemplate
    public var styleConfig: QRStyleConfig?
    public var qrImage: UIImage?
    public var content: String?
    public var customFooterText: String?
    public var cardWidth: CGFloat
    
    @State private var dynamicQRImage: UIImage? = nil
    
    public init(
        template: QRTemplate,
        styleConfig: QRStyleConfig? = nil,
        qrImage: UIImage? = nil,
        content: String? = nil,
        customFooterText: String? = nil,
        cardWidth: CGFloat = 344
    ) {
        self.template = template
        self.styleConfig = styleConfig
        self.qrImage = qrImage
        self.content = content
        self.customFooterText = customFooterText
        self.cardWidth = cardWidth
    }
    
    private var effectiveStyle: QRStyleConfig {
        styleConfig ?? template.styleConfig
    }
    
    private var effectiveContent: String {
        if let text = content, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return text
        }
        return template.defaultContent
    }
    
    private var effectiveGradient: LinearGradient {
        if let customStyle = styleConfig, customStyle.colorTheme != template.styleConfig.colorTheme {
            return LinearGradient(
                colors: customStyle.colorTheme.hexColors.map { Color(hex: $0) },
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return template.linearGradient
    }
    
    private var effectiveAccentColor: Color {
        if let customStyle = styleConfig, customStyle.colorTheme != template.styleConfig.colorTheme,
           let firstHex = customStyle.colorTheme.hexColors.first {
            return Color(hex: firstHex)
        }
        return template.accentColor
    }
    
    private var activeQRImage: UIImage? {
        if let qrImage = qrImage {
            return qrImage
        }
        if let dynamicQRImage = dynamicQRImage {
            return dynamicQRImage
        }
        // Guaranteed synchronous fallback so activeQRImage is NEVER nil!
        return QRCodeGeneratorService.shared.generateQRCode(
            from: effectiveContent,
            style: effectiveStyle,
            size: CGSize(width: 800, height: 800)
        )
    }
    
    public var body: some View {
        let size = cardWidth
        
        VStack(spacing: 0) {
            ZStack {
                // Clean Solid Pure White Rounded Square Card (1/1 aspect ratio, 22px radius)
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(hex: effectiveStyle.backgroundColorHex))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(
                                effectiveStyle.frameStyle == .neonGlow
                                    ? Color.shieldPurple
                                    : (effectiveStyle.frameStyle == .cardBorder ? Color(hex: "1F2937") : Color(hex: "E2E8F0")),
                                lineWidth: effectiveStyle.frameStyle == .none ? 1 : 2.5
                            )
                    )
                    .shadow(
                        color: effectiveStyle.frameStyle == .neonGlow
                            ? Color.shieldPurple.opacity(0.35)
                            : Color.black.opacity(0.06),
                        radius: 10,
                        x: 0,
                        y: 4
                    )
                
                if let image = activeQRImage {
                    Image(uiImage: image)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .padding(size * 0.075) // Fills 80%–85% with balanced padding around it
                }
            }
            .frame(width: size, height: size)
            
            // Frame Bottom Banner if selected
            if effectiveStyle.frameStyle == .scanMeBottom {
                HStack(spacing: 6) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 13, weight: .bold))
                    Text("SCAN ME")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(effectiveGradient)
                )
                .offset(y: -12)
                .zIndex(2)
            }
        }
        .onAppear {
            generateDynamicQR()
        }
        .onChange(of: content) { _ in
            generateDynamicQR()
        }
        .onChange(of: styleConfig) { _ in
            generateDynamicQR()
        }
    }
    
    // MARK: - Frame Styling Helpers
    @ViewBuilder
    private func frameBorderOverlay(s: CGFloat) -> some View {
        switch effectiveStyle.frameStyle {
        case .none:
            EmptyView()
        case .cardBorder:
            RoundedRectangle(cornerRadius: 24 * s, style: .continuous)
                .stroke(Color(hex: "1F2937"), lineWidth: 3 * s)
        case .neonGlow:
            RoundedRectangle(cornerRadius: 24 * s, style: .continuous)
                .stroke(effectiveAccentColor, lineWidth: 3.5 * s)
        case .scanMeBottom:
            RoundedRectangle(cornerRadius: 24 * s, style: .continuous)
                .stroke(effectiveAccentColor.opacity(0.4), lineWidth: 2 * s)
        case .modernBracket:
            TechBracketsOverlay(s: s, color: effectiveAccentColor)
        }
    }
    
    private var frameShadowColor: Color {
        if effectiveStyle.frameStyle == .neonGlow {
            return effectiveAccentColor.opacity(0.65)
        }
        return Color(hex: "111827").opacity(0.18)
    }
    
    private func frameShadowRadius(s: CGFloat) -> CGFloat {
        if effectiveStyle.frameStyle == .neonGlow {
            return 16 * s
        }
        return 10 * s
    }
    
    private func generateDynamicQR() {
        if qrImage != nil { return }
        
        let generated = QRCodeGeneratorService.shared.generateQRCode(
            from: effectiveContent,
            style: effectiveStyle,
            size: CGSize(width: 800, height: 800)
        )
        self.dynamicQRImage = generated
    }
}

/// Tech corner brackets frame overlay
public struct TechBracketsOverlay: View {
    public let s: CGFloat
    public let color: Color
    
    public init(s: CGFloat, color: Color) {
        self.s = s
        self.color = color
    }
    
    public var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let arm: CGFloat = 20 * s
            let lw: CGFloat = 3 * s
            
            Path { path in
                // Top-Left
                path.move(to: CGPoint(x: 10 * s, y: 10 * s + arm))
                path.addLine(to: CGPoint(x: 10 * s, y: 10 * s))
                path.addLine(to: CGPoint(x: 10 * s + arm, y: 10 * s))
                
                // Top-Right
                path.move(to: CGPoint(x: w - 10 * s - arm, y: 10 * s))
                path.addLine(to: CGPoint(x: w - 10 * s, y: 10 * s))
                path.addLine(to: CGPoint(x: w - 10 * s, y: 10 * s + arm))
                
                // Bottom-Left
                path.move(to: CGPoint(x: 10 * s, y: h - 10 * s - arm))
                path.addLine(to: CGPoint(x: 10 * s, y: h - 10 * s))
                path.addLine(to: CGPoint(x: 10 * s + arm, y: h - 10 * s))
                
                // Bottom-Right
                path.move(to: CGPoint(x: w - 10 * s - arm, y: h - 10 * s))
                path.addLine(to: CGPoint(x: w - 10 * s, y: h - 10 * s))
                path.addLine(to: CGPoint(x: w - 10 * s, y: h - 10 * s - arm))
            }
            .stroke(color, lineWidth: lw)
        }
    }
}

// MARK: - High-Resolution ImageRenderer Export Extension
@MainActor
public extension QRTemplateCardView {
    /// Renders the card as a high-resolution UIImage ready for saving to Photos or sharing
    func renderAsImage(scale: CGFloat = 3.0) -> UIImage? {
        let payload = effectiveContent
        let style = effectiveStyle
        let nonNilQR = activeQRImage ?? QRCodeGeneratorService.shared.generateQRCode(
            from: payload,
            style: style,
            size: CGSize(width: 800, height: 800)
        )
        
        let renderView = QRTemplateCardView(
            template: self.template,
            styleConfig: style,
            qrImage: nonNilQR,
            content: payload,
            customFooterText: self.customFooterText,
            cardWidth: 360
        )
        let renderer = ImageRenderer(content: renderView)
        renderer.scale = scale
        renderer.proposedSize = ProposedViewSize(width: 360, height: 360)
        renderer.isOpaque = false
        return renderer.uiImage
    }
}

/// Standalone Exporter Utility
@MainActor
public struct QRTemplateExporter {
    public static func renderCard(
        template: QRTemplate,
        styleConfig: QRStyleConfig? = nil,
        qrImage: UIImage? = nil,
        content: String? = nil,
        customFooterText: String? = nil,
        scale: CGFloat = 3.0
    ) -> UIImage? {
        let payload = (content?.isEmpty == false ? content! : template.defaultContent)
        let effectiveStyle = styleConfig ?? template.styleConfig
        
        // 1. Pre-render non-nil QR image to guarantee ImageRenderer never captures a blank container
        let nonNilQR = qrImage ?? QRCodeGeneratorService.shared.generateQRCode(
            from: payload,
            style: effectiveStyle,
            size: CGSize(width: 800, height: 800)
        )
        
        // 2. Instantiate view with guaranteed non-nil QR image
        let view = QRTemplateCardView(
            template: template,
            styleConfig: effectiveStyle,
            qrImage: nonNilQR,
            content: payload,
            customFooterText: customFooterText,
            cardWidth: 360
        )
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        renderer.proposedSize = ProposedViewSize(width: 360, height: 360)
        renderer.isOpaque = false
        return renderer.uiImage
    }
}
