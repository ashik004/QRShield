import SwiftUI

public struct SpringCardButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.90 : 1.0)
            .animation(.spring(response: 0.22, dampingFraction: 0.92), value: configuration.isPressed)
    }
}

public struct TemplateCardView: View {
    public let template: QRTemplate
    public var onSelect: () -> Void
    
    @State private var qrImage: UIImage? = nil
    
    public init(template: QRTemplate, onSelect: @escaping () -> Void) {
        self.template = template
        self.onSelect = onSelect
    }
    
    private var activeQRImage: UIImage? {
        if let qrImage = qrImage {
            return qrImage
        }
        // Immediate synchronous fallback via cache so preview card never flashes
        return QRCodeGeneratorService.shared.generateQRCode(
            from: template.defaultContent,
            style: template.styleConfig,
            size: CGSize(width: 480, height: 480)
        )
    }
    
    public var body: some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
            onSelect()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // 1. Full-Card Clean Solid Pure White (#FFFFFF) Rounded Square Card (1/1 aspect ratio, 20px radius)
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                    
                    if let image = activeQRImage {
                        Image(uiImage: image)
                            .resizable()
                            .interpolation(.none)
                            .aspectRatio(contentMode: .fit)
                            .padding(13) // 12px–14px clean balanced padding: QR fills 80%–85% of the card
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color(hex: "253745"), lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(0.2),
                    radius: 8,
                    x: 0,
                    y: 3
                )
                
                // 2. Keep Bottom Label & Category Tag Directly Beneath the White QR Card
                HStack(spacing: 4) {
                    Text(template.name)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(template.category.rawValue)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: "253745"))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 2)
            }
        }
        .buttonStyle(SpringCardButtonStyle())
        .onAppear {
            if qrImage == nil {
                DispatchQueue.global(qos: .userInitiated).async {
                    let generated = QRCodeGeneratorService.shared.generateQRCode(
                        from: template.defaultContent,
                        style: template.styleConfig,
                        size: CGSize(width: 480, height: 480)
                    )
                    DispatchQueue.main.async {
                        self.qrImage = generated
                    }
                }
            }
        }
    }
}
