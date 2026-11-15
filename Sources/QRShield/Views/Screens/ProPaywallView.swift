import SwiftUI

public struct ProPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: Int = 1 // 0: Monthly, 1: Annual
    @State private var showUnlockedAlert: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Background with rich, modern gradient
            LinearGradient(
                colors: [
                    Color(hex: "EDE9FE").opacity(0.85),
                    Color(hex: "F8F9FD"),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Dismiss Bar
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(hex: "9CA3AF"))
                            .padding(16)
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Crown & Branding Header
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "FBBF24"), Color(hex: "F59E0B")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 76, height: 76)
                                    .shadow(color: Color.shieldGold.opacity(0.45), radius: 12, x: 0, y: 6)
                                
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 38, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("QR Shield Pro")
                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                                .foregroundColor(Color(hex: "1F2937"))
                            
                            Text("Unlock ultimate QR styling & cybersecurity")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "6B7280"))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 4)
                        
                        // Feature Highlights
                        VStack(alignment: .leading, spacing: 14) {
                            featureRow(icon: "shield.lefthalf.filled.badge.checkmark", title: "Real-Time AI Threat Engine", description: "Inspects URLs for phishing, malware & spoofing")
                            featureRow(icon: "paintpalette.fill", title: "40+ Designer Templates & Gradients", description: "Unlimited access to all brand styles & meshes")
                            featureRow(icon: "photo.badge.plus", title: "Custom Brand Logo Embedding", description: "Embed your high-res logo or photo inside QR")
                            featureRow(icon: "sparkles", title: "Ad-Free & Blazing Fast Scans", description: "Zero waiting time, clean distraction-free UI")
                            featureRow(icon: "arrow.down.doc.fill", title: "High-Res 4K Vector Exports", description: "Crisp print-ready exports for business & posters")
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color(hex: "E5DEFF"), lineWidth: 1.5)
                                )
                                .shadow(color: Color.shieldPurple.opacity(0.08), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                        
                        // Plan Selection Cards (Annual & Monthly)
                        HStack(spacing: 12) {
                            planCard(index: 0, title: "Monthly", price: "$2.99", period: "/ month", badge: nil)
                            planCard(index: 1, title: "Annual", price: "$19.99", period: "/ year", badge: "SAVE 45%")
                        }
                        .padding(.horizontal, 20)
                        
                        // Main Action Button
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
                        .padding(.top, 4)
                        
                        // Footer Links & Guarantees
                        VStack(spacing: 8) {
                            Text("Cancel anytime in App Store settings. No commitment.")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Color(hex: "9CA3AF"))
                            
                            HStack(spacing: 16) {
                                Button("Restore Purchases") {
                                    showUnlockedAlert = true
                                }
                                Text("•")
                                Button("Terms of Use") {}
                                Text("•")
                                Button("Privacy Policy") {}
                            }
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.shieldPurple)
                        }
                        .padding(.top, 2)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .alert("Welcome to QR Shield Pro! 🎉", isPresented: $showUnlockedAlert) {
            Button("Let's Go!", role: .cancel) { dismiss() }
        } message: {
            Text("All premium templates, advanced safety checks, and customization features are now unlocked.")
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
                VStack(spacing: 4) {
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
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(selectedPlan == index ? Color(hex: "F3F0FF") : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(selectedPlan == index ? Color.shieldPurple : Color(hex: "E5E7EB"), lineWidth: selectedPlan == index ? 2 : 1)
                        )
                )
                
                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 9, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3.5)
                        .background(Capsule().fill(Color.shieldPurple))
                        .offset(x: -6, y: -8)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
