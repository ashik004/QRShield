import SwiftUI
import SafariServices

public struct ScanResultView: View {
    public let result: SafetyAnalysisResult
    public var onBack: () -> Void
    public var onDone: () -> Void
    
    @State private var showCopiedAlert: Bool = false
    @State private var showOpenDangerousAlert: Bool = false
    @State private var showOpenSuspiciousAlert: Bool = false
    @State private var openSafariURL: URL? = nil
    
    public init(
        result: SafetyAnalysisResult,
        onBack: @escaping () -> Void,
        onDone: @escaping () -> Void
    ) {
        self.result = result
        self.onBack = onBack
        self.onDone = onDone
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Scan Result")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Color.clear.frame(width: 38, height: 38)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Status Graphic & Title
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.18))
                                .frame(width: 84, height: 84)
                            
                            Image(systemName: result.status.iconName)
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text(result.status.title)
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(result.status.subtitle)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 10)
                    
                    // White Data Card
                    VStack(spacing: 0) {
                        // URL Box
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(Color(hex: "9CA3AF"))
                                .font(.system(size: 14))
                            
                            Text(result.urlString)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(hex: "1F2937"))
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Button(action: copyToClipboard) {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                        }
                        .padding(14)
                        .background(Color(hex: "F9FAFB"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                        )
                        .padding(16)
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        // Property Rows
                        VStack(spacing: 14) {
                            switch result.status {
                            case .safe:
                                infoRow(title: "Site Type", value: result.siteType ?? "Social Media", valueColor: Color(hex: "1F2937"))
                                infoRow(title: "SSL Secure", value: result.sslSecure ?? "Yes", valueColor: Color(hex: "10B981"))
                                infoRow(title: "Reputation", value: result.reputation ?? "Good", valueColor: Color(hex: "10B981"))
                                
                            case .suspicious:
                                infoRow(title: "Issues Found", value: result.issuesFound ?? "Unverified website", valueColor: Color(hex: "DC2626"))
                                infoRow(title: "Risk Level", value: result.riskLevel ?? "Medium", valueColor: Color(hex: "D97706"))
                                infoRow(title: "Recommendation", value: result.recommendation ?? "Avoid if not trusted", valueColor: Color(hex: "D97706"))
                                
                            case .dangerous:
                                infoRow(title: "Threat Type", value: result.threatType ?? "Phishing", valueColor: Color(hex: "DC2626"))
                                infoRow(title: "Risk Level", value: result.riskLevel ?? "High", valueColor: Color(hex: "DC2626"))
                                infoRow(title: "Recommendation", value: result.recommendation ?? "Do not open", valueColor: Color(hex: "DC2626"))
                            }
                        }
                        .padding(16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
                    )
                    .padding(.horizontal, 20)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        // Open Link button (shown for Safe & Suspicious, omitted or warning-gated for Dangerous)
                        if result.status != .dangerous {
                            Button(action: handleOpenLink) {
                                HStack(spacing: 8) {
                                    Text("Open Link")
                                        .font(.system(size: 16, weight: .bold))
                                    Image(systemName: "arrow.up.right.square")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.shieldPurple)
                                        .shadow(color: Color.shieldPurple.opacity(0.35), radius: 8, x: 0, y: 4)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // Copy Link button (Secondary outline)
                        Button(action: copyToClipboard) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 15, weight: .bold))
                                Text("Copy Link")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(Color.shieldPurple)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
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
                    .padding(.top, 8)
                    
                    Spacer(minLength: 30)
                }
            }
        }
        .background(
            LinearGradient(
                colors: result.status.topGradientColors + [Color(hex: "F8F9FD"), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .overlay(
            Group {
                if showCopiedAlert {
                    VStack {
                        Text("Link copied to clipboard!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color(hex: "1F2937")))
                            .shadow(radius: 8)
                            .padding(.top, 50)
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        )
        .alert("Suspicious Website Warning", isPresented: $showOpenSuspiciousAlert) {
            Button("Proceed Anyway", role: .destructive) {
                openInBrowser()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This website is unverified and may attempt to mislead you. Are you sure you want to open it?")
        }
        .sheet(item: $openSafariURL) { url in
            SafariView(url: url)
        }
    }
    
    private func infoRow(title: String, value: String, valueColor: Color) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(hex: "6B7280"))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(valueColor)
        }
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = result.urlString
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        withAnimation {
            showCopiedAlert = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCopiedAlert = false
            }
        }
    }
    
    private func handleOpenLink() {
        if result.status == .suspicious {
            showOpenSuspiciousAlert = true
        } else {
            openInBrowser()
        }
    }
    
    private func openInBrowser() {
        var formatted = result.urlString
        if !formatted.lowercased().hasPrefix("http://") && !formatted.lowercased().hasPrefix("https://") {
            formatted = "https://" + formatted
        }
        if let url = URL(string: formatted) {
            self.openSafariURL = url
        }
    }
}

extension URL: Identifiable {
    public var id: String { absoluteString }
}

/// SFSafariViewController wrapper
public struct SafariView: UIViewControllerRepresentable {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
