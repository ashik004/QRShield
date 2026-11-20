import SwiftUI

public struct QRDisplayView: View {
    public let content: String
    public let styleConfig: QRStyleConfig
    public var size: CGFloat = 260
    
    @State private var qrImage: UIImage? = nil
    
    public init(content: String, styleConfig: QRStyleConfig, size: CGFloat = 260) {
        self.content = content
        self.styleConfig = styleConfig
        self.size = size
    }
    
    private var activeImage: UIImage? {
        if let qrImage = qrImage {
            return qrImage
        }
        // Immediate synchronous fallback so it NEVER shows a blank state!
        return QRCodeGeneratorService.shared.generateQRCode(
            from: content,
            style: styleConfig,
            size: CGSize(width: size * 3, height: size * 3)
        )
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Card container: clean solid white rounded square card
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(hex: styleConfig.backgroundColorHex))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(
                                styleConfig.frameStyle == .neonGlow
                                    ? Color.shieldPurple
                                    : (styleConfig.frameStyle == .cardBorder ? Color(hex: "1F2937") : Color(hex: "E2E8F0")),
                                lineWidth: styleConfig.frameStyle == .none ? 1 : 2.5
                            )
                    )
                    .shadow(
                        color: styleConfig.frameStyle == .neonGlow
                            ? Color.shieldPurple.opacity(0.35)
                            : Color.black.opacity(0.06),
                        radius: 10,
                        x: 0,
                        y: 4
                    )
                
                if let image = activeImage {
                    Image(uiImage: image)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .padding(16) // Balanced 14px-16px padding so styled QR fills 80%–85% of card
                } else {
                    ProgressView()
                        .tint(Color.shieldPurple)
                }
            }
            .frame(width: size, height: size)
            
            // Frame Bottom Banner
            if styleConfig.frameStyle == .scanMeBottom {
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
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .offset(y: -12)
                .zIndex(2)
            }
        }
        .onAppear {
            renderQR()
        }
        .onChange(of: content) { _ in
            renderQR()
        }
        .onChange(of: styleConfig) { _ in
            renderQR()
        }
    }
    
    private func renderQR() {
        let gen = QRCodeGeneratorService.shared
        let rendered = gen.generateQRCode(from: content, style: styleConfig, size: CGSize(width: size * 3, height: size * 3))
        self.qrImage = rendered
    }
}
