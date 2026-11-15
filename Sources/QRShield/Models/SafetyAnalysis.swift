import SwiftUI

public enum SafetyStatus: String, Codable {
    case safe = "Safe"
    case suspicious = "Suspicious"
    case dangerous = "Dangerous"
    
    public var title: String { rawValue }
    
    public var subtitle: String {
        switch self {
        case .safe:
            return "This link looks safe to visit."
        case .suspicious:
            return "This link may not be safe. Proceed with caution."
        case .dangerous:
            return "This link is unsafe and may harm your device or steal data."
        }
    }
    
    public var iconName: String {
        switch self {
        case .safe:
            return "checkmark.shield.fill"
        case .suspicious:
            return "exclamationmark.triangle.fill"
        case .dangerous:
            return "skull.fill"
        }
    }
    
    public var primaryColor: Color {
        switch self {
        case .safe:
            return Color(hex: "10B981") // Emerald Green
        case .suspicious:
            return Color(hex: "F59E0B") // Amber / Orange
        case .dangerous:
            return Color(hex: "EF4444") // Crimson Red
        }
    }
    
    public var topGradientColors: [Color] {
        switch self {
        case .safe:
            return [Color(hex: "065F46"), Color(hex: "047857"), Color(hex: "10B981")]
        case .suspicious:
            return [Color(hex: "92400E"), Color(hex: "B45309"), Color(hex: "F59E0B")]
        case .dangerous:
            return [Color(hex: "7F1D1D"), Color(hex: "991B1B"), Color(hex: "DC2626")]
        }
    }
}

public struct SafetyAnalysisResult: Identifiable, Codable, Equatable {
    public var id = UUID()
    public let urlString: String
    public let status: SafetyStatus
    public let scannedAt: Date
    
    // Details for Safe
    public var siteType: String?
    public var sslSecure: String?
    public var reputation: String?
    
    // Details for Suspicious
    public var issuesFound: String?
    
    // Details for Dangerous
    public var threatType: String?
    
    // Shared
    public var riskLevel: String?
    public var recommendation: String?
    
    public init(
        urlString: String,
        status: SafetyStatus,
        scannedAt: Date = Date(),
        siteType: String? = nil,
        sslSecure: String? = nil,
        reputation: String? = nil,
        issuesFound: String? = nil,
        threatType: String? = nil,
        riskLevel: String? = nil,
        recommendation: String? = nil
    ) {
        self.urlString = urlString
        self.status = status
        self.scannedAt = scannedAt
        self.siteType = siteType
        self.sslSecure = sslSecure
        self.reputation = reputation
        self.issuesFound = issuesFound
        self.threatType = threatType
        self.riskLevel = riskLevel
        self.recommendation = recommendation
    }
}

public enum SafetyCheckStep: Int, CaseIterable, Identifiable {
    case readingQRCode = 0
    case extractingLink = 1
    case analyzingThreats = 2
    case checkingDatabase = 3
    
    public var id: Int { rawValue }
    
    public var label: String {
        switch self {
        case .readingQRCode: return "Reading QR code..."
        case .extractingLink: return "Extracting link..."
        case .analyzingThreats: return "Analyzing for threats..."
        case .checkingDatabase: return "Checking against safety database..."
        }
    }
}
