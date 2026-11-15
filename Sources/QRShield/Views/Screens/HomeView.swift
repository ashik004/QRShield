import SwiftUI

public struct HomeView: View {
    public var onNavigateToGenerate: () -> Void
    public var onNavigateToScan: () -> Void
    public var onNavigateToTemplates: () -> Void
    public var onNavigateToMyCodes: () -> Void
    public var onNavigateToHistory: () -> Void
    public var onNavigateToFavorites: () -> Void
    public var onOpenPro: () -> Void
    
    public init(
        onNavigateToGenerate: @escaping () -> Void,
        onNavigateToScan: @escaping () -> Void,
        onNavigateToTemplates: @escaping () -> Void,
        onNavigateToMyCodes: @escaping () -> Void,
        onNavigateToHistory: @escaping () -> Void,
        onNavigateToFavorites: @escaping () -> Void,
        onOpenPro: @escaping () -> Void
    ) {
        self.onNavigateToGenerate = onNavigateToGenerate
        self.onNavigateToScan = onNavigateToScan
        self.onNavigateToTemplates = onNavigateToTemplates
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
                
                // Hero Banner Card
                HeroBannerView()
                    .padding(.horizontal, 20)
                
                // Primary Action Buttons
                VStack(spacing: 12) {
                    // 1. Generate QR Code Button
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .medium)
                        feedback.impactOccurred()
                        onNavigateToGenerate()
                    }) {
                        HStack(spacing: 14) {
                            Image(systemName: "qrcode")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Generate QR Code")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 58)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color(hex: "6C5CE7").opacity(0.35), radius: 10, x: 0, y: 5)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // 2. Scan QR Code Button
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .medium)
                        feedback.impactOccurred()
                        onNavigateToScan()
                    }) {
                        HStack(spacing: 14) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color.shieldPurple)
                            
                            Text("Scan QR Code")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color.shieldPurple)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.shieldPurple.opacity(0.8))
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 58)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(hex: "F3F0FF"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color(hex: "E5DEFF"), lineWidth: 1.5)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                
                // Quick Access 2x2 Grid
                QuickAccessGrid(
                    onSelectTemplates: onNavigateToTemplates,
                    onSelectMyCodes: onNavigateToMyCodes,
                    onSelectHistory: onNavigateToHistory,
                    onSelectFavorites: onNavigateToFavorites
                )
                .padding(.horizontal, 20)
                
                Spacer(minLength: 40)
            }
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}
