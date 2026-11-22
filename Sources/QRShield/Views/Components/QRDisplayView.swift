import SwiftUI

public struct QRDisplayView: View {
    public let content: String
    public let styleConfig: QRStyleConfig
    public var previewImage: UIImage? = nil
    public var size: CGFloat = 260
    
    public init(
        content: String,
        styleConfig: QRStyleConfig,
        previewImage: UIImage? = nil,
        size: CGFloat = 260
    ) {
        self.content = content
        self.styleConfig = styleConfig
        self.previewImage = previewImage
        self.size = size
    }
    
    private var activeImage: UIImage? {
        if let previewImage = previewImage {
            return previewImage
        }
        // Direct synchronous generation / cache lookup with ZERO stale state delay
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
                                    ? Color(hex: "4A5C6A")
                                    : (styleConfig.frameStyle == .cardBorder ? Color(hex: "4A5C6A") : Color(hex: "253745")),
                                lineWidth: styleConfig.frameStyle == .none ? 1 : 2.5
                            )
                    )
                    .shadow(
                        color: styleConfig.frameStyle == .neonGlow
                            ? Color(hex: "4A5C6A").opacity(0.4)
                            : Color.black.opacity(0.1),
                        radius: 10,
                        x: 0,
                        y: 4
                    )
                
                VStack(spacing: 4) {
                    // Custom text label inside card (Above QR)
                    if styleConfig.textPositionAbove,
                       let text = styleConfig.customText,
                       !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(text)
                            .font(customFont(size: 13, style: styleConfig.textFont))
                            .foregroundColor(Color(hex: styleConfig.textColorHex))
                            .lineLimit(1)
                            .padding(.horizontal, 10)
                            .padding(.top, 4)
                            .transition(.opacity)
                    }
                    
                    if let image = activeImage {
                        Image(uiImage: image)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .padding(styleConfig.decorativeFrame != .none ? 0 : (styleConfig.hasCustomText ? 6 : 14))
                    } else {
                        ProgressView()
                            .tint(Color.shieldPurple)
                    }
                    
                    // Custom text label inside card (Below QR)
                    if !styleConfig.textPositionAbove,
                       let text = styleConfig.customText,
                       !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(text)
                            .font(customFont(size: 13, style: styleConfig.textFont))
                            .foregroundColor(Color(hex: styleConfig.textColorHex))
                            .lineLimit(1)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 4)
                            .transition(.opacity)
                    }
                }
                .padding(styleConfig.decorativeFrame != .none ? 0 : 8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .frame(width: size, height: size)
            
            // Frame Bottom Banner
            if styleConfig.frameStyle == .scanMeBottom {
                HStack(spacing: 6) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 13, weight: .bold))
                    Text("SCAN ME")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                }
                .foregroundColor(Color(hex: "CCD0CF"))
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color(hex: "4A5C6A"))
                )
                .offset(y: -12)
                .zIndex(2)
            }
        }
    }
    
    private func customFont(size: CGFloat, style: String) -> Font {
        switch style {
        case "Rounded":
            return .system(size: size, weight: .bold, design: .rounded)
        case "Serif":
            return .system(size: size, weight: .bold, design: .serif)
        case "Mono":
            return .system(size: size, weight: .bold, design: .monospaced)
        default:
            return .system(size: size, weight: .bold, design: .default)
        }
    }
}
