import SwiftUI

public struct GenerateQRView: View {
    public var title: String
    public var selectedTemplate: QRTemplate?
    public var onBack: (() -> Void)?
    public var onProceedToCustomize: (String, QRContentType, QRTemplate?) -> Void
    
    @State private var activeInputType: QRContentType? = nil
    @State private var contentData: QRContentData = QRContentData(type: .website)
    
    public init(
        title: String = "Generate QR Code",
        selectedTemplate: QRTemplate? = nil,
        onBack: (() -> Void)? = nil,
        onProceedToCustomize: @escaping (String, QRContentType, QRTemplate?) -> Void
    ) {
        self.title = title
        self.selectedTemplate = selectedTemplate
        self.onBack = onBack
        self.onProceedToCustomize = onProceedToCustomize
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                if let onBack = onBack {
                    Button(action: {
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        onBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "1F2937"))
                            .frame(width: 38, height: 38)
                            .background(Color(hex: "F3F4F6"))
                            .clipShape(Circle())
                    }
                } else {
                    Color.clear.frame(width: 38, height: 38)
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Color.clear.frame(width: 38, height: 38)
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 10)
            
            // Selected Template Card Header (if chosen from Templates)
            if let t = selectedTemplate {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: t.gradientHexColors.map { Color(hex: $0) },
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: t.categoryIcon)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(t.name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(hex: "111827"))
                            
                            Text(t.category.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.shieldPurple.opacity(0.12))
                                .foregroundColor(Color.shieldPurple)
                                .clipShape(Capsule())
                        }
                        
                        Text("Select content type to populate this template")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "6B7280"))
                    }
                    
                    Spacer()
                }
                .padding(12)
                .background(Color(hex: "F9FAFB"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            
            // Content Types in a sleek, modern Grid design
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 14),
                        GridItem(.flexible(), spacing: 14)
                    ],
                    spacing: 14
                ) {
                    ForEach(QRContentType.allCases) { type in
                        contentGridCard(type)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 6)
                .padding(.bottom, 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        // Half Sheet for Entering QR Content Data
        .sheet(item: $activeInputType) { type in
            ContentInputHalfSheet(
                type: type,
                contentData: $contentData,
                onCreate: { payload in
                    activeInputType = nil
                    onProceedToCustomize(payload, type, selectedTemplate)
                }
            )
            .presentationDetents([.fraction(0.68), .large])
            .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Grid Card Component for Content Types
    private func contentGridCard(_ type: QRContentType) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            contentData = QRContentData(type: type)
            if let t = selectedTemplate, !t.defaultContent.isEmpty {
                if type == .website {
                    contentData.websiteUrl = t.defaultContent
                } else if type == .text {
                    contentData.plainText = t.defaultContent
                }
            }
            activeInputType = type
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(typeTheme(for: type).bgColor)
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: type.iconName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(typeTheme(for: type).accentColor)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(typeTheme(for: type).accentColor.opacity(0.7))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(type.rawValue)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "1F2937"))
                        .lineLimit(1)
                    
                    Text(subtitle(for: type))
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color(hex: "6B7280"))
                        .lineLimit(1)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 114, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color(hex: "F3F4F6"), lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 3)
            )
        }
        .buttonStyle(SpringCardButtonStyle())
    }
    
    private func subtitle(for type: QRContentType) -> String {
        switch type {
        case .website: return "URL, link & portfolio"
        case .wifi: return "Wi-Fi network access"
        case .contact: return "Share vCard contact"
        case .phone: return "Direct phone call"
        case .text: return "Notes & messages"
        case .email: return "Pre-filled email"
        case .location: return "Map pin & location"
        case .social: return "Social profiles"
        }
    }
    
    private func typeTheme(for type: QRContentType) -> (accentColor: Color, bgColor: Color) {
        switch type {
        case .website:
            return (Color(hex: "2563EB"), Color(hex: "EFF6FF"))
        case .wifi:
            return (Color(hex: "7C3AED"), Color(hex: "F5F3FF"))
        case .contact:
            return (Color(hex: "059669"), Color(hex: "ECFDF5"))
        case .phone:
            return (Color(hex: "EA580C"), Color(hex: "FFF7ED"))
        case .text:
            return (Color(hex: "4F46E5"), Color(hex: "EEF2FF"))
        case .email:
            return (Color(hex: "E11D48"), Color(hex: "FFF1F2"))
        case .location:
            return (Color(hex: "0D9488"), Color(hex: "F0FDFA"))
        case .social:
            return (Color(hex: "DB2777"), Color(hex: "FDF2F8"))
        }
    }
}

// MARK: - Native Half Sheet for Content Input
public struct ContentInputHalfSheet: View {
    @Environment(\.dismiss) private var dismiss
    public let type: QRContentType
    @Binding public var contentData: QRContentData
    public var onCreate: (String) -> Void
    
    @State private var showPassword: Bool = false
    
    public init(
        type: QRContentType,
        contentData: Binding<QRContentData>,
        onCreate: @escaping (String) -> Void
    ) {
        self.type = type
        self._contentData = contentData
        self.onCreate = onCreate
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "F3F0FF"))
                        .frame(width: 36, height: 36)
                    Image(systemName: type.iconName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.shieldPurple)
                }
                
                Text(type.rawValue)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "D1D5DB"))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 12)
            
            Divider()
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            // Scrollable Content Inputs
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    inputFields
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            
            // Bottom Create Button
            VStack(spacing: 0) {
                Button(action: {
                    let feedback = UIImpactFeedbackGenerator(style: .medium)
                    feedback.impactOccurred()
                    onCreate(contentData.payloadString)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 16, weight: .bold))
                        Text("Create")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: Color.shieldPurple.opacity(0.35), radius: 10, x: 0, y: 5)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 16)
            }
            .background(Color.white.shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: -2))
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Input Fields Per Content Type
    @ViewBuilder
    private var inputFields: some View {
        switch type {
        case .website:
            fieldBlock(label: "WEBSITE URL") {
                HStack(spacing: 10) {
                    Image(systemName: "link")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 15))
                    TextField("https://example.com", text: $contentData.url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .font(.system(size: 15))
                    
                    if !contentData.url.isEmpty {
                        clearButton { contentData.url = "" }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
        case .wifi:
            fieldBlock(label: "NETWORK NAME (SSID)") {
                HStack(spacing: 10) {
                    Image(systemName: "wifi")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 15))
                    TextField("Enter Wi-Fi name", text: $contentData.wifiSSID)
                        .font(.system(size: 15))
                    
                    if !contentData.wifiSSID.isEmpty {
                        clearButton { contentData.wifiSSID = "" }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            fieldBlock(label: "PASSWORD") {
                HStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 15))
                    
                    if showPassword {
                        TextField("Enter password", text: $contentData.wifiPassword)
                            .font(.system(size: 15))
                    } else {
                        SecureField("Enter password", text: $contentData.wifiPassword)
                            .font(.system(size: 15))
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color(hex: "9CA3AF"))
                            .font(.system(size: 14))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            fieldBlock(label: "SECURITY TYPE") {
                HStack(spacing: 8) {
                    ForEach(["WPA", "WEP", "None"], id: \.self) { enc in
                        Button(action: { contentData.wifiEncryption = enc }) {
                            Text(enc == "None" ? "Open" : enc)
                                .font(.system(size: 13, weight: contentData.wifiEncryption == enc ? .bold : .medium))
                                .foregroundColor(contentData.wifiEncryption == enc ? .white : Color(hex: "4B5563"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 38)
                                .background(
                                    Capsule().fill(contentData.wifiEncryption == enc ? Color.shieldPurple : Color(hex: "F3F4F6"))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
        case .contact:
            HStack(spacing: 10) {
                fieldBlock(label: "FIRST NAME") {
                    TextField("John", text: $contentData.firstName)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                fieldBlock(label: "LAST NAME") {
                    TextField("Doe", text: $contentData.lastName)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            fieldBlock(label: "PHONE NUMBER") {
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 14))
                    TextField("+1 (555) 123-4567", text: $contentData.contactPhone)
                        .keyboardType(.phonePad)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            fieldBlock(label: "EMAIL ADDRESS") {
                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 14))
                    TextField("john@example.com", text: $contentData.contactEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            fieldBlock(label: "ORGANIZATION / COMPANY") {
                TextField("Company or Business", text: $contentData.company)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(hex: "F3F4F6"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
        case .phone:
            fieldBlock(label: "PHONE NUMBER") {
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 15))
                    TextField("+1 (555) 123-4567", text: $contentData.phoneNumber)
                        .keyboardType(.phonePad)
                        .font(.system(size: 15))
                    
                    if !contentData.phoneNumber.isEmpty {
                        clearButton { contentData.phoneNumber = "" }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
        case .text:
            fieldBlock(label: "MESSAGE OR PLAIN TEXT") {
                TextEditor(text: $contentData.plainText)
                    .frame(height: 110)
                    .padding(8)
                    .background(Color(hex: "F3F4F6"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                    )
            }
            
        case .email:
            fieldBlock(label: "RECIPIENT EMAIL") {
                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 14))
                    TextField("recipient@example.com", text: $contentData.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            fieldBlock(label: "SUBJECT") {
                TextField("Email Subject", text: $contentData.emailSubject)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(hex: "F3F4F6"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            fieldBlock(label: "MESSAGE") {
                TextField("Message body text...", text: $contentData.emailBody)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(hex: "F3F4F6"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
        case .location:
            fieldBlock(label: "LOCATION NAME OR ADDRESS") {
                HStack(spacing: 10) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 15))
                    TextField("Location Name (e.g. San Francisco)", text: $contentData.locationName)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            HStack(spacing: 10) {
                fieldBlock(label: "LATITUDE") {
                    TextField("Latitude", value: $contentData.latitude, format: .number)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                fieldBlock(label: "LONGITUDE") {
                    TextField("Longitude", value: $contentData.longitude, format: .number)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
        case .social:
            fieldBlock(label: "CHOOSE PLATFORM") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(SocialPlatform.allCases) { p in
                            Button(action: {
                                let fb = UIImpactFeedbackGenerator(style: .light)
                                fb.impactOccurred()
                                contentData.socialPlatform = p
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: p.iconName)
                                        .font(.system(size: 12, weight: .bold))
                                    Text(p.rawValue)
                                        .font(.system(size: 12, weight: contentData.socialPlatform == p ? .bold : .medium))
                                }
                                .foregroundColor(contentData.socialPlatform == p ? .white : Color(hex: "4B5563"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(contentData.socialPlatform == p ? Color.shieldPurple : Color(hex: "F3F4F6"))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            
            fieldBlock(label: "USERNAME / HANDLE") {
                HStack(spacing: 8) {
                    Text("@")
                        .foregroundColor(Color.shieldPurple)
                        .font(.system(size: 16, weight: .bold))
                    TextField("username", text: $contentData.socialUsername)
                        .autocapitalization(.none)
                        .font(.system(size: 15))
                    
                    if !contentData.socialUsername.isEmpty {
                        clearButton { contentData.socialUsername = "" }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Helper UI Components
    private func fieldBlock<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "6B7280"))
                .tracking(1.0)
            
            content()
        }
    }
    
    private func clearButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(Color(hex: "9CA3AF"))
                .font(.system(size: 14))
        }
    }
}
