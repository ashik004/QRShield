import SwiftUI

public struct HomeView: View {
    public var onNavigateToGenerate: () -> Void
    public var onNavigateToScan: () -> Void
    public var onNavigateToTemplates: () -> Void
    public var onSelectTemplate: ((QRTemplate) -> Void)?
    public var onNavigateToMyCodes: (() -> Void)?
    public var onNavigateToHistory: (() -> Void)?
    public var onNavigateToFavorites: (() -> Void)?
    public var onOpenPro: () -> Void
    
    public init(
        onNavigateToGenerate: @escaping () -> Void,
        onNavigateToScan: @escaping () -> Void,
        onNavigateToTemplates: @escaping () -> Void,
        onSelectTemplate: ((QRTemplate) -> Void)? = nil,
        onNavigateToMyCodes: (() -> Void)? = nil,
        onNavigateToHistory: (() -> Void)? = nil,
        onNavigateToFavorites: (() -> Void)? = nil,
        onOpenPro: @escaping () -> Void
    ) {
        self.onNavigateToGenerate = onNavigateToGenerate
        self.onNavigateToScan = onNavigateToScan
        self.onNavigateToTemplates = onNavigateToTemplates
        self.onSelectTemplate = onSelectTemplate
        self.onNavigateToMyCodes = onNavigateToMyCodes
        self.onNavigateToHistory = onNavigateToHistory
        self.onNavigateToFavorites = onNavigateToFavorites
        self.onOpenPro = onOpenPro
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Top App Bar
                HStack {
                    HStack(spacing: 10) {
                        // App Shield Icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 34, height: 34)
                                .shadow(color: Color.shieldPurple.opacity(0.3), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("QR Shield")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "111827"))
                    }
                    
                    Spacer()
                    
                    // Crown Pro Button
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .medium)
                        feedback.impactOccurred()
                        onOpenPro()
                    }) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.shieldGold)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color(hex: "FEF3C7").opacity(0.7))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                // Side-by-Side Square Card System: Generate QR & Scan QR Code
                HStack(spacing: 14) {
                    // Card 1: Generate QR
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .medium)
                        feedback.impactOccurred()
                        onNavigateToGenerate()
                    }) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.white.opacity(0.22))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "qrcode")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Generate QR")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Create styled codes")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.85))
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .frame(height: 142)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color(hex: "7952FC").opacity(0.35), radius: 10, x: 0, y: 6)
                        )
                    }
                    .buttonStyle(SpringCardButtonStyle())
                    
                    // Card 2: Scan QR Code
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .medium)
                        feedback.impactOccurred()
                        onNavigateToScan()
                    }) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(hex: "F3F0FF"))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "viewfinder")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(Color.shieldPurple)
                                }
                                
                                Spacer()
                                
                                Circle()
                                    .fill(Color(hex: "F3F4F6"))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(Color(hex: "6B7280"))
                                    )
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Scan QR Code")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "111827"))
                                
                                Text("Instant safety check")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .frame(height: 142)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .stroke(Color(hex: "E5E7EB"), lineWidth: 1.2)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                        )
                    }
                    .buttonStyle(SpringCardButtonStyle())
                }
                .padding(.horizontal, 20)
                
                // Popular Templates Section
                VStack(spacing: 14) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(hex: "F59E0B"))
                            
                            Text("Popular Templates")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "111827"))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let feedback = UIImpactFeedbackGenerator(style: .light)
                            feedback.impactOccurred()
                            onNavigateToTemplates()
                        }) {
                            HStack(spacing: 4) {
                                Text("See All")
                                    .font(.system(size: 14, weight: .bold))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .foregroundColor(Color.shieldPurple)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    
                    // 2-Column Grid of Popular Templates
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 14),
                            GridItem(.flexible(), spacing: 14)
                        ],
                        spacing: 16
                    ) {
                        ForEach(QRTemplate.popularTemplates) { template in
                            TemplateCardView(template: template) {
                                if let onSelectTemplate = onSelectTemplate {
                                    onSelectTemplate(template)
                                } else {
                                    onNavigateToTemplates()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 40)
            }
            .padding(.bottom, 120) // Full clearance above custom tab bar
        }
        .background(Color.white.ignoresSafeArea())
    }
}
