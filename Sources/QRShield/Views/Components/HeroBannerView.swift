import SwiftUI

public struct HeroBannerView: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "EDE9FE").opacity(0.8),
                            Color(hex: "E0E7FF").opacity(0.6),
                            Color(hex: "F3F4F6").opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
                )
                .shadow(color: Color(hex: "6C5CE7").opacity(0.08), radius: 12, x: 0, y: 6)
            
            HStack(spacing: 12) {
                // Left Text Column
                VStack(alignment: .leading, spacing: 6) {
                    Text("Create, Scan & Stay Safe")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "111827"))
                        .lineLimit(2)
                    
                    Text("Generate stylish QR codes, scan instantly, and check links for safety.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "6B7280"))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right 3D QR Code & Shield Graphic
                ZStack {
                    // Isometric tilted QR card
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "E0F2FE"), Color(hex: "BAE6FD")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 82, height: 82)
                        .rotationEffect(.degrees(10))
                        .shadow(color: Color(hex: "0284C7").opacity(0.2), radius: 8, x: 2, y: 4)
                        .overlay(
                            // Stylized QR pattern lines
                            VStack(spacing: 4) {
                                HStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 2).frame(width: 14, height: 14)
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 2).frame(width: 14, height: 14)
                                }
                                HStack(spacing: 3) {
                                    Circle().frame(width: 6, height: 6)
                                    Circle().frame(width: 6, height: 6)
                                    Circle().frame(width: 6, height: 6)
                                }
                                HStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 2).frame(width: 14, height: 14)
                                    Spacer()
                                    Circle().frame(width: 8, height: 8)
                                }
                            }
                            .foregroundColor(Color(hex: "0284C7"))
                            .padding(8)
                            .rotationEffect(.degrees(10))
                        )
                    
                    // Floating Glowing Teal Shield Badge
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "2DD4BF"), Color(hex: "0D9488")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 34, height: 34)
                            .shadow(color: Color(hex: "14B8A6").opacity(0.5), radius: 6, x: 0, y: 3)
                        
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 20, y: 22)
                }
                .frame(width: 95, height: 95)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .frame(height: 125)
    }
}
