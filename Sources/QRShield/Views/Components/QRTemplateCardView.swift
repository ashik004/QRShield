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
    public var qrImage: UIImage?
    public var content: String?
    public var customFooterText: String?
    public var cardWidth: CGFloat
    
    @State private var dynamicQRImage: UIImage? = nil
    
    public init(
        template: QRTemplate,
        qrImage: UIImage? = nil,
        content: String? = nil,
        customFooterText: String? = nil,
        cardWidth: CGFloat = 344
    ) {
        self.template = template
        self.qrImage = qrImage
        self.content = content
        self.customFooterText = customFooterText
        self.cardWidth = cardWidth
    }
    
    private var activeQRImage: UIImage? {
        qrImage ?? dynamicQRImage
    }
    
    public var body: some View {
        let s = cardWidth / 360.0
        let totalHeight = 420.0 * s
        
        ZStack(alignment: .topLeading) {
            // 1. Rounded Card Background Container: x=8, y=8, w=344, h=404, rx=30
            RoundedRectangle(cornerRadius: 30 * s, style: .continuous)
                .fill(template.linearGradient)
                .frame(width: 344 * s, height: 404 * s)
                .offset(x: 8 * s, y: 8 * s)
            
            // 2. Translucent Background Circles (opacity 0.08)
            // Top-right circle: cx=325, cy=55, r=86
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 172 * s, height: 172 * s)
                .position(x: 325 * s, y: 55 * s)
            
            // Bottom-left circle: cx=28, cy=365, r=105
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 210 * s, height: 210 * s)
                .position(x: 28 * s, y: 365 * s)
            
            // 3. Bottom Shine Wave Overlay
            SVGShineWaveShape()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.30), Color.white.opacity(0.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 360 * s, height: 420 * s)
            
            // 4. Top-Left Pill Badge: x=26, y=26, h=28, rx=14
            HStack(spacing: 5 * s) {
                Image(systemName: template.categoryIcon)
                    .font(.system(size: 11 * s, weight: .bold))
                    .foregroundColor(.white)
                
                Text(template.categoryLabel.uppercased())
                    .font(.system(size: 11 * s, weight: .bold))
                    .tracking(1.5 * s)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14 * s)
            .frame(height: 28 * s)
            .background(
                Capsule().fill(Color.white.opacity(0.20))
            )
            .offset(x: 26 * s, y: 26 * s)
            
            // 5. Header Title & Subtitle Texts
            VStack(alignment: .leading, spacing: 3 * s) {
                Text(template.title)
                    .font(.system(size: 26 * s, weight: .heavy))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(template.subtitle.uppercased())
                    .font(.system(size: 11 * s, weight: .semibold))
                    .tracking(1.2 * s)
                    .foregroundColor(Color.white.opacity(0.88))
                    .lineLimit(1)
            }
            .offset(x: 26 * s, y: 66 * s)
            
            // 6. Central White Rounded Container: x=55, y=139, w=250, h=224, rx=24
            ZStack {
                RoundedRectangle(cornerRadius: 24 * s, style: .continuous)
                    .fill(Color.white)
                    .shadow(
                        color: Color(hex: "111827").opacity(0.18),
                        radius: 10 * s,
                        x: 0,
                        y: 8 * s
                    )
                
                // Dynamic QR Code Graphic Layer (Inner area 196x196)
                if let image = activeQRImage {
                    Image(uiImage: image)
                        .resizable()
                        .interpolation(.none)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 196 * s, height: 196 * s)
                } else {
                    ProgressView()
                        .frame(width: 196 * s, height: 196 * s)
                }
                
                // 7. Center Circular Gradient Badge: cx=180, cy=251
                ZStack {
                    // Outer white circle with accent stroke
                    Circle()
                        .fill(Color.white)
                        .frame(width: 54 * s, height: 54 * s)
                        .overlay(
                            Circle()
                                .stroke(template.accentColor, lineWidth: 4 * s)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 4 * s, x: 0, y: 2 * s)
                    
                    // Inner gradient circle
                    Circle()
                        .fill(template.linearGradient)
                        .frame(width: 40 * s, height: 40 * s)
                    
                    // Category / Template SF Symbol icon
                    Image(systemName: template.categoryIcon)
                        .font(.system(size: 17 * s, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 250 * s, height: 224 * s)
            .offset(x: 55 * s, y: 139 * s)
            
            // 8. Bottom Pill Bar: x=91, y=369, w=178, h=27, rx=13.5
            HStack {
                Text((customFooterText ?? template.footerText).uppercased())
                    .font(.system(size: 10 * s, weight: .bold))
                    .tracking(1.4 * s)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 178 * s, height: 27 * s)
            .background(
                Capsule().fill(Color.white.opacity(0.20))
            )
            .offset(x: 91 * s, y: 369 * s)
        }
        .frame(width: 360 * s, height: totalHeight)
        .clipShape(RoundedRectangle(cornerRadius: 30 * s, style: .continuous))
        .onAppear {
            generateDynamicQR()
        }
        .onChange(of: content) { _ in
            generateDynamicQR()
        }
    }
    
    private func generateDynamicQR() {
        if qrImage != nil { return }
        let payload = content ?? template.defaultContent
        
        // Generate high-resolution styled QR
        let generated = QRCodeGeneratorService.shared.generateQRCode(
            from: payload,
            style: template.styleConfig,
            size: CGSize(width: 600, height: 600)
        )
        DispatchQueue.main.async {
            self.dynamicQRImage = generated
        }
    }
}

// MARK: - High-Resolution ImageRenderer Export Extension
@MainActor
public extension QRTemplateCardView {
    /// Renders the card as a high-resolution UIImage ready for saving to Photos or sharing
    func renderAsImage(scale: CGFloat = 3.0) -> UIImage? {
        let renderView = QRTemplateCardView(
            template: self.template,
            qrImage: self.activeQRImage,
            content: self.content,
            customFooterText: self.customFooterText,
            cardWidth: 360
        )
        let renderer = ImageRenderer(content: renderView)
        renderer.scale = scale
        renderer.proposedSize = ProposedViewSize(width: 360, height: 420)
        renderer.isOpaque = false
        return renderer.uiImage
    }
}

/// Standalone Exporter Utility
@MainActor
public struct QRTemplateExporter {
    public static func renderCard(
        template: QRTemplate,
        qrImage: UIImage? = nil,
        content: String? = nil,
        customFooterText: String? = nil,
        scale: CGFloat = 3.0
    ) -> UIImage? {
        let view = QRTemplateCardView(
            template: template,
            qrImage: qrImage,
            content: content,
            customFooterText: customFooterText,
            cardWidth: 360
        )
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        renderer.proposedSize = ProposedViewSize(width: 360, height: 420)
        renderer.isOpaque = false
        return renderer.uiImage
    }
}
