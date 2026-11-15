import XCTest
@testable import QRShield

final class QRShieldTests: XCTestCase {
    func testSafetyCheckerSafe() {
        let result = SafetyCheckerService.shared.analyze(rawContent: "https://www.instagram.com")
        XCTAssertEqual(result.status, .safe)
        XCTAssertEqual(result.siteType, "Social Media")
        XCTAssertEqual(result.sslSecure, "Yes")
        XCTAssertEqual(result.reputation, "Good")
    }
    
    func testSafetyCheckerSuspicious() {
        let result = SafetyCheckerService.shared.analyze(rawContent: "http://promo-free-gift.com")
        XCTAssertEqual(result.status, .suspicious)
        XCTAssertEqual(result.issuesFound, "Unverified website")
        XCTAssertEqual(result.riskLevel, "Medium")
    }
    
    func testSafetyCheckerDangerous() {
        let result = SafetyCheckerService.shared.analyze(rawContent: "http://free-iphone-win.ru")
        XCTAssertEqual(result.status, .dangerous)
        XCTAssertEqual(result.threatType, "Phishing")
        XCTAssertEqual(result.riskLevel, "High")
        XCTAssertEqual(result.recommendation, "Do not open")
    }
    
    func testQRCodeGeneratorService() {
        let style = QRStyleConfig(
            dotStyle: .rounded,
            colorTheme: .instagramSunset,
            backgroundColorHex: "FFFFFF",
            logoType: .instagram
        )
        let image = QRCodeGeneratorService.shared.generateQRCode(from: "https://instagram.com/qrshield", style: style)
        XCTAssertNotNil(image)
        XCTAssertGreaterThan(image?.size.width ?? 0, 100)
    }
    
    func testWiFiPayload() {
        var data = QRContentData(type: .wifi)
        data.wifiSSID = "MyNetwork"
        data.wifiPassword = "Password123"
        data.wifiEncryption = "WPA"
        
        XCTAssertTrue(data.payloadString.contains("S:MyNetwork;"))
        XCTAssertTrue(data.payloadString.contains("P:Password123;"))
    }
}
