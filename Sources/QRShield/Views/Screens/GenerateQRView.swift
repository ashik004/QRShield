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
                            .foregroundColor(Color(hex: "CCD0CF"))
                            .frame(width: 38, height: 38)
                            .background(Color(hex: "11212D"))
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color(hex: "253745"), lineWidth: 1)
                            )
                    }
                } else {
                    Color.clear.frame(width: 38, height: 38)
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                
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
                                .foregroundColor(Color(hex: "CCD0CF"))
                            
                            Text(t.category.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "253745"))
                                .foregroundColor(Color(hex: "9BA8AB"))
                                .clipShape(Capsule())
                        }
                        
                        Text("Select content type to populate this template")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "9BA8AB"))
                    }
                    
                    Spacer()
                }
                .padding(12)
                .background(Color(hex: "11212D"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "253745"), lineWidth: 1)
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
        .background(Color(hex: "06141B").ignoresSafeArea())
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
                            .fill(Color(hex: "253745"))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: type.iconName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "4A5C6A"))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(type.rawValue)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .lineLimit(1)
                    
                    Text(subtitle(for: type))
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .lineLimit(1)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 114, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(hex: "11212D"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color(hex: "253745"), lineWidth: 1.5)
                    )
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
                        .fill(Color(hex: "253745"))
                        .frame(width: 36, height: 36)
                    Image(systemName: type.iconName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
                
                Text(type.rawValue)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "9BA8AB"))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 12)
            
            Divider()
                .background(Color(hex: "253745"))
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
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(hex: "4A5C6A"))
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 16)
            }
            .background(Color(hex: "11212D"))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(hex: "253745")),
                alignment: .top
            )
        }
        .background(Color(hex: "11212D").ignoresSafeArea())
    }
    
    // MARK: - Input Fields Per Content Type
    @ViewBuilder
    private var inputFields: some View {
        switch type {
        case .website:
            fieldBlock(label: "WEBSITE URL") {
                HStack(spacing: 10) {
                    Image(systemName: "link")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 15))
                    TextField("https://example.com", text: $contentData.url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    if !contentData.url.isEmpty {
                        clearButton { contentData.url = "" }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
        case .wifi:
            fieldBlock(label: "NETWORK NAME (SSID)") {
                HStack(spacing: 10) {
                    Image(systemName: "wifi")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 15))
                    TextField("Enter Wi-Fi name", text: $contentData.wifiSSID)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    if !contentData.wifiSSID.isEmpty {
                        clearButton { contentData.wifiSSID = "" }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
            fieldBlock(label: "PASSWORD") {
                HStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 15))
                    
                    if showPassword {
                        TextField("Enter password", text: $contentData.wifiPassword)
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    } else {
                        SecureField("Enter password", text: $contentData.wifiPassword)
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color(hex: "9BA8AB"))
                            .font(.system(size: 14))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
            fieldBlock(label: "SECURITY TYPE") {
                HStack(spacing: 8) {
                    ForEach(["WPA", "WEP", "None"], id: \.self) { enc in
                        Button(action: { contentData.wifiEncryption = enc }) {
                            Text(enc == "None" ? "Open" : enc)
                                .font(.system(size: 13, weight: contentData.wifiEncryption == enc ? .bold : .medium))
                                .foregroundColor(contentData.wifiEncryption == enc ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 38)
                                .background(
                                    Capsule().fill(contentData.wifiEncryption == enc ? Color(hex: "4A5C6A") : Color(hex: "253745"))
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
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(hex: "06141B"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
                }
                fieldBlock(label: "LAST NAME") {
                    TextField("Doe", text: $contentData.lastName)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(hex: "06141B"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
                }
            }
            
            fieldBlock(label: "PHONE NUMBER") {
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 14))
                    TextField("+1 (555) 123-4567", text: $contentData.contactPhone)
                        .keyboardType(.phonePad)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
            fieldBlock(label: "EMAIL ADDRESS") {
                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 14))
                    TextField("john@example.com", text: $contentData.contactEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
            fieldBlock(label: "ORGANIZATION / COMPANY") {
                TextField("Company or Business", text: $contentData.company)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(hex: "06141B"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
        case .phone:
            fieldBlock(label: "PHONE NUMBER") {
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 15))
                    TextField("+1 (555) 123-4567", text: $contentData.phoneNumber)
                        .keyboardType(.phonePad)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    if !contentData.phoneNumber.isEmpty {
                        clearButton { contentData.phoneNumber = "" }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
        case .text:
            fieldBlock(label: "MESSAGE OR PLAIN TEXT") {
                TextEditor(text: $contentData.plainText)
                    .frame(height: 110)
                    .padding(8)
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .scrollContentBackground(.hidden)
                    .background(Color(hex: "06141B"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "253745"), lineWidth: 1)
                    )
            }
            
        case .email:
            fieldBlock(label: "RECIPIENT EMAIL") {
                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 14))
                    TextField("recipient@example.com", text: $contentData.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
            fieldBlock(label: "SUBJECT") {
                TextField("Email Subject", text: $contentData.emailSubject)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(hex: "06141B"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
            fieldBlock(label: "MESSAGE") {
                TextField("Message body text...", text: $contentData.emailBody)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(hex: "06141B"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
        case .location:
            fieldBlock(label: "LOCATION NAME OR ADDRESS") {
                HStack(spacing: 10) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 15))
                    TextField("Location Name (e.g. San Francisco)", text: $contentData.locationName)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            
            HStack(spacing: 10) {
                fieldBlock(label: "LATITUDE") {
                    TextField("Latitude", value: $contentData.latitude, format: .number)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(hex: "06141B"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
                }
                fieldBlock(label: "LONGITUDE") {
                    TextField("Longitude", value: $contentData.longitude, format: .number)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(hex: "06141B"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
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
                                .foregroundColor(contentData.socialPlatform == p ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(contentData.socialPlatform == p ? Color(hex: "4A5C6A") : Color(hex: "253745"))
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
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 16, weight: .bold))
                    TextField("username", text: $contentData.socialUsername)
                        .autocapitalization(.none)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    if !contentData.socialUsername.isEmpty {
                        clearButton { contentData.socialUsername = "" }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(hex: "06141B"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "253745"), lineWidth: 1))
            }
        }
    }
    
    // MARK: - Helper UI Components
    private func fieldBlock<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "9BA8AB"))
                .tracking(1.0)
            
            content()
        }
    }
    
    private func clearButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(Color(hex: "9BA8AB"))
                .font(.system(size: 14))
        }
    }
}
