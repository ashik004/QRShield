import SwiftUI

public struct GenerateQRView: View {
    @Binding public var selectedSegment: Int // 0: Content, 1: Template
    @State private var activeInputType: QRContentType? = nil
    @State private var contentData: QRContentData = QRContentData(type: .website)
    
    public var onProceedToCustomize: (String, QRContentType) -> Void
    public var onSelectTemplate: (QRTemplate) -> Void
    
    public init(
        selectedSegment: Binding<Int>,
        onProceedToCustomize: @escaping (String, QRContentType) -> Void,
        onSelectTemplate: @escaping (QRTemplate) -> Void
    ) {
        self._selectedSegment = selectedSegment
        self.onProceedToCustomize = onProceedToCustomize
        self.onSelectTemplate = onSelectTemplate
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header: Clean title (No back button)
            HStack {
                Spacer()
                Text("Generate QR Code")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 8)
            
            // Segmented Control [ Content | Template ]
            HStack(spacing: 0) {
                segmentButton(title: "Content", index: 0)
                segmentButton(title: "Template", index: 1)
            }
            .padding(4)
            .background(Color(hex: "F3F4F6"))
            .clipShape(Capsule())
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            
            if selectedSegment == 0 {
                // Content Types List with full smooth scrolling
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(QRContentType.allCases) { type in
                            typeRow(type)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 130) // Full clearance above tab bar
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Embedded Templates View: No title & no search bar per specification!
                TemplatesView(
                    showHeader: false,
                    showSearchBar: false,
                    onSelectTemplate: onSelectTemplate
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .sheet(item: $activeInputType) { type in
            InputFormModalView(
                type: type,
                contentData: $contentData,
                onProceed: { payload in
                    activeInputType = nil
                    onProceedToCustomize(payload, type)
                }
            )
        }
    }
    
    private func segmentButton(title: String, index: Int) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedSegment = index
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: selectedSegment == index ? .bold : .semibold))
                .foregroundColor(selectedSegment == index ? .white : Color(hex: "4B5563"))
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(
                    selectedSegment == index ?
                    Capsule().fill(Color.shieldPurple) :
                    nil
                )
        }
        .buttonStyle(.plain)
    }
    
    private func typeRow(_ type: QRContentType) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            contentData = QRContentData(type: type)
            activeInputType = type
        }) {
            HStack(spacing: 16) {
                // Icon in soft tinted circle
                ZStack {
                    Circle()
                        .fill(Color(hex: "F3F0FF"))
                        .frame(width: 46, height: 46)
                    
                    Image(systemName: type.iconName)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(Color.shieldPurple)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(type.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "1F2937"))
                    
                    Text(subtitle(for: type))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(hex: "F3F4F6"), lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func subtitle(for type: QRContentType) -> String {
        switch type {
        case .website: return "Open any website, URL, or portfolio"
        case .wifi: return "Connect to Wi-Fi network instantly"
        case .contact: return "Share contact details & vCard file"
        case .phone: return "Direct one-tap phone call"
        case .text: return "Display plain text or note"
        case .email: return "Send pre-written email message"
        case .location: return "Open map navigation pin"
        case .social: return "Link to social media profile"
        }
    }
}

/// Modal for entering specific QR data
public struct InputFormModalView: View {
    @Environment(\.dismiss) private var dismiss
    public let type: QRContentType
    @Binding public var contentData: QRContentData
    public var onProceed: (String) -> Void
    
    public init(type: QRContentType, contentData: Binding<QRContentData>, onProceed: @escaping (String) -> Void) {
        self.type = type
        self._contentData = contentData
        self.onProceed = onProceed
    }
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details for \(type.rawValue)").font(.system(size: 13, weight: .bold))) {
                    switch type {
                    case .website:
                        TextField("https://example.com", text: $contentData.url)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                        
                    case .wifi:
                        TextField("Network Name (SSID)", text: $contentData.wifiSSID)
                        SecureField("Password", text: $contentData.wifiPassword)
                        Picker("Encryption", selection: $contentData.wifiEncryption) {
                            Text("WPA/WPA2").tag("WPA")
                            Text("WEP").tag("WEP")
                            Text("Open (None)").tag("None")
                        }
                        Toggle("Hidden Network", isOn: $contentData.wifiIsHidden)
                        
                    case .contact:
                        TextField("First Name", text: $contentData.firstName)
                        TextField("Last Name", text: $contentData.lastName)
                        TextField("Phone", text: $contentData.contactPhone).keyboardType(.phonePad)
                        TextField("Email", text: $contentData.contactEmail).keyboardType(.emailAddress).autocapitalization(.none)
                        TextField("Company", text: $contentData.company)
                        TextField("Job Title", text: $contentData.jobTitle)
                        TextField("Website", text: $contentData.websiteUrl).keyboardType(.URL).autocapitalization(.none)
                        
                    case .phone:
                        TextField("+1 (555) 123-4567", text: $contentData.phoneNumber)
                            .keyboardType(.phonePad)
                        
                    case .text:
                        TextEditor(text: $contentData.plainText)
                            .frame(height: 100)
                        
                    case .email:
                        TextField("Recipient Email", text: $contentData.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        TextField("Subject", text: $contentData.emailSubject)
                        TextField("Message Body", text: $contentData.emailBody)
                        
                    case .location:
                        TextField("Latitude (e.g. 37.7749)", value: $contentData.latitude, format: .number)
                        TextField("Longitude (e.g. -122.4194)", value: $contentData.longitude, format: .number)
                        TextField("Location Name", text: $contentData.locationName)
                        
                    case .social:
                        Picker("Platform", selection: $contentData.socialPlatform) {
                            ForEach(SocialPlatform.allCases) { p in
                                Text(p.rawValue).tag(p)
                            }
                        }
                        TextField("Username / Handle", text: $contentData.socialUsername)
                            .autocapitalization(.none)
                    }
                }
                
                Section {
                    Button(action: {
                        onProceed(contentData.payloadString)
                    }) {
                        HStack {
                            Spacer()
                            Text("Continue to Customize")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.shieldPurple)
                        )
                    }
                    .listRowInsets(EdgeInsets())
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle(type.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
