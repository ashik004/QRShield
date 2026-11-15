import SwiftUI

public struct GenerateQRView: View {
    @State private var selectedSegment: Int = 0 // 0: Content, 1: Template
    @State private var activeInputType: QRContentType? = nil
    @State private var contentData: QRContentData = QRContentData(type: .website)
    
    public var onBack: () -> Void
    public var onProceedToCustomize: (String, QRContentType) -> Void
    public var onSelectTemplate: (QRTemplate) -> Void
    
    public init(
        onBack: @escaping () -> Void,
        onProceedToCustomize: @escaping (String, QRContentType) -> Void,
        onSelectTemplate: @escaping (QRTemplate) -> Void
    ) {
        self.onBack = onBack
        self.onProceedToCustomize = onProceedToCustomize
        self.onSelectTemplate = onSelectTemplate
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "1F2937"))
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Generate QR Code")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Color.clear.frame(width: 38, height: 38)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Segmented Control [ Content | Template ]
            HStack(spacing: 0) {
                segmentButton(title: "Content", index: 0)
                segmentButton(title: "Template", index: 1)
            }
            .padding(4)
            .background(Color(hex: "F3F4F6"))
            .clipShape(Capsule())
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            
            if selectedSegment == 0 {
                // Content Types List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(QRContentType.allCases) { type in
                            typeRow(type)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                }
            } else {
                // Embedded Templates View
                TemplatesView(
                    onBack: { selectedSegment = 0 },
                    onSelectTemplate: onSelectTemplate
                )
            }
        }
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
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: type.iconName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.shieldPurple)
                }
                
                Text(type.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(hex: "F3F4F6"), lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
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
