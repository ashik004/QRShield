import SwiftUI

public struct SpringCardButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

public struct TemplateCardView: View {
    public let template: QRTemplate
    public var onSelect: () -> Void
    
    public init(template: QRTemplate, onSelect: @escaping () -> Void) {
        self.template = template
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
            onSelect()
        }) {
            VStack(alignment: .leading, spacing: 6) {
                // Scalable native SVG-accurate Template Card View
                QRTemplateCardView(
                    template: template,
                    cardWidth: 162
                )
                .shadow(
                    color: Color(hex: template.gradientHexColors.first ?? "6C5CE7").opacity(0.22),
                    radius: 8,
                    x: 0,
                    y: 4
                )
                
                // Title and category badge below the card
                HStack(spacing: 4) {
                    Text(template.name)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "1F2937"))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(template.category.rawValue)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color.shieldPurple)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.shieldPurple.opacity(0.1))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 4)
            }
        }
        .buttonStyle(SpringCardButtonStyle())
    }
}
