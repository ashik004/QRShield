import SwiftUI

public struct ProPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: Int = 1 // 0: Monthly, 1: Annual
    @State private var showUnlockedAlert: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header Badge
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FBBF24"), Color(hex: "F59E0B")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.shieldGold.opacity(0.4), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "crown.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("QR Shield Pro")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "1F2937"))
                        
                        Text("Unlock full security and design power")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "6B7280"))
                    }
                    .padding(.top, 10)
                    
                    // Features List
                    VStack(alignment: .leading, spacing: 16) {
                        featureRow(icon: "shield.lefthalf.filled.badge.checkmark", title: "Real-Time AI Threat Detection", description: "Deep inspection for phishing, zero-day malware & IP redirection")
                        featureRow(icon: "paintpalette.fill", title: "All Premium Templates & Gradients", description: "Unlock stylish brand designs, Instagram sunsets, and cyber waves")
                        featureRow(icon: "photo.badge.plus", title: "Custom Logo Embedding", description: "Add your company brand or custom photos to any QR code")
                        featureRow(icon: "sparkles", title: "Ad-Free & Unlimited Scans", description: "Blazing fast scanning with zero interruptions")
                        featureRow(icon: "arrow.down.doc.fill", title: "High-Res Vector SVG / PNG Export", description: "Print ready 4K exports for signs, business cards and menus")
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "F8F7FF"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "E5DEFF"), lineWidth: 1.2)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    // Pricing Selection
                    HStack(spacing: 14) {
                        planCard(index: 0, title: "Monthly", price: "$2.99", period: "/ month", badge: nil)
                        planCard(index: 1, title: "Annual", price: "$19.99", period: "/ year", badge: "SAVE 45%")
                    }
                    .padding(.horizontal, 20)
                    
                    // Unlock CTA Button
                    Button(action: {
                        let feedback = UINotificationFeedbackGenerator()
                        feedback.notificationOccurred(.success)
                        showUnlockedAlert = true
                    }) {
                        Text("Unlock QR Shield Pro")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color.shieldPurple.opacity(0.4), radius: 10, x: 0, y: 5)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.top, 6)
                    
                    // Footer Links
                    HStack(spacing: 20) {
                        Button("Restore Purchases") {
                            showUnlockedAlert = true
                        }
                        Text("•")
                        Button("Terms of Use") {}
                        Text("•")
                        Button("Privacy Policy") {}
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .padding(.bottom, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                }
            }
        }
        .alert("Welcome to QR Shield Pro!", isPresented: $showUnlockedAlert) {
            Button("Awesome", role: .cancel) { dismiss() }
        } message: {
            Text("All premium templates, advanced safety checks, and features are now unlocked.")
        }
    }
    
    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.shieldPurple)
                .frame(width: 26)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                Text(description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "6B7280"))
            }
        }
    }
    
    private func planCard(index: Int, title: String, price: String, period: String, badge: String?) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            selectedPlan = index
        }) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "6B7280"))
                    
                    Text(price)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(selectedPlan == index ? Color.shieldPurple : Color(hex: "1F2937"))
                    
                    Text(period)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(selectedPlan == index ? Color(hex: "F3F0FF") : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedPlan == index ? Color.shieldPurple : Color(hex: "E5E7EB"), lineWidth: 2)
                        )
                )
                
                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.shieldPurple))
                        .offset(x: -8, y: -8)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
