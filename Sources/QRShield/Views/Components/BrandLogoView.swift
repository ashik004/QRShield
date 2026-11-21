import SwiftUI
import UIKit

// MARK: - Supported Brand Identifier
public enum BrandType: String, CaseIterable, Identifiable, Codable {
    // Social Media Brands
    case youtube = "youtube"
    case facebook = "facebook"
    case whatsapp = "whatsapp"
    case instagram = "instagram"
    case tiktok = "tiktok"
    case wechat = "wechat"
    case telegram = "telegram"
    case snapchat = "snapchat"
    case x = "x"
    case spotify = "spotify"
    case pinterest = "pinterest"
    case linkedin = "linkedin"
    case reddit = "reddit"
    case discord = "discord"
    case threads = "threads"
    case line = "line"
    case viber = "viber"
    case kakaotalk = "kakaotalk"
    case github = "github"
    
    // Business Brands
    case bitcoin = "bitcoin"
    case ethereum = "ethereum"
    case paypal = "paypal"
    case venmo = "venmo"
    case cashapp = "cashapp"
    case stripe = "stripe"
    case appstore = "appstore"
    case appstorereviews = "appstorereviews"
    case googlemaps = "googlemaps"
    case googleplacereviews = "googleplacereviews"
    case zoom = "zoom"
    case googlemeet = "googlemeet"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .youtube: return "YouTube"
        case .facebook: return "Facebook"
        case .whatsapp: return "WhatsApp"
        case .instagram: return "Instagram"
        case .tiktok: return "TikTok"
        case .wechat: return "WeChat"
        case .telegram: return "Telegram"
        case .snapchat: return "Snapchat"
        case .x: return "X"
        case .spotify: return "Spotify"
        case .pinterest: return "Pinterest"
        case .linkedin: return "LinkedIn"
        case .reddit: return "Reddit"
        case .discord: return "Discord"
        case .threads: return "Threads"
        case .line: return "LINE"
        case .viber: return "Viber"
        case .kakaotalk: return "KakaoTalk"
        case .github: return "GitHub"
        case .bitcoin: return "Bitcoin"
        case .ethereum: return "Ethereum"
        case .paypal: return "PayPal"
        case .venmo: return "Venmo"
        case .cashapp: return "Cash App"
        case .stripe: return "Stripe"
        case .appstore: return "App Store"
        case .appstorereviews: return "App Store reviews"
        case .googlemaps: return "Google Maps"
        case .googleplacereviews: return "Google Place reviews"
        case .zoom: return "Zoom"
        case .googlemeet: return "Google Meet"
        }
    }
    
    public static func match(from string: String) -> BrandType? {
        let clean = string.lowercased().replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "_", with: "").replacingOccurrences(of: " ", with: "")
        for brand in BrandType.allCases {
            let bClean = brand.rawValue.lowercased().replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "_", with: "")
            if clean == bClean || clean.contains(bClean) {
                return brand
            }
        }
        return nil
    }
}

// MARK: - High-Precision Vector Brand Logo Renderer
public final class BrandLogoRenderer {
    private static let cache = NSCache<NSString, UIImage>()
    
    public static func image(for brand: BrandType, size: CGSize = CGSize(width: 84, height: 84)) -> UIImage {
        let key = "\(brand.rawValue)_\(Int(size.width))x\(Int(size.height))" as NSString
        if let cached = cache.object(forKey: key) {
            return cached
        }
        
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.scale = 3.0
        rendererFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        
        let image = renderer.image { ctx in
            let cg = ctx.cgContext
            draw(brand: brand, in: CGRect(origin: .zero, size: size), in: cg)
        }
        
        cache.setObject(image, forKey: key)
        return image
    }
    
    public static func draw(brand: BrandType, in rect: CGRect, in cg: CGContext) {
        cg.saveGState()
        
        let cornerRadius = rect.width * 0.28
        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        clipPath.addClip()
        
        // Normalize context coordinate system to 100 x 100 for vector drawing
        cg.translateBy(x: rect.minX, y: rect.minY)
        cg.scaleBy(x: rect.width / 100.0, y: rect.height / 100.0)
        
        let canvas = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        switch brand {
        case .youtube:
            drawYouTube(canvas: canvas, cg: cg)
        case .facebook:
            drawFacebook(canvas: canvas, cg: cg)
        case .whatsapp:
            drawWhatsApp(canvas: canvas, cg: cg)
        case .instagram:
            drawInstagram(canvas: canvas, cg: cg)
        case .tiktok:
            drawTikTok(canvas: canvas, cg: cg)
        case .wechat:
            drawWeChat(canvas: canvas, cg: cg)
        case .telegram:
            drawTelegram(canvas: canvas, cg: cg)
        case .snapchat:
            drawSnapchat(canvas: canvas, cg: cg)
        case .x:
            drawX(canvas: canvas, cg: cg)
        case .spotify:
            drawSpotify(canvas: canvas, cg: cg)
        case .pinterest:
            drawPinterest(canvas: canvas, cg: cg)
        case .linkedin:
            drawLinkedIn(canvas: canvas, cg: cg)
        case .reddit:
            drawReddit(canvas: canvas, cg: cg)
        case .discord:
            drawDiscord(canvas: canvas, cg: cg)
        case .threads:
            drawThreads(canvas: canvas, cg: cg)
        case .line:
            drawLine(canvas: canvas, cg: cg)
        case .viber:
            drawViber(canvas: canvas, cg: cg)
        case .kakaotalk:
            drawKakaoTalk(canvas: canvas, cg: cg)
        case .github:
            drawGitHub(canvas: canvas, cg: cg)
        case .bitcoin:
            drawBitcoin(canvas: canvas, cg: cg)
        case .ethereum:
            drawEthereum(canvas: canvas, cg: cg)
        case .paypal:
            drawPayPal(canvas: canvas, cg: cg)
        case .venmo:
            drawVenmo(canvas: canvas, cg: cg)
        case .cashapp:
            drawCashApp(canvas: canvas, cg: cg)
        case .stripe:
            drawStripe(canvas: canvas, cg: cg)
        case .appstore, .appstorereviews:
            drawAppStore(canvas: canvas, cg: cg)
        case .googlemaps:
            drawGoogleMaps(canvas: canvas, cg: cg, showStar: false)
        case .googleplacereviews:
            drawGoogleMaps(canvas: canvas, cg: cg, showStar: true)
        case .zoom:
            drawZoom(canvas: canvas, cg: cg)
        case .googlemeet:
            drawGoogleMeet(canvas: canvas, cg: cg)
        }
        
        cg.restoreGState()
    }
    
    // MARK: - 1. YouTube
    private static func drawYouTube(canvas: CGRect, cg: CGContext) {
        UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 40, y: 32))
        path.addLine(to: CGPoint(x: 68, y: 50))
        path.addLine(to: CGPoint(x: 40, y: 68))
        path.close()
        UIColor.white.setFill()
        path.fill()
    }
    
    // MARK: - 2. Facebook
    private static func drawFacebook(canvas: CGRect, cg: CGContext) {
        UIColor(red: 24/255.0, green: 119/255.0, blue: 242/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 58, y: 95))
        path.addLine(to: CGPoint(x: 58, y: 56))
        path.addLine(to: CGPoint(x: 71, y: 56))
        path.addLine(to: CGPoint(x: 73, y: 41))
        path.addLine(to: CGPoint(x: 58, y: 41))
        path.addLine(to: CGPoint(x: 58, y: 31))
        path.addCurve(to: CGPoint(x: 64, y: 22), controlPoint1: CGPoint(x: 58, y: 26), controlPoint2: CGPoint(x: 60, y: 22))
        path.addLine(to: CGPoint(x: 74, y: 22))
        path.addLine(to: CGPoint(x: 74, y: 9))
        path.addLine(to: CGPoint(x: 59, y: 9))
        path.addCurve(to: CGPoint(x: 44, y: 28), controlPoint1: CGPoint(x: 47, y: 9), controlPoint2: CGPoint(x: 44, y: 17))
        path.addLine(to: CGPoint(x: 44, y: 41))
        path.addLine(to: CGPoint(x: 32, y: 41))
        path.addLine(to: CGPoint(x: 32, y: 56))
        path.addLine(to: CGPoint(x: 44, y: 56))
        path.addLine(to: CGPoint(x: 44, y: 95))
        path.close()
        
        UIColor.white.setFill()
        path.fill()
    }
    
    // MARK: - 3. WhatsApp
    private static func drawWhatsApp(canvas: CGRect, cg: CGContext) {
        UIColor(red: 37/255.0, green: 211/255.0, blue: 102/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        // White circular bubble with tail
        let bubble = UIBezierPath()
        bubble.move(to: CGPoint(x: 50, y: 18))
        bubble.addCurve(to: CGPoint(x: 82, y: 50), controlPoint1: CGPoint(x: 68, y: 18), controlPoint2: CGPoint(x: 82, y: 32))
        bubble.addCurve(to: CGPoint(x: 50, y: 82), controlPoint1: CGPoint(x: 82, y: 68), controlPoint2: CGPoint(x: 68, y: 82))
        bubble.addCurve(to: CGPoint(x: 27, y: 76), controlPoint1: CGPoint(x: 41, y: 82), controlPoint2: CGPoint(x: 33, y: 80))
        bubble.addLine(to: CGPoint(x: 18, y: 82))
        bubble.addLine(to: CGPoint(x: 23, y: 71))
        bubble.addCurve(to: CGPoint(x: 18, y: 50), controlPoint1: CGPoint(x: 20, y: 65), controlPoint2: CGPoint(x: 18, y: 58))
        bubble.addCurve(to: CGPoint(x: 50, y: 18), controlPoint1: CGPoint(x: 18, y: 32), controlPoint2: CGPoint(x: 32, y: 18))
        bubble.close()
        
        UIColor.white.setStroke()
        bubble.lineWidth = 5
        bubble.stroke()
        
        // Inner phone receiver
        let phone = UIBezierPath()
        phone.move(to: CGPoint(x: 38, y: 34))
        phone.addCurve(to: CGPoint(x: 42, y: 41), controlPoint1: CGPoint(x: 40, y: 34), controlPoint2: CGPoint(x: 42, y: 38))
        phone.addLine(to: CGPoint(x: 40, y: 44))
        phone.addCurve(to: CGPoint(x: 56, y: 60), controlPoint1: CGPoint(x: 44, y: 52), controlPoint2: CGPoint(x: 48, y: 56))
        phone.addLine(to: CGPoint(x: 59, y: 58))
        phone.addCurve(to: CGPoint(x: 66, y: 62), controlPoint1: CGPoint(x: 62, y: 58), controlPoint2: CGPoint(x: 66, y: 60))
        phone.addLine(to: CGPoint(x: 63, y: 67))
        phone.addCurve(to: CGPoint(x: 33, y: 37), controlPoint1: CGPoint(x: 53, y: 72), controlPoint2: CGPoint(x: 28, y: 47))
        phone.close()
        
        UIColor.white.setFill()
        phone.fill()
    }
    
    // MARK: - 4. Instagram
    private static func drawInstagram(canvas: CGRect, cg: CGContext) {
        let colors = [
            UIColor(red: 245/255.0, green: 133/255.0, blue: 41/255.0, alpha: 1.0).cgColor,
            UIColor(red: 221/255.0, green: 42/255.0, blue: 123/255.0, alpha: 1.0).cgColor,
            UIColor(red: 129/255.0, green: 52/255.0, blue: 175/255.0, alpha: 1.0).cgColor,
            UIColor(red: 81/255.0, green: 91/255.0, blue: 212/255.0, alpha: 1.0).cgColor
        ] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 0.4, 0.7, 1.0]) {
            cg.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 100), end: CGPoint(x: 100, y: 0), options: [])
        }
        
        let rect = CGRect(x: 23, y: 23, width: 54, height: 54)
        let outer = UIBezierPath(roundedRect: rect, cornerRadius: 15)
        UIColor.white.setStroke()
        outer.lineWidth = 5.2
        outer.stroke()
        
        let circle = UIBezierPath(ovalIn: CGRect(x: 37, y: 37, width: 26, height: 26))
        circle.lineWidth = 5.2
        circle.stroke()
        
        let dot = UIBezierPath(ovalIn: CGRect(x: 63, y: 31, width: 6, height: 6))
        UIColor.white.setFill()
        dot.fill()
    }
    
    // MARK: - 5. TikTok
    private static func drawTikTok(canvas: CGRect, cg: CGContext) {
        UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        func createNotePath(ox: CGFloat, oy: CGFloat) -> UIBezierPath {
            let p = UIBezierPath()
            p.move(to: CGPoint(x: 52 + ox, y: 22 + oy))
            p.addLine(to: CGPoint(x: 52 + ox, y: 58 + oy))
            p.addCurve(to: CGPoint(x: 34 + ox, y: 74 + oy), controlPoint1: CGPoint(x: 52 + ox, y: 68 + oy), controlPoint2: CGPoint(x: 44 + ox, y: 74 + oy))
            p.addCurve(to: CGPoint(x: 23 + ox, y: 62 + oy), controlPoint1: CGPoint(x: 27 + ox, y: 74 + oy), controlPoint2: CGPoint(x: 23 + ox, y: 68 + oy))
            p.addCurve(to: CGPoint(x: 38 + ox, y: 50 + oy), controlPoint1: CGPoint(x: 23 + ox, y: 54 + oy), controlPoint2: CGPoint(x: 30 + ox, y: 50 + oy))
            p.addLine(to: CGPoint(x: 43 + ox, y: 50 + oy))
            p.addLine(to: CGPoint(x: 43 + ox, y: 22 + oy))
            p.addLine(to: CGPoint(x: 52 + ox, y: 22 + oy))
            p.addCurve(to: CGPoint(x: 74 + ox, y: 44 + oy), controlPoint1: CGPoint(x: 58 + ox, y: 34 + oy), controlPoint2: CGPoint(x: 68 + ox, y: 40 + oy))
            p.addLine(to: CGPoint(x: 74 + ox, y: 34 + oy))
            p.addCurve(to: CGPoint(x: 52 + ox, y: 22 + oy), controlPoint1: CGPoint(x: 66 + ox, y: 30 + oy), controlPoint2: CGPoint(x: 58 + ox, y: 24 + oy))
            p.close()
            return p
        }
        
        // Cyan layer
        let cyan = createNotePath(ox: -2.0, oy: 1.5)
        UIColor(red: 0/255.0, green: 242/255.0, blue: 254/255.0, alpha: 1.0).setFill()
        cyan.fill()
        
        // Red layer
        let red = createNotePath(ox: 2.0, oy: -1.5)
        UIColor(red: 254/255.0, green: 9/255.0, blue: 121/255.0, alpha: 1.0).setFill()
        red.fill()
        
        // White layer
        let white = createNotePath(ox: 0, oy: 0)
        UIColor.white.setFill()
        white.fill()
    }
    
    // MARK: - 6. WeChat
    private static func drawWeChat(canvas: CGRect, cg: CGContext) {
        UIColor(red: 7/255.0, green: 193/255.0, blue: 96/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        // Left bubble
        let b1 = UIBezierPath(ovalIn: CGRect(x: 18, y: 24, width: 48, height: 40))
        UIColor.white.setFill()
        b1.fill()
        let tail1 = UIBezierPath()
        tail1.move(to: CGPoint(x: 25, y: 56))
        tail1.addLine(to: CGPoint(x: 19, y: 66))
        tail1.addLine(to: CGPoint(x: 34, y: 61))
        tail1.close()
        tail1.fill()
        
        // Left eyes
        UIColor(red: 7/255.0, green: 193/255.0, blue: 96/255.0, alpha: 1.0).setFill()
        UIBezierPath(ovalIn: CGRect(x: 32, y: 39, width: 5, height: 5)).fill()
        UIBezierPath(ovalIn: CGRect(x: 46, y: 39, width: 5, height: 5)).fill()
        
        // Right bubble
        let b2 = UIBezierPath(ovalIn: CGRect(x: 44, y: 40, width: 40, height: 34))
        UIColor.white.setFill()
        b2.fill()
        let tail2 = UIBezierPath()
        tail2.move(to: CGPoint(x: 77, y: 66))
        tail2.addLine(to: CGPoint(x: 82, y: 74))
        tail2.addLine(to: CGPoint(x: 70, y: 71))
        tail2.close()
        tail2.fill()
        
        // Right eyes
        UIColor(red: 7/255.0, green: 193/255.0, blue: 96/255.0, alpha: 1.0).setFill()
        UIBezierPath(ovalIn: CGRect(x: 55, y: 52, width: 4.5, height: 4.5)).fill()
        UIBezierPath(ovalIn: CGRect(x: 67, y: 52, width: 4.5, height: 4.5)).fill()
    }
    
    // MARK: - 7. Telegram
    private static func drawTelegram(canvas: CGRect, cg: CGContext) {
        UIColor(red: 36/255.0, green: 161/255.0, blue: 222/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 78, y: 24))
        p.addLine(to: CGPoint(x: 22, y: 48))
        p.addLine(to: CGPoint(x: 41, y: 58))
        p.addLine(to: CGPoint(x: 46, y: 76))
        p.addLine(to: CGPoint(x: 56, y: 66))
        p.addLine(to: CGPoint(x: 71, y: 77))
        p.close()
        
        UIColor.white.setFill()
        p.fill()
        
        let inner = UIBezierPath()
        inner.move(to: CGPoint(x: 41, y: 58))
        inner.addLine(to: CGPoint(x: 68, y: 35))
        inner.addLine(to: CGPoint(x: 46, y: 64))
        inner.close()
        UIColor(white: 0.88, alpha: 1.0).setFill()
        inner.fill()
    }
    
    // MARK: - 8. Snapchat
    private static func drawSnapchat(canvas: CGRect, cg: CGContext) {
        UIColor(red: 255/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let ghost = UIBezierPath()
        ghost.move(to: CGPoint(x: 50, y: 18))
        ghost.addCurve(to: CGPoint(x: 66, y: 34), controlPoint1: CGPoint(x: 60, y: 18), controlPoint2: CGPoint(x: 66, y: 24))
        ghost.addCurve(to: CGPoint(x: 76, y: 46), controlPoint1: CGPoint(x: 66, y: 40), controlPoint2: CGPoint(x: 74, y: 42))
        ghost.addCurve(to: CGPoint(x: 65, y: 54), controlPoint1: CGPoint(x: 76, y: 50), controlPoint2: CGPoint(x: 70, y: 52))
        ghost.addCurve(to: CGPoint(x: 75, y: 74), controlPoint1: CGPoint(x: 65, y: 62), controlPoint2: CGPoint(x: 74, y: 66))
        ghost.addCurve(to: CGPoint(x: 50, y: 76), controlPoint1: CGPoint(x: 67, y: 80), controlPoint2: CGPoint(x: 58, y: 75))
        ghost.addCurve(to: CGPoint(x: 25, y: 74), controlPoint1: CGPoint(x: 42, y: 75), controlPoint2: CGPoint(x: 33, y: 80))
        ghost.addCurve(to: CGPoint(x: 35, y: 54), controlPoint1: CGPoint(x: 26, y: 66), controlPoint2: CGPoint(x: 35, y: 62))
        ghost.addCurve(to: CGPoint(x: 24, y: 46), controlPoint1: CGPoint(x: 30, y: 52), controlPoint2: CGPoint(x: 24, y: 50))
        ghost.addCurve(to: CGPoint(x: 34, y: 34), controlPoint1: CGPoint(x: 26, y: 42), controlPoint2: CGPoint(x: 34, y: 40))
        ghost.addCurve(to: CGPoint(x: 50, y: 18), controlPoint1: CGPoint(x: 34, y: 24), controlPoint2: CGPoint(x: 40, y: 18))
        ghost.close()
        
        UIColor.white.setFill()
        ghost.fill()
        UIColor.black.setStroke()
        ghost.lineWidth = 2.5
        ghost.stroke()
    }
    
    // MARK: - 9. X
    private static func drawX(canvas: CGRect, cg: CGContext) {
        UIColor.black.setFill()
        cg.fill(canvas)
        
        let p1 = UIBezierPath()
        p1.move(to: CGPoint(x: 25, y: 23))
        p1.addLine(to: CGPoint(x: 40, y: 23))
        p1.addLine(to: CGPoint(x: 75, y: 77))
        p1.addLine(to: CGPoint(x: 60, y: 77))
        p1.close()
        
        let p2 = UIBezierPath()
        p2.move(to: CGPoint(x: 72, y: 23))
        p2.addLine(to: CGPoint(x: 60, y: 23))
        p2.addLine(to: CGPoint(x: 46, y: 44))
        p2.addLine(to: CGPoint(x: 53, y: 54))
        p2.close()
        
        let p3 = UIBezierPath()
        p3.move(to: CGPoint(x: 43, y: 56))
        p3.addLine(to: CGPoint(x: 36, y: 46))
        p3.addLine(to: CGPoint(x: 25, y: 62))
        p3.addLine(to: CGPoint(x: 32, y: 77))
        p3.addLine(to: CGPoint(x: 43, y: 77))
        p3.close()
        
        UIColor.white.setFill()
        p1.fill()
        p2.fill()
        p3.fill()
    }
    
    // MARK: - 10. Spotify
    private static func drawSpotify(canvas: CGRect, cg: CGContext) {
        UIColor(red: 29/255.0, green: 185/255.0, blue: 84/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        func drawWave(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, width: CGFloat) {
            let path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: startAngle * .pi / 180,
                endAngle: endAngle * .pi / 180,
                clockwise: true
            )
            path.lineWidth = width
            path.lineCapStyle = .round
            UIColor(red: 25/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0).setStroke()
            path.stroke()
        }
        
        let c = CGPoint(x: 34, y: 70)
        drawWave(center: c, radius: 44, startAngle: -64, endAngle: -10, width: 6.5)
        drawWave(center: c, radius: 32, startAngle: -62, endAngle: -12, width: 5.5)
        drawWave(center: c, radius: 20, startAngle: -60, endAngle: -14, width: 4.5)
    }
    
    // MARK: - 11. Pinterest
    private static func drawPinterest(canvas: CGRect, cg: CGContext) {
        UIColor(red: 189/255.0, green: 8/255.0, blue: 28/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 48, y: 20))
        p.addCurve(to: CGPoint(x: 74, y: 40), controlPoint1: CGPoint(x: 64, y: 20), controlPoint2: CGPoint(x: 74, y: 28))
        p.addCurve(to: CGPoint(x: 52, y: 62), controlPoint1: CGPoint(x: 74, y: 54), controlPoint2: CGPoint(x: 62, y: 62))
        p.addLine(to: CGPoint(x: 44, y: 86))
        p.addLine(to: CGPoint(x: 36, y: 86))
        p.addLine(to: CGPoint(x: 44, y: 52))
        p.addCurve(to: CGPoint(x: 38, y: 38), controlPoint1: CGPoint(x: 40, y: 48), controlPoint2: CGPoint(x: 38, y: 44))
        p.addCurve(to: CGPoint(x: 48, y: 20), controlPoint1: CGPoint(x: 38, y: 28), controlPoint2: CGPoint(x: 42, y: 20))
        p.close()
        
        UIColor.white.setFill()
        p.fill()
    }
    
    // MARK: - 12. LinkedIn
    private static func drawLinkedIn(canvas: CGRect, cg: CGContext) {
        UIColor(red: 10/255.0, green: 102/255.0, blue: 194/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        // "in" logo
        UIColor.white.setFill()
        // i dot
        UIBezierPath(roundedRect: CGRect(x: 24, y: 25, width: 10, height: 10), cornerRadius: 2).fill()
        // i stem
        UIBezierPath(roundedRect: CGRect(x: 24, y: 40, width: 10, height: 36), cornerRadius: 2).fill()
        // n stem
        UIBezierPath(roundedRect: CGRect(x: 42, y: 40, width: 10, height: 36), cornerRadius: 2).fill()
        // n arch
        let nArch = UIBezierPath()
        nArch.move(to: CGPoint(x: 52, y: 44))
        nArch.addCurve(to: CGPoint(x: 76, y: 56), controlPoint1: CGPoint(x: 66, y: 38), controlPoint2: CGPoint(x: 76, y: 44))
        nArch.addLine(to: CGPoint(x: 76, y: 76))
        nArch.addLine(to: CGPoint(x: 66, y: 76))
        nArch.addLine(to: CGPoint(x: 66, y: 58))
        nArch.addCurve(to: CGPoint(x: 52, y: 52), controlPoint1: CGPoint(x: 66, y: 50), controlPoint2: CGPoint(x: 60, y: 50))
        nArch.close()
        nArch.fill()
    }
    
    // MARK: - 13. Reddit
    private static func drawReddit(canvas: CGRect, cg: CGContext) {
        UIColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        UIColor.white.setFill()
        // Snoo ears
        UIBezierPath(ovalIn: CGRect(x: 22, y: 48, width: 12, height: 12)).fill()
        UIBezierPath(ovalIn: CGRect(x: 66, y: 48, width: 12, height: 12)).fill()
        // Head
        UIBezierPath(ovalIn: CGRect(x: 26, y: 38, width: 48, height: 36)).fill()
        // Antenna
        let antenna = UIBezierPath()
        antenna.move(to: CGPoint(x: 50, y: 38))
        antenna.addLine(to: CGPoint(x: 58, y: 22))
        antenna.addLine(to: CGPoint(x: 68, y: 24))
        antenna.lineWidth = 3
        UIColor.white.setStroke()
        antenna.stroke()
        UIBezierPath(ovalIn: CGRect(x: 66, y: 20, width: 8, height: 8)).fill()
        
        // Orange eyes
        UIColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 1.0).setFill()
        UIBezierPath(ovalIn: CGRect(x: 38, y: 50, width: 6, height: 6)).fill()
        UIBezierPath(ovalIn: CGRect(x: 56, y: 50, width: 6, height: 6)).fill()
        
        // Smile
        let smile = UIBezierPath()
        smile.move(to: CGPoint(x: 42, y: 62))
        smile.addCurve(to: CGPoint(x: 58, y: 62), controlPoint1: CGPoint(x: 46, y: 68), controlPoint2: CGPoint(x: 54, y: 68))
        smile.lineWidth = 2.5
        UIColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 1.0).setStroke()
        smile.stroke()
    }
    
    // MARK: - 14. Discord
    private static func drawDiscord(canvas: CGRect, cg: CGContext) {
        UIColor(red: 88/255.0, green: 101/255.0, blue: 242/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let clyde = UIBezierPath()
        clyde.move(to: CGPoint(x: 32, y: 28))
        clyde.addLine(to: CGPoint(x: 68, y: 28))
        clyde.addCurve(to: CGPoint(x: 82, y: 58), controlPoint1: CGPoint(x: 78, y: 38), controlPoint2: CGPoint(x: 82, y: 48))
        clyde.addCurve(to: CGPoint(x: 72, y: 72), controlPoint1: CGPoint(x: 82, y: 66), controlPoint2: CGPoint(x: 78, y: 70))
        clyde.addLine(to: CGPoint(x: 64, y: 66))
        clyde.addCurve(to: CGPoint(x: 36, y: 66), controlPoint1: CGPoint(x: 55, y: 70), controlPoint2: CGPoint(x: 45, y: 70))
        clyde.addLine(to: CGPoint(x: 28, y: 72))
        clyde.addCurve(to: CGPoint(x: 18, y: 58), controlPoint1: CGPoint(x: 22, y: 70), controlPoint2: CGPoint(x: 18, y: 66))
        clyde.addCurve(to: CGPoint(x: 32, y: 28), controlPoint1: CGPoint(x: 18, y: 48), controlPoint2: CGPoint(x: 22, y: 38))
        clyde.close()
        
        UIColor.white.setFill()
        clyde.fill()
        
        // Eyes
        UIColor(red: 88/255.0, green: 101/255.0, blue: 242/255.0, alpha: 1.0).setFill()
        UIBezierPath(ovalIn: CGRect(x: 34, y: 46, width: 9, height: 11)).fill()
        UIBezierPath(ovalIn: CGRect(x: 57, y: 46, width: 9, height: 11)).fill()
    }
    
    // MARK: - 15. Threads
    private static func drawThreads(canvas: CGRect, cg: CGContext) {
        UIColor(red: 16/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 24))
        path.addCurve(to: CGPoint(x: 74, y: 50), controlPoint1: CGPoint(x: 64, y: 24), controlPoint2: CGPoint(x: 74, y: 34))
        path.addCurve(to: CGPoint(x: 50, y: 76), controlPoint1: CGPoint(x: 74, y: 66), controlPoint2: CGPoint(x: 64, y: 76))
        path.addCurve(to: CGPoint(x: 26, y: 50), controlPoint1: CGPoint(x: 36, y: 76), controlPoint2: CGPoint(x: 26, y: 66))
        path.addCurve(to: CGPoint(x: 50, y: 24), controlPoint1: CGPoint(x: 26, y: 34), controlPoint2: CGPoint(x: 36, y: 24))
        
        UIColor.white.setStroke()
        path.lineWidth = 5
        path.stroke()
        
        let inner = UIBezierPath(ovalIn: CGRect(x: 40, y: 40, width: 20, height: 20))
        inner.lineWidth = 4.5
        inner.stroke()
    }
    
    // MARK: - 16. LINE
    private static func drawLine(canvas: CGRect, cg: CGContext) {
        UIColor(red: 6/255.0, green: 199/255.0, blue: 85/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let bubble = UIBezierPath(roundedRect: CGRect(x: 20, y: 24, width: 60, height: 50), cornerRadius: 20)
        let tail = UIBezierPath()
        tail.move(to: CGPoint(x: 32, y: 70))
        tail.addLine(to: CGPoint(x: 24, y: 78))
        tail.addLine(to: CGPoint(x: 40, y: 74))
        tail.close()
        bubble.append(tail)
        
        UIColor.white.setFill()
        bubble.fill()
        
        // Draw green "LINE" text
        let font = UIFont.systemFont(ofSize: 15, weight: .black)
        let attr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor(red: 6/255.0, green: 199/255.0, blue: 85/255.0, alpha: 1.0)
        ]
        let str = "LINE" as NSString
        let size = str.size(withAttributes: attr)
        let r = CGRect(x: 50 - size.width / 2, y: 49 - size.height / 2, width: size.width, height: size.height)
        str.draw(in: r, withAttributes: attr)
    }
    
    // MARK: - 17. Viber
    private static func drawViber(canvas: CGRect, cg: CGContext) {
        UIColor(red: 115/255.0, green: 96/255.0, blue: 242/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let b = UIBezierPath(roundedRect: CGRect(x: 20, y: 22, width: 60, height: 54), cornerRadius: 18)
        let tail = UIBezierPath()
        tail.move(to: CGPoint(x: 30, y: 72))
        tail.addLine(to: CGPoint(x: 22, y: 80))
        tail.addLine(to: CGPoint(x: 38, y: 76))
        tail.close()
        b.append(tail)
        
        UIColor.white.setStroke()
        b.lineWidth = 4.5
        b.stroke()
        
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 38, y: 38))
        p.addCurve(to: CGPoint(x: 42, y: 44), controlPoint1: CGPoint(x: 40, y: 38), controlPoint2: CGPoint(x: 42, y: 41))
        p.addLine(to: CGPoint(x: 40, y: 47))
        p.addCurve(to: CGPoint(x: 53, y: 60), controlPoint1: CGPoint(x: 43, y: 53), controlPoint2: CGPoint(x: 47, y: 57))
        p.addLine(to: CGPoint(x: 56, y: 58))
        p.addCurve(to: CGPoint(x: 62, y: 62), controlPoint1: CGPoint(x: 58, y: 58), controlPoint2: CGPoint(x: 62, y: 60))
        p.close()
        UIColor.white.setFill()
        p.fill()
    }
    
    // MARK: - 18. KakaoTalk
    private static func drawKakaoTalk(canvas: CGRect, cg: CGContext) {
        UIColor(red: 254/255.0, green: 229/255.0, blue: 0/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let bubble = UIBezierPath(ovalIn: CGRect(x: 18, y: 24, width: 64, height: 50))
        let tail = UIBezierPath()
        tail.move(to: CGPoint(x: 30, y: 68))
        tail.addLine(to: CGPoint(x: 20, y: 76))
        tail.addLine(to: CGPoint(x: 38, y: 72))
        tail.close()
        bubble.append(tail)
        
        UIColor(red: 60/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0).setFill()
        bubble.fill()
        
        let font = UIFont.systemFont(ofSize: 13, weight: .black)
        let attr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor(red: 254/255.0, green: 229/255.0, blue: 0/255.0, alpha: 1.0)
        ]
        let str = "TALK" as NSString
        let size = str.size(withAttributes: attr)
        let r = CGRect(x: 50 - size.width / 2, y: 48 - size.height / 2, width: size.width, height: size.height)
        str.draw(in: r, withAttributes: attr)
    }
    
    // MARK: - 19. GitHub
    private static func drawGitHub(canvas: CGRect, cg: CGContext) {
        UIColor(red: 36/255.0, green: 41/255.0, blue: 47/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let octo = UIBezierPath()
        octo.move(to: CGPoint(x: 50, y: 22))
        octo.addCurve(to: CGPoint(x: 74, y: 46), controlPoint1: CGPoint(x: 64, y: 22), controlPoint2: CGPoint(x: 74, y: 32))
        octo.addCurve(to: CGPoint(x: 56, y: 74), controlPoint1: CGPoint(x: 74, y: 60), controlPoint2: CGPoint(x: 66, y: 70))
        octo.addLine(to: CGPoint(x: 56, y: 66))
        octo.addCurve(to: CGPoint(x: 44, y: 66), controlPoint1: CGPoint(x: 52, y: 68), controlPoint2: CGPoint(x: 48, y: 68))
        octo.addLine(to: CGPoint(x: 44, y: 74))
        octo.addCurve(to: CGPoint(x: 26, y: 46), controlPoint1: CGPoint(x: 34, y: 70), controlPoint2: CGPoint(x: 26, y: 60))
        octo.addCurve(to: CGPoint(x: 50, y: 22), controlPoint1: CGPoint(x: 26, y: 32), controlPoint2: CGPoint(x: 36, y: 22))
        octo.close()
        
        UIColor.white.setFill()
        octo.fill()
    }
    
    // MARK: - Business 1. Bitcoin
    private static func drawBitcoin(canvas: CGRect, cg: CGContext) {
        UIColor(red: 247/255.0, green: 147/255.0, blue: 26/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let font = UIFont.systemFont(ofSize: 48, weight: .bold)
        let attr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let str = "₿" as NSString
        let size = str.size(withAttributes: attr)
        let r = CGRect(x: 50 - size.width / 2, y: 50 - size.height / 2, width: size.width, height: size.height)
        str.draw(in: r, withAttributes: attr)
    }
    
    // MARK: - Business 2. Ethereum
    private static func drawEthereum(canvas: CGRect, cg: CGContext) {
        UIColor(red: 60/255.0, green: 60/255.0, blue: 61/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        // Upper pyramid
        let up = UIBezierPath()
        up.move(to: CGPoint(x: 50, y: 20))
        up.addLine(to: CGPoint(x: 68, y: 50))
        up.addLine(to: CGPoint(x: 50, y: 60))
        up.addLine(to: CGPoint(x: 32, y: 50))
        up.close()
        UIColor.white.setFill()
        up.fill()
        
        // Lower pyramid
        let down = UIBezierPath()
        down.move(to: CGPoint(x: 50, y: 64))
        down.addLine(to: CGPoint(x: 68, y: 54))
        down.addLine(to: CGPoint(x: 50, y: 80))
        down.addLine(to: CGPoint(x: 32, y: 54))
        down.close()
        UIColor(white: 0.82, alpha: 1.0).setFill()
        down.fill()
    }
    
    // MARK: - Business 3. PayPal
    private static func drawPayPal(canvas: CGRect, cg: CGContext) {
        UIColor(red: 0/255.0, green: 48/255.0, blue: 135/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let font = UIFont.systemFont(ofSize: 46, weight: .black)
        let attr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor(red: 0/255.0, green: 121/255.0, blue: 193/255.0, alpha: 1.0)
        ]
        ("P" as NSString).draw(in: CGRect(x: 40, y: 22, width: 36, height: 50), withAttributes: attr)
        
        let attr2: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        ("P" as NSString).draw(in: CGRect(x: 30, y: 26, width: 36, height: 50), withAttributes: attr2)
    }
    
    // MARK: - Business 4. Venmo
    private static func drawVenmo(canvas: CGRect, cg: CGContext) {
        UIColor(red: 0/255.0, green: 140/255.0, blue: 255/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let v = UIBezierPath()
        v.move(to: CGPoint(x: 62, y: 22))
        v.addLine(to: CGPoint(x: 44, y: 78))
        v.addLine(to: CGPoint(x: 30, y: 78))
        v.addLine(to: CGPoint(x: 44, y: 22))
        v.addLine(to: CGPoint(x: 58, y: 22))
        v.close()
        
        let v2 = UIBezierPath()
        v2.move(to: CGPoint(x: 58, y: 22))
        v2.addLine(to: CGPoint(x: 74, y: 22))
        v2.addLine(to: CGPoint(x: 56, y: 78))
        v2.addLine(to: CGPoint(x: 44, y: 78))
        v2.close()
        
        UIColor.white.setFill()
        v.fill()
        v2.fill()
    }
    
    // MARK: - Business 5. Cash App
    private static func drawCashApp(canvas: CGRect, cg: CGContext) {
        UIColor(red: 0/255.0, green: 214/255.0, blue: 50/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let font = UIFont.systemFont(ofSize: 52, weight: .bold)
        let attr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let str = "$" as NSString
        let size = str.size(withAttributes: attr)
        let r = CGRect(x: 50 - size.width / 2, y: 48 - size.height / 2, width: size.width, height: size.height)
        str.draw(in: r, withAttributes: attr)
    }
    
    // MARK: - Business 6. Stripe
    private static func drawStripe(canvas: CGRect, cg: CGContext) {
        UIColor(red: 99/255.0, green: 91/255.0, blue: 255/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let font = UIFont.systemFont(ofSize: 48, weight: .bold)
        let attr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let str = "S" as NSString
        let size = str.size(withAttributes: attr)
        let r = CGRect(x: 50 - size.width / 2, y: 49 - size.height / 2, width: size.width, height: size.height)
        str.draw(in: r, withAttributes: attr)
    }
    
    // MARK: - Business 7. App Store
    private static func drawAppStore(canvas: CGRect, cg: CGContext) {
        UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        // 3 overlapping popsicle bars forming A
        let leftBar = UIBezierPath(roundedRect: CGRect(x: -4, y: -24, width: 8, height: 48), cornerRadius: 4)
        cg.saveGState()
        cg.translateBy(x: 44, y: 48)
        cg.rotate(by: 32 * .pi / 180)
        UIColor.white.setFill()
        leftBar.fill()
        cg.restoreGState()
        
        let rightBar = UIBezierPath(roundedRect: CGRect(x: -4, y: -24, width: 8, height: 48), cornerRadius: 4)
        cg.saveGState()
        cg.translateBy(x: 56, y: 48)
        cg.rotate(by: -32 * .pi / 180)
        rightBar.fill()
        cg.restoreGState()
        
        let crossBar = UIBezierPath(roundedRect: CGRect(x: 28, y: 52, width: 44, height: 8), cornerRadius: 4)
        crossBar.fill()
    }
    
    // MARK: - Business 8. Google Maps
    private static func drawGoogleMaps(canvas: CGRect, cg: CGContext, showStar: Bool) {
        UIColor(red: 66/255.0, green: 133/255.0, blue: 244/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let pin = UIBezierPath()
        pin.move(to: CGPoint(x: 50, y: 78))
        pin.addCurve(to: CGPoint(x: 28, y: 42), controlPoint1: CGPoint(x: 38, y: 64), controlPoint2: CGPoint(x: 28, y: 52))
        pin.addCurve(to: CGPoint(x: 72, y: 42), controlPoint1: CGPoint(x: 28, y: 28), controlPoint2: CGPoint(x: 72, y: 28))
        pin.addCurve(to: CGPoint(x: 50, y: 78), controlPoint1: CGPoint(x: 72, y: 52), controlPoint2: CGPoint(x: 62, y: 64))
        pin.close()
        
        UIColor.white.setFill()
        pin.fill()
        
        if showStar {
            // Gold star inside pin
            let font = UIFont.systemFont(ofSize: 16)
            let attr: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor(red: 251/255.0, green: 188/255.0, blue: 4/255.0, alpha: 1.0)
            ]
            let str = "★" as NSString
            let size = str.size(withAttributes: attr)
            str.draw(in: CGRect(x: 50 - size.width / 2, y: 41 - size.height / 2, width: size.width, height: size.height), withAttributes: attr)
        } else {
            // Circle hole in pin
            UIColor(red: 66/255.0, green: 133/255.0, blue: 244/255.0, alpha: 1.0).setFill()
            UIBezierPath(ovalIn: CGRect(x: 43, y: 35, width: 14, height: 14)).fill()
        }
    }
    
    // MARK: - Business 9. Zoom
    private static func drawZoom(canvas: CGRect, cg: CGContext) {
        UIColor(red: 45/255.0, green: 140/255.0, blue: 255/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let camera = UIBezierPath(roundedRect: CGRect(x: 24, y: 34, width: 36, height: 32), cornerRadius: 8)
        let lens = UIBezierPath()
        lens.move(to: CGPoint(x: 60, y: 44))
        lens.addLine(to: CGPoint(x: 76, y: 34))
        lens.addLine(to: CGPoint(x: 76, y: 66))
        lens.addLine(to: CGPoint(x: 60, y: 56))
        lens.close()
        camera.append(lens)
        
        UIColor.white.setFill()
        camera.fill()
    }
    
    // MARK: - Business 10. Google Meet
    private static func drawGoogleMeet(canvas: CGRect, cg: CGContext) {
        UIColor(red: 0/255.0, green: 172/255.0, blue: 71/255.0, alpha: 1.0).setFill()
        cg.fill(canvas)
        
        let body = UIBezierPath(roundedRect: CGRect(x: 24, y: 34, width: 36, height: 32), cornerRadius: 8)
        let lens = UIBezierPath()
        lens.move(to: CGPoint(x: 60, y: 44))
        lens.addLine(to: CGPoint(x: 76, y: 34))
        lens.addLine(to: CGPoint(x: 76, y: 66))
        lens.addLine(to: CGPoint(x: 60, y: 56))
        lens.close()
        body.append(lens)
        
        UIColor.white.setFill()
        body.fill()
    }
}

// MARK: - Universal SwiftUI Brand Logo View
public struct BrandLogoView: View {
    public let brand: BrandType?
    public var fallbackIcon: String?
    public var size: CGFloat
    public var cornerRadius: CGFloat?
    
    public init(
        brand: BrandType?,
        fallbackIcon: String? = nil,
        size: CGFloat = 42,
        cornerRadius: CGFloat? = nil
    ) {
        self.brand = brand
        self.fallbackIcon = fallbackIcon
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    public init(
        itemId: String,
        fallbackIcon: String? = nil,
        size: CGFloat = 42,
        cornerRadius: CGFloat? = nil
    ) {
        self.brand = BrandType.match(from: itemId)
        self.fallbackIcon = fallbackIcon
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    public init(
        logoType: QRLogoType,
        size: CGFloat = 42,
        cornerRadius: CGFloat? = nil
    ) {
        self.brand = BrandType.match(from: logoType.rawValue)
        self.fallbackIcon = logoType.systemIcon
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        let cr = cornerRadius ?? (size * 0.28)
        
        if let brand = brand {
            Image(uiImage: BrandLogoRenderer.image(for: brand, size: CGSize(width: size * 2, height: size * 2)))
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: cr, style: .continuous))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: cr, style: .continuous)
                    .fill(Color(hex: "253745"))
                    .frame(width: size, height: size)
                
                if let icon = fallbackIcon {
                    Image(systemName: icon)
                        .font(.system(size: size * 0.48, weight: .medium))
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
            }
        }
    }
}
