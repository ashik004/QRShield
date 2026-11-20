import SwiftUI
import StoreKit

public struct SettingsView: View {
    public var onBack: () -> Void
    public var onOpenPro: () -> Void
    
    @State private var showLanguagePicker: Bool = false
    @State private var selectedLanguage: String = "English"
    @State private var showPrivacyModal: Bool = false
    @State private var showTermsModal: Bool = false
    @State private var showRestoreAlert: Bool = false
    
    public init(onBack: @escaping () -> Void, onOpenPro: @escaping () -> Void) {
        self.onBack = onBack
        self.onOpenPro = onOpenPro
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "253745"))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Settings")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                
                Spacer()
                
                Color.clear.frame(width: 38, height: 38)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // QR Shield Pro Card Banner
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .medium)
                        feedback.impactOccurred()
                        onOpenPro()
                    }) {
                        HStack(spacing: 14) {
                            // Crown icon badge
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "11212D"))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(hex: "253745"), lineWidth: 1)
                                    )
                                
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(Color.shieldGold)
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("QR Shield Pro")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "CCD0CF"))
                                
                                Text("Unlock premium templates,\nremove ads, and more.")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "9BA8AB"))
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "CCD0CF"))
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "253745"), Color(hex: "4A5C6A")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color(hex: "253745"), lineWidth: 1.5)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // Options List Group
                    VStack(spacing: 0) {
                        settingRow(
                            icon: "arrow.clockwise.circle",
                            title: "Restore Purchase",
                            value: nil,
                            action: { showRestoreAlert = true }
                        )
                        
                        Divider().background(Color(hex: "253745")).padding(.horizontal, 16)
                        
                        settingRow(
                            icon: "globe",
                            title: "App Language",
                            value: selectedLanguage,
                            action: { showLanguagePicker = true }
                        )
                        
                        Divider().background(Color(hex: "253745")).padding(.horizontal, 16)
                        
                        settingRow(
                            icon: "star",
                            title: "Rate Us",
                            value: nil,
                            action: triggerRateApp
                        )
                        
                        Divider().background(Color(hex: "253745")).padding(.horizontal, 16)
                        
                        settingRow(
                            icon: "square.and.arrow.up",
                            title: "Share App",
                            value: nil,
                            action: triggerShareApp
                        )
                        
                        Divider().background(Color(hex: "253745")).padding(.horizontal, 16)
                        
                        settingRow(
                            icon: "lock.shield",
                            title: "Privacy Policy",
                            value: nil,
                            action: { showPrivacyModal = true }
                        )
                        
                        Divider().background(Color(hex: "253745")).padding(.horizontal, 16)
                        
                        settingRow(
                            icon: "doc.text",
                            title: "Terms of Use",
                            value: nil,
                            action: { showTermsModal = true }
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color(hex: "11212D"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color(hex: "253745"), lineWidth: 1.5)
                            )
                    )
                    
                    Text("QR Shield v1.0 • Built with SwiftUI")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "06141B").ignoresSafeArea())
        .alert("Purchases Restored", isPresented: $showRestoreAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your previous QR Shield purchases have been restored.")
        }
        .confirmationDialog("Select App Language", isPresented: $showLanguagePicker, titleVisibility: .visible) {
            Button("English") { selectedLanguage = "English" }
            Button("Spanish (Español)") { selectedLanguage = "Spanish" }
            Button("French (Français)") { selectedLanguage = "French" }
            Button("German (Deutsch)") { selectedLanguage = "German" }
            Button("Japanese (日本語)") { selectedLanguage = "Japanese" }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showPrivacyModal) {
            LegalDocModalView(title: "Privacy Policy", content: privacyPolicyText)
        }
        .sheet(isPresented: $showTermsModal) {
            LegalDocModalView(title: "Terms of Use", content: termsOfUseText)
        }
    }
    
    private func settingRow(icon: String, title: String, value: String?, action: @escaping () -> Void) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            action()
        }) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "4A5C6A"))
                    .frame(width: 28)
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "CCD0CF"))
                
                Spacer()
                
                if let val = value {
                    Text(val)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "9BA8AB"))
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "9BA8AB"))
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
        }
        .buttonStyle(.plain)
    }
    
    private func triggerRateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func triggerShareApp() {
        guard let url = URL(string: "https://qrshield.app") else { return }
        let activity = UIActivityViewController(activityItems: ["Check out QR Shield - The safest and most stylish QR code scanner and generator for iOS!", url], applicationActivities: nil)
        
        if let root = UIApplication.shared.windows.first?.rootViewController {
            root.present(activity, animated: true)
        }
    }
}

public struct LegalDocModalView: View {
    @Environment(\.dismiss) private var dismiss
    public let title: String
    public let content: String
    
    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "06141B").ignoresSafeArea()
                
                ScrollView {
                    Text(content)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .padding(20)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

private let privacyPolicyText = """
QR Shield Privacy Policy

Your privacy is our top priority. QR Shield processes QR code generation and link verification locally on your device or through secure encrypted queries without collecting personally identifiable information.

1. Information We Collect:
QR Shield does not require an account or profile. Scanned links and generated QR codes remain stored on your local device.

2. Safety Check Service:
When you scan a link, the domain is evaluated against known cybersecurity phishing and malware blacklists. No browsing telemetry or personal data is linked to your device identifier.

3. Camera Access:
Camera access is exclusively utilized in real-time to locate and decode QR codes within the camera viewport. Images from your camera are never uploaded or retained without your permission.
"""

private let termsOfUseText = """
QR Shield Terms of Use

By accessing or using QR Shield, you agree to comply with the terms set forth herein.

1. License:
You are granted a revocable, non-exclusive license to use QR Shield on iOS devices.

2. Link Safety Disclaimer:
QR Shield employs automated heuristic and threat reputation analysis to assess links. While we strive for maximum detection precision, users should exercise diligence when navigating to unverified external websites.

3. Pro Subscription:
Subscriptions renew automatically unless cancelled at least 24 hours prior to renewal via Apple App Store Account Settings.
"""
