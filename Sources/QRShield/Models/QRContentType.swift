import SwiftUI

/// Represents the content payload type for a QR Code
public enum QRContentType: String, CaseIterable, Identifiable, Codable {
    case website = "Website / Link"
    case wifi = "Wi-Fi"
    case contact = "Contact (vCard)"
    case phone = "Phone Number"
    case text = "Text"
    case email = "Email"
    case location = "Location"
    case social = "Social Media"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .website: return "link"
        case .wifi: return "wifi"
        case .contact: return "person.crop.rectangle.fill"
        case .phone: return "phone.fill"
        case .text: return "textformat"
        case .email: return "envelope.fill"
        case .location: return "mappin.and.ellipse"
        case .social: return "person.2.fill"
        }
    }
    
    public var category: QRTemplateCategory {
        switch self {
        case .website, .contact: return .business
        case .wifi: return .wifi
        case .social: return .social
        case .phone, .text, .email, .location: return .all
        }
    }
}

/// Structured data inputs for each QR content type
public struct QRContentData: Codable, Equatable {
    public var type: QRContentType
    
    // Website
    public var url: String = "https://www.instagram.com"
    
    // Wi-Fi
    public var wifiSSID: String = ""
    public var wifiPassword: String = ""
    public var wifiEncryption: String = "WPA" // WPA, WEP, None
    public var wifiIsHidden: Bool = false
    
    // Contact / vCard
    public var firstName: String = ""
    public var lastName: String = ""
    public var contactPhone: String = ""
    public var contactEmail: String = ""
    public var company: String = ""
    public var jobTitle: String = ""
    public var websiteUrl: String = ""
    
    // Phone
    public var phoneNumber: String = ""
    
    // Plain Text
    public var plainText: String = ""
    
    // Email
    public var emailAddress: String = ""
    public var emailSubject: String = ""
    public var emailBody: String = ""
    
    // Location
    public var latitude: Double = 37.7749
    public var longitude: Double = -122.4194
    public var locationName: String = "San Francisco, CA"
    
    // Social Media
    public var socialPlatform: SocialPlatform = .instagram
    public var socialUsername: String = ""
    
    public init(type: QRContentType = .website) {
        self.type = type
    }
    
    /// Generates the raw encoded string for QR generation
    public var payloadString: String {
        switch type {
        case .website:
            var cleaned = url.trimmingCharacters(in: .whitespacesAndNewlines)
            if !cleaned.isEmpty && !cleaned.lowercased().hasPrefix("http://") && !cleaned.lowercased().hasPrefix("https://") {
                cleaned = "https://" + cleaned
            }
            return cleaned.isEmpty ? "https://qrshield.app" : cleaned
            
        case .wifi:
            let hiddenTag = wifiIsHidden ? "H:true;" : ""
            let auth = wifiEncryption == "None" ? "nopass" : wifiEncryption
            let ssid = wifiSSID.isEmpty ? "MyWiFi_Network" : wifiSSID
            return "WIFI:T:\(auth);S:\(ssid);P:\(wifiPassword);\(hiddenTag);"
            
        case .contact:
            let fn = firstName.isEmpty ? "John" : firstName
            let ln = lastName.isEmpty ? "Doe" : lastName
            var vcard = "BEGIN:VCARD\nVERSION:3.0\n"
            vcard += "N:\(ln);\(fn);;;\n"
            vcard += "FN:\(fn) \(ln)\n"
            if !company.isEmpty { vcard += "ORG:\(company)\n" }
            if !jobTitle.isEmpty { vcard += "TITLE:\(jobTitle)\n" }
            let phone = contactPhone.isEmpty ? "+15551234567" : contactPhone
            vcard += "TEL;TYPE=CELL:\(phone)\n"
            if !contactEmail.isEmpty { vcard += "EMAIL:\(contactEmail)\n" }
            if !websiteUrl.isEmpty { vcard += "URL:\(websiteUrl)\n" }
            vcard += "END:VCARD"
            return vcard
            
        case .phone:
            let clean = phoneNumber.filter { "0123456789+".contains($0) }
            return "tel:\(clean.isEmpty ? "+15551234567" : clean)"
            
        case .text:
            return plainText.isEmpty ? "Hello from QR Shield" : plainText
            
        case .email:
            let mail = emailAddress.isEmpty ? "contact@qrshield.app" : emailAddress
            let encodedSubject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedBody = emailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "mailto:\(mail)?subject=\(encodedSubject)&body=\(encodedBody)"
            
        case .location:
            let name = locationName.isEmpty ? "San Francisco" : locationName
            return "geo:\(latitude),\(longitude)?q=\(latitude),\(longitude)(\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            
        case .social:
            var user = socialUsername.trimmingCharacters(in: CharacterSet(charactersIn: "@ "))
            if user.isEmpty { user = "qrshield" }
            switch socialPlatform {
            case .instagram: return "https://instagram.com/\(user)"
            case .youtube: return "https://youtube.com/@\(user)"
            case .whatsapp: return "https://wa.me/\(user.filter { "0123456789".contains($0) })"
            case .twitter: return "https://x.com/\(user)"
            case .tiktok: return "https://tiktok.com/@\(user)"
            case .linkedin: return "https://linkedin.com/in/\(user)"
            }
        }
    }
}

public enum SocialPlatform: String, CaseIterable, Identifiable, Codable {
    case instagram = "Instagram"
    case youtube = "YouTube"
    case whatsapp = "WhatsApp"
    case twitter = "X (Twitter)"
    case tiktok = "TikTok"
    case linkedin = "LinkedIn"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .instagram: return "camera.fill"
        case .youtube: return "play.rectangle.fill"
        case .whatsapp: return "message.fill"
        case .twitter: return "bubble.left.and.bubble.right.fill"
        case .tiktok: return "music.note"
        case .linkedin: return "briefcase.fill"
        }
    }
}
