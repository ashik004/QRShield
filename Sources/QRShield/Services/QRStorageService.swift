import SwiftUI
import Combine

@MainActor
public final class QRStorageService: ObservableObject {
    public static let shared = QRStorageService()
    
    private let savedCodesKey = "QRShield_SavedCodes_v1"
    private let scanHistoryKey = "QRShield_ScanHistory_v1"
    
    @Published public var savedCodes: [QRCodeItem] = [] {
        didSet {
            persistSavedCodes()
        }
    }
    
    @Published public var scanHistory: [SafetyAnalysisResult] = [] {
        didSet {
            persistScanHistory()
        }
    }
    
    private init() {
        loadData()
    }
    
    private func loadData() {
        // Load Saved Codes
        if let data = UserDefaults.standard.data(forKey: savedCodesKey),
           let decoded = try? JSONDecoder().decode([QRCodeItem].self, from: data) {
            self.savedCodes = decoded
        } else {
            // Seed sample data matching the design!
            self.savedCodes = QRCodeItem.sampleItems
        }
        
        // Load Scan History
        if let data = UserDefaults.standard.data(forKey: scanHistoryKey),
           let decoded = try? JSONDecoder().decode([SafetyAnalysisResult].self, from: data) {
            self.scanHistory = decoded
        } else {
            // Seed initial scan history
            self.scanHistory = [
                SafetyAnalysisResult(
                    urlString: "https://www.instagram.com",
                    status: .safe,
                    scannedAt: Date(),
                    siteType: "Social Media",
                    sslSecure: "Yes",
                    reputation: "Good"
                ),
                SafetyAnalysisResult(
                    urlString: "http://promo-free-gift.com",
                    status: .suspicious,
                    scannedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                    issuesFound: "Unverified website",
                    riskLevel: "Medium",
                    recommendation: "Avoid if not trusted"
                ),
                SafetyAnalysisResult(
                    urlString: "http://free-iphone-win.ru",
                    status: .dangerous,
                    scannedAt: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                    threatType: "Phishing",
                    riskLevel: "High",
                    recommendation: "Do not open"
                )
            ]
        }
    }
    
    private func persistSavedCodes() {
        if let encoded = try? JSONEncoder().encode(savedCodes) {
            UserDefaults.standard.set(encoded, forKey: savedCodesKey)
        }
    }
    
    private func persistScanHistory() {
        if let encoded = try? JSONEncoder().encode(scanHistory) {
            UserDefaults.standard.set(encoded, forKey: scanHistoryKey)
        }
    }
    
    // MARK: - Actions
    
    public func save(item: QRCodeItem) {
        if let index = savedCodes.firstIndex(where: { $0.id == item.id }) {
            savedCodes[index] = item
        } else {
            savedCodes.insert(item, at: 0)
        }
    }
    
    public func toggleFavorite(for id: UUID) {
        if let index = savedCodes.firstIndex(where: { $0.id == id }) {
            savedCodes[index].isFavorite.toggle()
        }
    }
    
    public func delete(id: UUID) {
        savedCodes.removeAll { $0.id == id }
    }
    
    public func recordScan(result: SafetyAnalysisResult) {
        // Remove existing duplicate if present to keep at top
        scanHistory.removeAll { $0.urlString == result.urlString }
        scanHistory.insert(result, at: 0)
    }
    
    public func clearScanHistory() {
        scanHistory.removeAll()
    }
}
