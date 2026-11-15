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
            VStack(spacing: 8) {
                // Card Graphic Container
                ZStack {
                    // Card Background Gradient
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: template.previewGradientHex.map { Color(hex: $0) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color(hex: template.previewGradientHex.first ?? "6C5CE7").opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    // High-fidelity QR Code Design
                    qrGraphicLayer
                    
                    // Overlay Badges & Banners
                    overlayBadges
                }
                .frame(height: 145)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                // Template Title & Category Tag below the card
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
    
    // MARK: - Realistic Stylized QR Code Graphic Layer
    private var qrGraphicLayer: some View {
        ZStack {
            VStack(spacing: 4) {
                // Top Row: Finder Eyes + Modules
                HStack(spacing: 4) {
                    finderPattern
                    
                    VStack(spacing: 3) {
                        HStack(spacing: 3) {
                            moduleDot; moduleDot; moduleDot
                        }
                        HStack(spacing: 3) {
                            moduleDot; moduleDot; moduleDot
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    finderPattern
                }
                
                // Middle Row: Data Dots & Alignment
                HStack(spacing: 3) {
                    moduleDot; moduleDot; moduleDot; moduleDot
                    Spacer()
                    moduleDot; moduleDot; moduleDot; moduleDot
                }
                .padding(.horizontal, 2)
                
                // Bottom Row: Finder Eye + Dense Modules
                HStack(spacing: 4) {
                    finderPattern
                    
                    VStack(spacing: 3) {
                        HStack(spacing: 3) {
                            moduleDot; moduleDot; moduleDot; moduleDot
                        }
                        HStack(spacing: 3) {
                            moduleDot; moduleDot; moduleDot; moduleDot
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Small Alignment Pattern
                    ZStack {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.white.opacity(0.9), lineWidth: 2)
                            .frame(width: 14, height: 14)
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .padding(16)
            
            // Central Logo if enabled
            if template.badgePosition == .centerLogo {
                if let iconName = template.styleConfig.logoType.systemIcon {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 38, height: 38)
                            .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 2)
                        
                        Image(systemName: iconName)
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(Color(hex: template.previewGradientHex.first ?? "6C5CE7"))
                    }
                } else if let badge = template.badgeText {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 36, height: 36)
                            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
                        
                        Text(badge)
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: template.previewGradientHex.first ?? "111827"))
                    }
                }
            }
        }
    }
    
    // Position Detection Finder Eye (7x7 module standard)
    private var finderPattern: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color.white.opacity(0.95), lineWidth: 3.5)
                .frame(width: 28, height: 28)
            
            RoundedRectangle(cornerRadius: 2.5, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .frame(width: 12, height: 12)
        }
    }
    
    // Single Data Module Dot based on dot style
    private var moduleDot: some View {
        Group {
            switch template.styleConfig.dotStyle {
            case .square:
                Rectangle()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 4.5, height: 4.5)
            case .rounded:
                RoundedRectangle(cornerRadius: 1.8)
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 4.5, height: 4.5)
            case .circular:
                Circle()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 4.5, height: 4.5)
            case .diamond:
                Rectangle()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 4, height: 4)
                    .rotationEffect(.degrees(45))
            }
        }
    }
    
    // MARK: - Distinct Badges, Ribbons & Banner Overlays
    @ViewBuilder
    private var overlayBadges: some View {
        switch template.badgePosition {
        case .bannerLeft:
            if let badge = template.badgeText {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(badge)
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: template.accentColorHex))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.75))
                    )
                    .padding(.leading, 12)
                    
                    Spacer()
                }
            }
            
        case .badgeTop:
            if let badge = template.badgeText {
                VStack {
                    Text(badge)
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: template.accentColorHex))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3.5)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.65))
                                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 0.8))
                        )
                        .padding(.top, 10)
                    Spacer()
                }
            }
            
        case .badgeBottom:
            if let badge = template.badgeText {
                VStack {
                    Spacer()
                    Text(badge)
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: template.accentColorHex))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.65))
                                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 0.8))
                        )
                        .padding(.bottom, 10)
                }
            }
            
        case .ribbon:
            if let badge = template.badgeText {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(badge)
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: template.accentColorHex))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "FBBF24"), Color(hex: "F59E0B")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(radius: 4)
                            )
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                    }
                }
            }
            
        case .centerLogo:
            EmptyView()
        }
    }
}
