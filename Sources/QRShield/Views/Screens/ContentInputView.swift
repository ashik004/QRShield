import SwiftUI

public struct ContentInputView: View {
    public let item: GeneratorItem
    public let selectedTemplate: QRTemplate?
    public var onBack: () -> Void
    public var onCreate: (String, QRContentType) -> Void
    
    // Input state variables
    @State private var textInput: String = ""
    @State private var secondaryInput: String = ""
    @State private var tertiaryInput: String = ""
    @State private var quaternaryInput: String = ""
    @State private var quinaryInput: String = ""
    @State private var wifiSecurity: String = "WPA"
    @State private var showPassword: Bool = false
    
    public init(
        item: GeneratorItem,
        selectedTemplate: QRTemplate? = nil,
        onBack: @escaping () -> Void,
        onCreate: @escaping (String, QRContentType) -> Void
    ) {
        self.item = item
        self.selectedTemplate = selectedTemplate
        self.onBack = onBack
        self.onCreate = onCreate
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            topNavigationBar
            
            // Scrollable Form Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Item Information Hero Banner
                    itemHeroCard
                    
                    // Selected Template Info (if applicable)
                    if let t = selectedTemplate {
                        templateNoticeCard(t)
                    }
                    
                    // Form Fields Section
                    VStack(alignment: .leading, spacing: 16) {
                        inputFields
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            
            // Bottom Sticky Create Button
            bottomCreateBar
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "06141B").ignoresSafeArea())
        .onAppear {
            if let t = selectedTemplate, !t.defaultContent.isEmpty {
                textInput = t.defaultContent
            }
        }
    }
    
    // MARK: - Top Navigation Bar
    private var topNavigationBar: some View {
        HStack {
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
            .buttonStyle(.plain)
            
            Spacer()
            
            Text(item.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "CCD0CF"))
            
            Spacer()
            
            if item.isPro {
                Text("PRO")
                    .font(.system(size: 11, weight: .black))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "4A5C6A"))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .clipShape(Capsule())
            } else {
                Color.clear.frame(width: 38, height: 38)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(Color(hex: "06141B"))
    }
    
    // MARK: - Hero Banner Card
    private var itemHeroCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(hex: "253745"))
                    .frame(width: 50, height: 50)
                
                Image(systemName: item.iconName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color(hex: "CCD0CF"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    Text(item.category.rawValue)
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2.5)
                        .background(Color(hex: "253745"))
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .clipShape(Capsule())
                }
                
                Text(subtitle(for: item))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "9BA8AB"))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(hex: "11212D"))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color(hex: "253745"), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Selected Template Notice Card
    private func templateNoticeCard(_ t: QRTemplate) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "paintpalette.fill")
                .foregroundColor(Color(hex: "4A5C6A"))
                .font(.system(size: 15))
            
            Text("Applying template: \(t.name)")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "CCD0CF"))
            
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(hex: "11212D"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "253745"), lineWidth: 1)
        )
    }
    
    // MARK: - Input Fields Per Item
    @ViewBuilder
    private var inputFields: some View {
        switch item.id {
        case "wifi":
            fieldBlock(label: "NETWORK NAME (SSID)") {
                styledTextField(placeholder: "Enter Wi-Fi network name", text: $textInput, icon: "wifi")
            }
            fieldBlock(label: "PASSWORD") {
                HStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color(hex: "4A5C6A"))
                        .font(.system(size: 15))
                    
                    if showPassword {
                        TextField("Enter password", text: $secondaryInput)
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    } else {
                        SecureField("Enter password", text: $secondaryInput)
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
                .padding(.vertical, 14)
                .background(Color(hex: "11212D"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "253745"), lineWidth: 1))
            }
            fieldBlock(label: "SECURITY TYPE") {
                HStack(spacing: 8) {
                    ForEach(["WPA", "WEP", "None"], id: \.self) { enc in
                        Button(action: { wifiSecurity = enc }) {
                            Text(enc == "None" ? "Open" : enc)
                                .font(.system(size: 14, weight: wifiSecurity == enc ? .bold : .medium))
                                .foregroundColor(wifiSecurity == enc ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 42)
                                .background(
                                    Capsule().fill(wifiSecurity == enc ? Color(hex: "4A5C6A") : Color(hex: "11212D"))
                                        .overlay(Capsule().stroke(Color(hex: "253745"), lineWidth: 1))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
        case "contact":
            HStack(spacing: 10) {
                fieldBlock(label: "FIRST NAME") {
                    styledTextField(placeholder: "John", text: $textInput, icon: nil)
                }
                fieldBlock(label: "LAST NAME") {
                    styledTextField(placeholder: "Doe", text: $secondaryInput, icon: nil)
                }
            }
            fieldBlock(label: "PHONE NUMBER") {
                styledTextField(placeholder: "+1 (555) 123-4567", text: $tertiaryInput, icon: "phone.fill", keyboardType: .phonePad)
            }
            fieldBlock(label: "EMAIL ADDRESS") {
                styledTextField(placeholder: "john@example.com", text: $quaternaryInput, icon: "envelope.fill", keyboardType: .emailAddress)
            }
            fieldBlock(label: "ORGANIZATION / COMPANY") {
                styledTextField(placeholder: "Company name", text: $quinaryInput, icon: "briefcase.fill")
            }
            
        case "text":
            fieldBlock(label: "MESSAGE OR PLAIN TEXT") {
                TextEditor(text: $textInput)
                    .frame(height: 140)
                    .padding(10)
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .scrollContentBackground(.hidden)
                    .background(Color(hex: "11212D"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "253745"), lineWidth: 1)
                    )
            }
            
        case "email":
            fieldBlock(label: "RECIPIENT EMAIL") {
                styledTextField(placeholder: "recipient@example.com", text: $textInput, icon: "envelope.fill", keyboardType: .emailAddress)
            }
            fieldBlock(label: "SUBJECT") {
                styledTextField(placeholder: "Email Subject", text: $secondaryInput, icon: "pencil")
            }
            fieldBlock(label: "MESSAGE") {
                styledTextField(placeholder: "Message text...", text: $tertiaryInput, icon: "text.alignleft")
            }
            
        case "sms":
            fieldBlock(label: "RECIPIENT PHONE NUMBER") {
                styledTextField(placeholder: "+1 (555) 000-0000", text: $textInput, icon: "phone.fill", keyboardType: .phonePad)
            }
            fieldBlock(label: "PRE-FILLED SMS MESSAGE") {
                styledTextField(placeholder: "Optional text message...", text: $secondaryInput, icon: "bubble.left.fill")
            }
            
        case "phone", "viber":
            fieldBlock(label: "PHONE NUMBER") {
                styledTextField(placeholder: "+1 (555) 000-0000", text: $textInput, icon: "phone.fill", keyboardType: .phonePad)
            }
            
        case "location", "googleplacereviews":
            fieldBlock(label: "LOCATION NAME OR ADDRESS") {
                styledTextField(placeholder: "e.g. Times Square, New York", text: $textInput, icon: "mappin.and.ellipse")
            }
            HStack(spacing: 10) {
                fieldBlock(label: "LATITUDE (OPTIONAL)") {
                    styledTextField(placeholder: "37.7749", text: $secondaryInput, icon: nil, keyboardType: .decimalPad)
                }
                fieldBlock(label: "LONGITUDE (OPTIONAL)") {
                    styledTextField(placeholder: "-122.4194", text: $tertiaryInput, icon: nil, keyboardType: .decimalPad)
                }
            }
            
        case "event":
            fieldBlock(label: "EVENT TITLE") {
                styledTextField(placeholder: "e.g. Annual Design Summit", text: $textInput, icon: "calendar")
            }
            fieldBlock(label: "LOCATION OR MEETING LINK") {
                styledTextField(placeholder: "e.g. Hall B or Zoom URL", text: $secondaryInput, icon: "location.fill")
            }
            fieldBlock(label: "DESCRIPTION OR WEBSITE") {
                styledTextField(placeholder: "https://event.example.com", text: $tertiaryInput, icon: "link")
            }
            
        case "bitcoin":
            fieldBlock(label: "BITCOIN WALLET ADDRESS") {
                styledTextField(placeholder: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa", text: $textInput, icon: "bitcoinsign.circle")
            }
            fieldBlock(label: "AMOUNT IN BTC (OPTIONAL)") {
                styledTextField(placeholder: "0.05", text: $secondaryInput, icon: "dollarsign", keyboardType: .decimalPad)
            }
            
        case "ethereum":
            fieldBlock(label: "ETHEREUM WALLET ADDRESS") {
                styledTextField(placeholder: "0x71C...497", text: $textInput, icon: "rhombus.fill")
            }
            fieldBlock(label: "AMOUNT IN ETH (OPTIONAL)") {
                styledTextField(placeholder: "1.0", text: $secondaryInput, icon: "dollarsign", keyboardType: .decimalPad)
            }
            
        default:
            fieldBlock(label: "\(item.title.uppercased()) VALUE") {
                HStack(spacing: 10) {
                    if let prefix = item.prefix {
                        Text(prefix)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "4A5C6A"))
                    } else {
                        Image(systemName: item.iconName)
                            .foregroundColor(Color(hex: "4A5C6A"))
                            .font(.system(size: 15))
                    }
                    
                    TextField(item.placeholder.isEmpty ? "Enter content" : item.placeholder, text: $textInput)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .autocapitalization(.none)
                    
                    if !textInput.isEmpty {
                        Button(action: { textInput = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(hex: "9BA8AB"))
                                .font(.system(size: 14))
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Color(hex: "11212D"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "253745"), lineWidth: 1))
            }
        }
    }
    
    // MARK: - Bottom Sticky Create Bar
    private var bottomCreateBar: some View {
        VStack(spacing: 0) {
            Button(action: {
                let feedback = UIImpactFeedbackGenerator(style: .medium)
                feedback.impactOccurred()
                let payload = compilePayload()
                onCreate(payload, item.contentType)
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
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .background(Color(hex: "11212D"))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex: "253745")),
            alignment: .top
        )
    }
    
    // MARK: - Payload Compiler
    private func compilePayload() -> String {
        switch item.id {
        case "wifi":
            let auth = wifiSecurity == "None" ? "nopass" : wifiSecurity
            let ssid = textInput.isEmpty ? "MyWiFi" : textInput
            return "WIFI:T:\(auth);S:\(ssid);P:\(secondaryInput);;"
            
        case "contact":
            let fn = textInput.isEmpty ? "John" : textInput
            let ln = secondaryInput.isEmpty ? "Doe" : secondaryInput
            var vcard = "BEGIN:VCARD\nVERSION:3.0\nN:\(ln);\(fn);;;\nFN:\(fn) \(ln)\n"
            if !tertiaryInput.isEmpty { vcard += "TEL;TYPE=CELL:\(tertiaryInput)\n" }
            if !quaternaryInput.isEmpty { vcard += "EMAIL:\(quaternaryInput)\n" }
            if !quinaryInput.isEmpty { vcard += "ORG:\(quinaryInput)\n" }
            vcard += "END:VCARD"
            return vcard
            
        case "text":
            return textInput.isEmpty ? "Hello from QR Shield" : textInput
            
        case "email":
            let mail = textInput.isEmpty ? "contact@qrshield.app" : textInput
            let sub = secondaryInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let body = tertiaryInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "mailto:\(mail)?subject=\(sub)&body=\(body)"
            
        case "sms":
            let phone = textInput.filter { "0123456789+".contains($0) }
            let msg = secondaryInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "smsto:\(phone):\(msg)"
            
        case "phone":
            let clean = textInput.filter { "0123456789+".contains($0) }
            return "tel:\(clean.isEmpty ? "+15551234567" : clean)"
            
        case "location":
            let name = textInput.isEmpty ? "Location" : textInput
            if let lat = Double(secondaryInput), let lon = Double(tertiaryInput) {
                return "geo:\(lat),\(lon)?q=\(lat),\(lon)(\(name))"
            }
            return "https://maps.apple.com/?q=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            
        case "event":
            return "BEGIN:VEVENT\nSUMMARY:\(textInput)\nLOCATION:\(secondaryInput)\nDESCRIPTION:\(tertiaryInput)\nEND:VEVENT"
            
        case "bitcoin":
            var btc = "bitcoin:\(textInput.isEmpty ? "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa" : textInput)"
            if !secondaryInput.isEmpty { btc += "?amount=\(secondaryInput)" }
            return btc
            
        case "ethereum":
            var eth = "ethereum:\(textInput.isEmpty ? "0x0000000000000000000000000000000000000000" : textInput)"
            if !secondaryInput.isEmpty { eth += "?value=\(secondaryInput)" }
            return eth
            
        default:
            var val = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
            if let prefix = item.prefix {
                let cleaned = val.trimmingCharacters(in: CharacterSet(charactersIn: "@/# "))
                if cleaned.isEmpty {
                    return "\(prefix)qrshield"
                }
                if val.hasPrefix("http://") || val.hasPrefix("https://") {
                    return val
                }
                return "\(prefix)\(cleaned)"
            }
            if val.isEmpty {
                return item.placeholder.isEmpty ? "QR Shield Item" : item.placeholder
            }
            return val
        }
    }
    
    // MARK: - Subtitle Helper
    private func subtitle(for item: GeneratorItem) -> String {
        switch item.id {
        case "url": return "Create a QR code that directly opens your website or link."
        case "contact": return "Generate a full contact card (vCard) for quick address book saving."
        case "wifi": return "Share quick Wi-Fi network connection without sharing passwords."
        case "text": return "Store and present formatted plain text notes and instructions."
        case "email": return "Set up a one-tap pre-filled email draft to any address."
        case "sms": return "Generate an instant SMS compose prompt with pre-filled text."
        case "phone": return "Allow users to instantly call your phone number with one tap."
        case "location": return "Drop a precise location pin or navigation landmark on map."
        case "event": return "Share calendar events, webinars, or meetups directly."
        case "bitcoin": return "Accept cryptocurrency payments directly to your Bitcoin wallet."
        case "ethereum": return "Accept ETH or smart-contract transfers to your Ethereum address."
        default:
            if item.category == .barcode {
                return "Generate a crisp, standard \(item.title) encoded barcode."
            } else if item.category == .social {
                return "Link directly to your official \(item.title) profile or channel."
            } else {
                return "Generate a fast, scannable QR code for \(item.title)."
            }
        }
    }
    
    // MARK: - Helper UI Builders
    private func fieldBlock<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "9BA8AB"))
                .tracking(1.0)
            
            content()
        }
    }
    
    private func styledTextField(
        placeholder: String,
        text: Binding<String>,
        icon: String?,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        HStack(spacing: 10) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: "4A5C6A"))
                    .font(.system(size: 15))
            }
            
            TextField(placeholder, text: text)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "CCD0CF"))
                .keyboardType(keyboardType)
                .autocapitalization(.none)
            
            if !text.wrappedValue.isEmpty {
                Button(action: { text.wrappedValue = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "9BA8AB"))
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color(hex: "11212D"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "253745"), lineWidth: 1))
    }
}
