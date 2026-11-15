import SwiftUI

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
            ZStack {
                // Card Background
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: template.previewGradientHex.map { Color(hex: $0) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(hex: template.previewGradientHex.first ?? "6C5CE7").opacity(0.25), radius: 8, x: 0, y: 4)
                
                // Stylized QR pattern inside card
                ZStack {
                    // White QR dot pattern grid
                    VStack(spacing: 5) {
                        HStack {
                            cornerFinderEye
                            Spacer()
                            cornerFinderEye
                        }
                        
                        // Middle dots
                        HStack(spacing: 5) {
                            ForEach(0..<6) { _ in
                                Circle()
                                    .fill(Color.white.opacity(0.85))
                                    .frame(width: 5, height: 5)
                            }
                        }
                        
                        HStack {
                            cornerFinderEye
                            Spacer()
                            HStack(spacing: 4) {
                                Circle().fill(Color.white.opacity(0.85)).frame(width: 6, height: 6)
                                Circle().fill(Color.white.opacity(0.85)).frame(width: 6, height: 6)
                            }
                        }
                    }
                    .padding(18)
                    
                    // Central Badge / Logo / Banner
                    if let badge = template.badgeText {
                        // Badge style (like Black Friday % or SALE)
                        VStack {
                            Spacer()
                            Text(badge)
                                .font(.system(size: 13, weight: .black, design: .rounded))
                                .foregroundColor(template.id == "black_friday" ? Color(hex: "FBBF24") : .white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.55))
                                )
                                .padding(.bottom, 12)
                        }
                    } else if let iconName = template.styleConfig.logoType.systemIcon {
                        // Center icon badge
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 38, height: 38)
                                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: iconName)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(hex: template.previewGradientHex.first ?? "E1306C"))
                        }
                    }
                }
            }
            .frame(height: 140)
        }
        .buttonStyle(.plain)
    }
    
    private var cornerFinderEye: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 26, height: 26)
            
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white)
                .frame(width: 12, height: 12)
        }
    }
}
