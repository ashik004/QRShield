//
//  TemplateFrameRenderer.swift
//  QRShield
//
//  Programmatic Core Graphics frame renderer for high-quality decorative QR code frames.
//

import UIKit

// MARK: - QRDecorativeFrame Enum

public enum QRDecorativeFrame: String, CaseIterable, Identifiable, Codable {
    case none = "None"
    
    // === 1. BANNERS & BORDERS ===
    case scanMeBottom = "Scan Me Pill"
    case roundedBorderBanner = "Border Banner"
    case topBanner = "Top Banner"
    case fullBanner = "Full Banner"
    case viewfinder = "Viewfinder"
    
    // === 2. SOCIAL & BUSINESS CARDS ===
    case instagramCard = "Instagram"
    case facebookCard = "Facebook"
    case youtubeCard = "YouTube"
    case linkedInCard = "LinkedIn"
    case chatBubble = "Chat Bubble"
    case wifiCard = "Wi-Fi Hub"
    case googleReview = "Google Review"
    
    // === 3. OCCASION & CREATIVE ===
    case stickyNote = "Sticky Note"
    case loveHearts = "Love Hearts"
    case birthdayParty = "Happy Birthday"
    case giftBox = "Gift Box"
    case ticketCoupon = "Coupon Ticket"
    case floralWreath = "Floral Frame"
    case neonGlow = "Neon Cyber"
    
    // === 4. FOOD & MENU ===
    case coffeeMug = "Coffee Mug"
    case frenchFries = "Fast Food"
    case popcornBox = "Popcorn"
    case iceCream = "Ice Cream"
    
    public var id: String { rawValue }
}

// MARK: - TemplateFrameRenderer

public final class TemplateFrameRenderer {

    // MARK: - Public API

    public static func renderFramedQR(
        qrImage: UIImage,
        frameType: QRDecorativeFrame,
        canvasSize: CGSize,
        brandColors: [String],
        bannerText: String?,
        accentColorHex: String
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        let accent = uiColor(hex: accentColorHex)
        let brand = brandColors.map { uiColor(hex: $0) }
        
        return renderer.image { ctx in
            let rect = CGRect(origin: .zero, size: canvasSize)
            let cgCtx = ctx.cgContext
            
            // Base rounded card clipping (Corner radius ~4.5% of canvas width)
            let cardCornerRadius = canvasSize.width * 0.05
            let cardPath = UIBezierPath(roundedRect: rect, cornerRadius: cardCornerRadius)
            cgCtx.addPath(cardPath.cgPath)
            cgCtx.clip()
            
            // Default background fill: white
            UIColor.white.setFill()
            cgCtx.fill(rect)
            
            switch frameType {
            case .none:
                drawQR(qrImage, in: rect, padding: 0.06, context: cgCtx)
                
            case .scanMeBottom:
                drawScanMeBottom(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "SCAN ME")
                
            case .roundedBorderBanner:
                drawRoundedBorderBanner(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "SCAN ME")
                
            case .topBanner:
                drawTopBanner(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "SCAN ME")
                
            case .fullBanner:
                drawFullBanner(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, topText: bannerText ?? "WELCOME", bottomText: "SCAN CODE")
                
            case .viewfinder:
                drawViewfinder(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "SCAN ME")
                
            case .instagramCard:
                drawInstagramCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage, colors: brand.isEmpty ? [uiColor(hex: "F58529"), uiColor(hex: "DD2A7B"), uiColor(hex: "8134AF")] : brand, text: bannerText ?? "FOLLOW US")
                
            case .facebookCard:
                drawFacebookCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "FOLLOW US ON")
                
            case .youtubeCard:
                drawYouTubeCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "SUBSCRIBE")
                
            case .linkedInCard:
                drawLinkedInCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "CONNECT")
                
            case .chatBubble:
                drawChatBubble(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "CHAT WITH US")
                
            case .wifiCard:
                drawWiFiCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, subtitle: bannerText ?? "SCAN TO CONNECT")
                
            case .googleReview:
                drawGoogleReviewCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage)
                
            case .stickyNote:
                drawStickyNote(cgCtx: cgCtx, rect: rect, qrImage: qrImage)
                
            case .loveHearts:
                drawLoveHeartsCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage, text: bannerText ?? "I LOVE YOU")
                
            case .birthdayParty:
                drawBirthdayCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage)
                
            case .giftBox:
                drawGiftBoxCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage)
                
            case .ticketCoupon:
                drawTicketCoupon(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "20% OFF · SCAN ME")
                
            case .floralWreath:
                drawFloralWreath(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent)
                
            case .neonGlow:
                drawNeonGlowCard(cgCtx: cgCtx, rect: rect, qrImage: qrImage, accent: accent, text: bannerText ?? "SCAN ME")
                
            case .coffeeMug:
                drawCoffeeMug(cgCtx: cgCtx, rect: rect, qrImage: qrImage, text: bannerText ?? "SCAN ME")
                
            case .frenchFries:
                drawFrenchFries(cgCtx: cgCtx, rect: rect, qrImage: qrImage)
                
            case .popcornBox:
                drawPopcornBox(cgCtx: cgCtx, rect: rect, qrImage: qrImage)
                
            case .iceCream:
                drawIceCreamSundae(cgCtx: cgCtx, rect: rect, qrImage: qrImage)
            }
        }
    }

    // MARK: - QR Code Centering Helper

    private static func drawQR(
        _ image: UIImage,
        in rect: CGRect,
        padding: CGFloat,
        yOffset: CGFloat = 0,
        context: CGContext
    ) {
        let size = min(rect.width, rect.height) * (1.0 - padding * 2)
        let x = rect.midX - size / 2
        let y = rect.midY - size / 2 + yOffset
        let qrRect = CGRect(x: x, y: y, width: size, height: size)
        
        // Clean white backing with smooth micro-radius
        let bgPath = UIBezierPath(roundedRect: qrRect.insetBy(dx: -4, dy: -4), cornerRadius: size * 0.04)
        UIColor.white.setFill()
        bgPath.fill()
        
        image.draw(in: qrRect)
    }

    // MARK: - 1. Classic Scan Me Pill (High Contrast, Ultra Clean)

    private static func drawScanMeBottom(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        // Pure white background
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // QR Code positioned in top center
        let qrSize = rect.width * 0.72
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: rect.height * 0.08,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom pill banner
        let pillH = rect.height * 0.11
        let pillW = rect.width * 0.74
        let pillY = qrRect.maxY + rect.height * 0.035
        let pillRect = CGRect(
            x: (rect.width - pillW) / 2,
            y: pillY,
            width: pillW,
            height: pillH
        )
        
        let pillPath = UIBezierPath(roundedRect: pillRect, cornerRadius: pillH / 2)
        accent.setFill()
        pillPath.fill()
        
        // Text inside pill
        drawCenteredText(text.uppercased(), in: pillRect, fontSize: pillH * 0.44, color: .white, bold: true)
    }

    // MARK: - 2. Rounded Border with Integrated Text Banner

    private static func drawRoundedBorderBanner(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        let inset = rect.width * 0.06
        let strokeW = rect.width * 0.016
        let frameRect = rect.insetBy(dx: inset, dy: inset)
        let frameRadius = rect.width * 0.07
        
        // Outer rounded stroke
        let borderPath = UIBezierPath(roundedRect: frameRect, cornerRadius: frameRadius)
        borderPath.lineWidth = strokeW
        accent.setStroke()
        borderPath.stroke()
        
        // QR Code in upper section
        let qrSize = rect.width * 0.68
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: inset + rect.height * 0.04,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Text at bottom inside border
        let textH = rect.height * 0.08
        let textRect = CGRect(
            x: inset,
            y: frameRect.maxY - textH - rect.height * 0.02,
            width: frameRect.width,
            height: textH
        )
        drawCenteredText(text.uppercased(), in: textRect, fontSize: textH * 0.46, color: accent, bold: true)
    }

    // MARK: - 3. Top Banner Frame

    private static func drawTopBanner(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // Header block
        let headerH = rect.height * 0.16
        let headerRect = CGRect(x: 0, y: 0, width: rect.width, height: headerH)
        accent.setFill()
        cgCtx.fill(headerRect)
        
        drawCenteredText(text.uppercased(), in: headerRect, fontSize: headerH * 0.38, color: .white, bold: true)
        
        // QR centered below header
        let qrSize = rect.width * 0.70
        let qrY = headerH + (rect.height - headerH - qrSize) / 2
        let qrRect = CGRect(x: (rect.width - qrSize) / 2, y: qrY, width: qrSize, height: qrSize)
        qrImage.draw(in: qrRect)
    }

    // MARK: - 4. Full Dual-Banner Frame

    private static func drawFullBanner(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        topText: String,
        bottomText: String
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // Top banner
        let bannerH = rect.height * 0.14
        let topRect = CGRect(x: 0, y: 0, width: rect.width, height: bannerH)
        accent.setFill()
        cgCtx.fill(topRect)
        drawCenteredText(topText.uppercased(), in: topRect, fontSize: bannerH * 0.38, color: .white, bold: true)
        
        // Bottom banner
        let botRect = CGRect(x: 0, y: rect.height - bannerH, width: rect.width, height: bannerH)
        accent.setFill()
        cgCtx.fill(botRect)
        drawCenteredText(bottomText.uppercased(), in: botRect, fontSize: bannerH * 0.38, color: .white, bold: true)
        
        // Thin connecting border
        let borderPath = UIBezierPath(rect: rect.insetBy(dx: 1, dy: 1))
        borderPath.lineWidth = rect.width * 0.015
        accent.setStroke()
        borderPath.stroke()
        
        // QR Code in middle
        let availH = rect.height - bannerH * 2
        let qrSize = min(rect.width * 0.68, availH * 0.85)
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: bannerH + (availH - qrSize) / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
    }

    // MARK: - 5. Viewfinder Camera Focus Frame

    private static func drawViewfinder(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        let margin = rect.width * 0.08
        let len = rect.width * 0.18
        let lw = rect.width * 0.012
        
        cgCtx.setStrokeColor(accent.cgColor)
        cgCtx.setLineWidth(lw)
        cgCtx.setLineCap(.round)
        
        // 4 Clean L-shaped corner brackets
        // TL
        cgCtx.move(to: CGPoint(x: margin, y: margin + len))
        cgCtx.addLine(to: CGPoint(x: margin, y: margin))
        cgCtx.addLine(to: CGPoint(x: margin + len, y: margin))
        // TR
        cgCtx.move(to: CGPoint(x: rect.width - margin - len, y: margin))
        cgCtx.addLine(to: CGPoint(x: rect.width - margin, y: margin))
        cgCtx.addLine(to: CGPoint(x: rect.width - margin, y: margin + len))
        // BL
        cgCtx.move(to: CGPoint(x: margin, y: rect.height - margin - len))
        cgCtx.addLine(to: CGPoint(x: margin, y: rect.height - margin))
        cgCtx.addLine(to: CGPoint(x: margin + len, y: rect.height - margin))
        // BR
        cgCtx.move(to: CGPoint(x: rect.width - margin - len, y: rect.height - margin))
        cgCtx.addLine(to: CGPoint(x: rect.width - margin, y: rect.height - margin))
        cgCtx.addLine(to: CGPoint(x: rect.width - margin, y: rect.height - margin - len))
        cgCtx.strokePath()
        
        // Centered QR Code
        let qrSize = rect.width * 0.65
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: (rect.height - qrSize) / 2 - rect.height * 0.02,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom tech label
        let labelH = rect.height * 0.08
        let labelRect = CGRect(x: margin, y: rect.height - margin - labelH * 0.8, width: rect.width - margin * 2, height: labelH)
        drawCenteredText(text.uppercased(), in: labelRect, fontSize: labelH * 0.40, color: accent, bold: true)
    }

    // MARK: - 6. Instagram Official Sunset Card

    private static func drawInstagramCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        colors: [UIColor],
        text: String
    ) {
        // Gradient background fill
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor } as CFArray
        if let grad = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil) {
            cgCtx.drawLinearGradient(grad, start: CGPoint(x: 0, y: 0), end: CGPoint(x: rect.width, y: rect.height), options: [])
        }
        
        // Header title "Instagram"
        let headerH = rect.height * 0.13
        let headerRect = CGRect(x: 0, y: rect.height * 0.03, width: rect.width, height: headerH)
        drawCenteredText("Instagram", in: headerRect, fontSize: headerH * 0.50, color: .white, bold: true)
        
        // White rounded card holding the QR code
        let cardSize = rect.width * 0.72
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: rect.height * 0.17,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.10)
        UIColor.white.setFill()
        whiteCard.fill()
        
        // QR Code inset inside white card
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom subtitle
        let footH = rect.height * 0.08
        let footRect = CGRect(x: 0, y: cardRect.maxY + rect.height * 0.02, width: rect.width, height: footH)
        drawCenteredText(text.uppercased(), in: footRect, fontSize: footH * 0.44, color: .white, bold: true)
    }

    // MARK: - 7. Facebook Official Blue Card

    private static func drawFacebookCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        let fbBlue = uiColor(hex: "1877F2")
        fbBlue.setFill()
        cgCtx.fill(rect)
        
        // Top Header: Facebook brand banner
        let headerH = rect.height * 0.14
        let headerRect = CGRect(x: 0, y: rect.height * 0.03, width: rect.width, height: headerH)
        drawCenteredText("facebook", in: headerRect, fontSize: headerH * 0.52, color: .white, bold: true)
        
        // White rounded square
        let cardSize = rect.width * 0.72
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: rect.height * 0.17,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.08)
        UIColor.white.setFill()
        whiteCard.fill()
        
        // QR Code
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom Text
        let footH = rect.height * 0.08
        let footRect = CGRect(x: 0, y: cardRect.maxY + rect.height * 0.02, width: rect.width, height: footH)
        drawCenteredText(text.uppercased(), in: footRect, fontSize: footH * 0.42, color: .white, bold: true)
    }

    // MARK: - 8. YouTube Red Subscribe Card

    private static func drawYouTubeCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        let ytRed = uiColor(hex: "EF4444")
        ytRed.setFill()
        cgCtx.fill(rect)
        
        // Header
        let headerH = rect.height * 0.14
        let headerRect = CGRect(x: 0, y: rect.height * 0.03, width: rect.width, height: headerH)
        drawCenteredText("YouTube", in: headerRect, fontSize: headerH * 0.52, color: .white, bold: true)
        
        // White rounded square
        let cardSize = rect.width * 0.72
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: rect.height * 0.17,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.08)
        UIColor.white.setFill()
        whiteCard.fill()
        
        // QR Code
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Subscribe Pill
        let pillH = rect.height * 0.075
        let pillW = rect.width * 0.52
        let pillRect = CGRect(
            x: (rect.width - pillW) / 2,
            y: cardRect.maxY + rect.height * 0.02,
            width: pillW,
            height: pillH
        )
        let pill = UIBezierPath(roundedRect: pillRect, cornerRadius: pillH / 2)
        UIColor.white.setFill()
        pill.fill()
        drawCenteredText(text.uppercased(), in: pillRect, fontSize: pillH * 0.44, color: ytRed, bold: true)
    }

    // MARK: - 9. LinkedIn Connect Card

    private static func drawLinkedInCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        let inBlue = uiColor(hex: "0A66C2")
        
        // Clean Blue Border
        let borderW = rect.width * 0.016
        let borderPath = UIBezierPath(roundedRect: rect.insetBy(dx: rect.width * 0.05, dy: rect.width * 0.05), cornerRadius: rect.width * 0.06)
        borderPath.lineWidth = borderW
        inBlue.setStroke()
        borderPath.stroke()
        
        // Top LinkedIn header
        let headH = rect.height * 0.13
        let headRect = CGRect(x: 0, y: rect.height * 0.08, width: rect.width, height: headH)
        drawCenteredText("LinkedIn", in: headRect, fontSize: headH * 0.48, color: inBlue, bold: true)
        
        // QR Code
        let qrSize = rect.width * 0.65
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: headRect.maxY + rect.height * 0.02,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom Text
        let footH = rect.height * 0.06
        let footRect = CGRect(x: 0, y: qrRect.maxY + rect.height * 0.02, width: rect.width, height: footH)
        drawCenteredText(text.uppercased(), in: footRect, fontSize: footH * 0.42, color: inBlue, bold: true)
    }

    // MARK: - 10. WhatsApp Chat Bubble Card

    private static func drawChatBubble(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        let waGreen = uiColor(hex: "25D366")
        
        // Subtle background tint
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // Speech Bubble shape
        let bubbleMargin = rect.width * 0.06
        let bubbleRect = CGRect(
            x: bubbleMargin,
            y: bubbleMargin,
            width: rect.width - bubbleMargin * 2,
            height: rect.height * 0.82
        )
        let bubbleR = bubbleRect.width * 0.08
        let bubblePath = UIBezierPath(roundedRect: bubbleRect, cornerRadius: bubbleR)
        
        // Add speech bubble tail at bottom left
        let tail = UIBezierPath()
        tail.move(to: CGPoint(x: bubbleRect.minX + bubbleR * 1.5, y: bubbleRect.maxY))
        tail.addLine(to: CGPoint(x: bubbleRect.minX + bubbleR * 0.5, y: rect.height - bubbleMargin * 0.6))
        tail.addLine(to: CGPoint(x: bubbleRect.minX + bubbleR * 2.5, y: bubbleRect.maxY))
        tail.close()
        bubblePath.append(tail)
        
        waGreen.setFill()
        bubblePath.fill()
        
        // Top text "CHAT WITH US"
        let titleH = rect.height * 0.09
        let titleRect = CGRect(x: bubbleMargin, y: bubbleMargin + rect.height * 0.02, width: bubbleRect.width, height: titleH)
        drawCenteredText(text.uppercased(), in: titleRect, fontSize: titleH * 0.42, color: .white, bold: true)
        
        // White box with QR inside bubble
        let whiteBoxSize = bubbleRect.width * 0.76
        let whiteBoxRect = CGRect(
            x: (rect.width - whiteBoxSize) / 2,
            y: titleRect.maxY + rect.height * 0.01,
            width: whiteBoxSize,
            height: whiteBoxSize
        )
        let whiteBox = UIBezierPath(roundedRect: whiteBoxRect, cornerRadius: whiteBoxSize * 0.08)
        UIColor.white.setFill()
        whiteBox.fill()
        
        let qrSize = whiteBoxSize * 0.88
        let qrRect = CGRect(
            x: whiteBoxRect.midX - qrSize / 2,
            y: whiteBoxRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
    }

    // MARK: - 11. Wi-Fi Hub Card (Clean Typography & Antenna Waves)

    private static func drawWiFiCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        subtitle: String
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // Subtle outer border
        let borderW = rect.width * 0.008
        let borderPath = UIBezierPath(roundedRect: rect.insetBy(dx: rect.width * 0.05, dy: rect.width * 0.05), cornerRadius: rect.width * 0.06)
        borderPath.lineWidth = borderW
        uiColor(hex: "E2E8F0").setStroke()
        borderPath.stroke()
        
        // Top Header: "WIFI" with antenna wave symbol
        let headH = rect.height * 0.14
        let headRect = CGRect(x: 0, y: rect.height * 0.08, width: rect.width, height: headH)
        drawCenteredText("WIFI", in: headRect, fontSize: headH * 0.60, color: uiColor(hex: "0F172A"), bold: true)
        
        // Draw 3 antenna wave arcs above the "I"
        let waveCenter = CGPoint(x: rect.midX + headH * 0.52, y: rect.height * 0.085)
        accent.setStroke()
        for r in [headH * 0.12, headH * 0.22, headH * 0.32] {
            let arcPath = UIBezierPath(
                arcCenter: waveCenter,
                radius: r,
                startAngle: -CGFloat.pi * 0.75,
                endAngle: -CGFloat.pi * 0.25,
                clockwise: true
            )
            arcPath.lineWidth = rect.width * 0.006
            arcPath.lineCapStyle = .round
            arcPath.stroke()
        }
        
        // QR Code
        let qrSize = rect.width * 0.66
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: headRect.maxY + rect.height * 0.02,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom Subtitle: "SCAN TO CONNECT"
        let footH = rect.height * 0.06
        let footRect = CGRect(x: 0, y: qrRect.maxY + rect.height * 0.02, width: rect.width, height: footH)
        drawCenteredText(subtitle.uppercased(), in: footRect, fontSize: footH * 0.42, color: uiColor(hex: "64748B"), bold: true)
    }

    // MARK: - 12. Google Review Card (5-Star Rating)

    private static func drawGoogleReviewCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // Google 4-Color Accent Top Bar
        let barH = rect.height * 0.016
        let colors = [
            uiColor(hex: "4285F4"), // Blue
            uiColor(hex: "EA4335"), // Red
            uiColor(hex: "FBBC05"), // Yellow
            uiColor(hex: "34A853")  // Green
        ]
        let segW = rect.width / 4.0
        for (i, c) in colors.enumerated() {
            c.setFill()
            cgCtx.fill(CGRect(x: CGFloat(i) * segW, y: 0, width: segW, height: barH))
        }
        
        // Top Header: "Review Us on Google"
        let titleH = rect.height * 0.09
        let titleRect = CGRect(x: 0, y: rect.height * 0.05, width: rect.width, height: titleH)
        drawCenteredText("Review Us on Google", in: titleRect, fontSize: titleH * 0.44, color: uiColor(hex: "1F2937"), bold: true)
        
        // 5 Gold Stars ★★★★★
        let starH = rect.height * 0.05
        let starRect = CGRect(x: 0, y: titleRect.maxY, width: rect.width, height: starH)
        drawCenteredText("★ ★ ★ ★ ★", in: starRect, fontSize: starH * 0.65, color: uiColor(hex: "FBBF24"), bold: false)
        
        // Inset QR Code
        let qrSize = rect.width * 0.64
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: starRect.maxY + rect.height * 0.03,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom callout
        let footH = rect.height * 0.06
        let footRect = CGRect(x: 0, y: qrRect.maxY + rect.height * 0.02, width: rect.width, height: footH)
        drawCenteredText("SCAN TO LEAVE FEEDBACK", in: footRect, fontSize: footH * 0.38, color: uiColor(hex: "6B7280"), bold: true)
    }

    // MARK: - 13. Sticky Note (Yellow Post-It Note with Scotch Tape)

    private static func drawStickyNote(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage
    ) {
        // Soft desk background
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // Canary yellow Post-It square with soft shadow
        let noteMargin = rect.width * 0.07
        let noteRect = rect.insetBy(dx: noteMargin, dy: noteMargin)
        let noteR = rect.width * 0.03
        
        cgCtx.saveGState()
        cgCtx.setShadow(offset: CGSize(width: 0, height: rect.height * 0.015), blur: rect.width * 0.04, color: UIColor.black.withAlphaComponent(0.18).cgColor)
        uiColor(hex: "FDE047").setFill() // Soft canary yellow
        UIBezierPath(roundedRect: noteRect, cornerRadius: noteR).fill()
        cgCtx.restoreGState()
        
        // Translucent Scotch tape strip at top center
        let tapeW = rect.width * 0.32
        let tapeH = rect.height * 0.065
        let tapeRect = CGRect(
            x: (rect.width - tapeW) / 2,
            y: noteMargin - tapeH * 0.40,
            width: tapeW,
            height: tapeH
        )
        UIColor(white: 0.95, alpha: 0.70).setFill()
        UIBezierPath(roundedRect: tapeRect, cornerRadius: 3).fill()
        
        // QR Code in middle of sticky note
        let qrSize = noteRect.width * 0.78
        let qrRect = CGRect(
            x: noteRect.midX - qrSize / 2,
            y: noteRect.midY - qrSize / 2 + rect.height * 0.02,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
    }

    // MARK: - 14. Romantic Double Hearts Card

    private static func drawLoveHeartsCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        text: String
    ) {
        let roseRed = uiColor(hex: "E11D48")
        roseRed.setFill()
        cgCtx.fill(rect)
        
        // Two overlapping white hearts at top
        let heartSize = rect.width * 0.12
        let leftHeartCenter = CGPoint(x: rect.midX - heartSize * 0.45, y: rect.height * 0.11)
        let rightHeartCenter = CGPoint(x: rect.midX + heartSize * 0.45, y: rect.height * 0.10)
        drawHeart(cgCtx: cgCtx, center: leftHeartCenter, size: heartSize, color: .white)
        drawHeart(cgCtx: cgCtx, center: rightHeartCenter, size: heartSize * 0.85, color: .white)
        
        // White rounded card for QR
        let cardSize = rect.width * 0.72
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: rect.height * 0.18,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.08)
        UIColor.white.setFill()
        whiteCard.fill()
        
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom "I LOVE YOU" with hearts
        let footH = rect.height * 0.08
        let footRect = CGRect(x: 0, y: cardRect.maxY + rect.height * 0.015, width: rect.width, height: footH)
        drawCenteredText("♥ \(text.uppercased()) ♥", in: footRect, fontSize: footH * 0.42, color: .white, bold: true)
    }

    // MARK: - 15. Happy Birthday Celebration Card

    private static func drawBirthdayCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage
    ) {
        // Pastel Sky Blue Background
        uiColor(hex: "E0F2FE").setFill()
        cgCtx.fill(rect)
        
        // Party Bunting / Banner at top
        let bannerH = rect.height * 0.15
        let colors = [
            uiColor(hex: "EF4444"),
            uiColor(hex: "F59E0B"),
            uiColor(hex: "10B981"),
            uiColor(hex: "3B82F6"),
            uiColor(hex: "8B5CF6"),
            uiColor(hex: "EC4899")
        ]
        let numFlags = 6
        let flagW = rect.width / CGFloat(numFlags)
        for i in 0..<numFlags {
            let path = UIBezierPath()
            let x0 = CGFloat(i) * flagW
            let x1 = x0 + flagW
            let midX = x0 + flagW / 2
            path.move(to: CGPoint(x: x0, y: 0))
            path.addLine(to: CGPoint(x: x1, y: 0))
            path.addLine(to: CGPoint(x: midX, y: bannerH * 0.65))
            path.close()
            colors[i % colors.count].setFill()
            path.fill()
        }
        
        // Text "HAPPY BIRTHDAY"
        let textH = rect.height * 0.08
        let textRect = CGRect(x: 0, y: bannerH * 0.70, width: rect.width, height: textH)
        drawCenteredText("HAPPY BIRTHDAY", in: textRect, fontSize: textH * 0.46, color: uiColor(hex: "DC2626"), bold: true)
        
        // White rounded card for QR
        let cardSize = rect.width * 0.68
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: textRect.maxY + rect.height * 0.02,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.08)
        UIColor.white.setFill()
        whiteCard.fill()
        
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom party icons
        let footH = rect.height * 0.06
        let footRect = CGRect(x: 0, y: cardRect.maxY + rect.height * 0.015, width: rect.width, height: footH)
        drawCenteredText("🎈 YOU'RE INVITED 🎂", in: footRect, fontSize: footH * 0.44, color: uiColor(hex: "0284C7"), bold: true)
    }

    // MARK: - 16. Gift Box Present Card

    private static func drawGiftBoxCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        let ribbonRed = uiColor(hex: "E11D48")
        let boxMint = uiColor(hex: "CCFBF1")
        
        // Gift box body
        let boxMargin = rect.width * 0.10
        let boxRect = CGRect(
            x: boxMargin,
            y: rect.height * 0.22,
            width: rect.width - boxMargin * 2,
            height: rect.height * 0.72
        )
        let boxPath = UIBezierPath(roundedRect: boxRect, cornerRadius: rect.width * 0.06)
        boxMint.setFill()
        boxPath.fill()
        
        // Giant satin ribbon bow at top
        let bowCenter = CGPoint(x: rect.midX, y: boxRect.minY)
        let bowR = rect.width * 0.09
        
        ribbonRed.setFill()
        // Left loop
        let leftLoop = UIBezierPath(ovalIn: CGRect(x: bowCenter.x - bowR * 1.8, y: bowCenter.y - bowR * 1.2, width: bowR * 1.6, height: bowR * 1.2))
        leftLoop.fill()
        // Right loop
        let rightLoop = UIBezierPath(ovalIn: CGRect(x: bowCenter.x + bowR * 0.2, y: bowCenter.y - bowR * 1.2, width: bowR * 1.6, height: bowR * 1.2))
        rightLoop.fill()
        // Center knot
        let knot = UIBezierPath(ovalIn: CGRect(x: bowCenter.x - bowR * 0.5, y: bowCenter.y - bowR * 0.6, width: bowR, height: bowR * 0.9))
        knot.fill()
        
        // Vertical ribbon stripe
        let stripeW = rect.width * 0.09
        let vertStripe = CGRect(x: rect.midX - stripeW / 2, y: boxRect.minY, width: stripeW, height: boxRect.height)
        ribbonRed.withAlphaComponent(0.40).setFill()
        cgCtx.fill(vertStripe)
        
        // White rounded card inside gift box holding QR
        let cardSize = boxRect.width * 0.80
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: boxRect.minY + (boxRect.height - cardSize) / 2,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.08)
        UIColor.white.setFill()
        whiteCard.fill()
        
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
    }

    // MARK: - 17. Perforated Coupon Ticket

    private static func drawTicketCoupon(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        let margin = rect.width * 0.06
        let ticketRect = rect.insetBy(dx: margin, dy: margin)
        let ticketR = rect.width * 0.05
        
        // Clean dashed ticket border
        let path = UIBezierPath(roundedRect: ticketRect, cornerRadius: ticketR)
        path.lineWidth = rect.width * 0.012
        let dash: [CGFloat] = [rect.width * 0.03, rect.width * 0.02]
        path.setLineDash(dash, count: 2, phase: 0)
        accent.setStroke()
        path.stroke()
        
        // Left & Right semicircle cutouts
        let notchR = rect.width * 0.05
        let notchY = ticketRect.midY + rect.height * 0.15
        let leftNotch = UIBezierPath(arcCenter: CGPoint(x: ticketRect.minX, y: notchY), radius: notchR, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)
        UIColor.white.setFill()
        leftNotch.fill()
        accent.setStroke()
        leftNotch.lineWidth = rect.width * 0.012
        leftNotch.stroke()
        
        let rightNotch = UIBezierPath(arcCenter: CGPoint(x: ticketRect.maxX, y: notchY), radius: notchR, startAngle: CGFloat.pi / 2, endAngle: -CGFloat.pi / 2, clockwise: true)
        UIColor.white.setFill()
        rightNotch.fill()
        rightNotch.lineWidth = rect.width * 0.012
        rightNotch.stroke()
        
        // QR Code in upper section
        let qrSize = ticketRect.width * 0.72
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: ticketRect.minY + rect.height * 0.03,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom coupon badge
        let badgeH = rect.height * 0.08
        let badgeRect = CGRect(x: ticketRect.minX, y: ticketRect.maxY - badgeH - rect.height * 0.02, width: ticketRect.width, height: badgeH)
        drawCenteredText("✂ \(text.uppercased())", in: badgeRect, fontSize: badgeH * 0.42, color: accent, bold: true)
    }

    // MARK: - 18. Floral / Botanical Wreath Frame

    private static func drawFloralWreath(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // Soft pink or green rounded border
        let margin = rect.width * 0.06
        let frameRect = rect.insetBy(dx: margin, dy: margin)
        let frameR = rect.width * 0.08
        
        let borderPath = UIBezierPath(roundedRect: frameRect, cornerRadius: frameR)
        borderPath.lineWidth = rect.width * 0.010
        accent.withAlphaComponent(0.35).setStroke()
        borderPath.stroke()
        
        // Draw elegant watercolor floral clusters at Top-Left & Bottom-Right corners
        func drawFlowerCluster(at center: CGPoint, petalColor: UIColor, leafColor: UIColor) {
            let r = rect.width * 0.035
            // Leaves
            leafColor.setFill()
            for angle in [0.2, 0.9, -0.6] {
                let lx = center.x + CGFloat(cos(angle)) * r * 1.5
                let ly = center.y + CGFloat(sin(angle)) * r * 1.5
                let leaf = UIBezierPath(ovalIn: CGRect(x: lx - r * 0.6, y: ly - r * 0.4, width: r * 1.2, height: r * 0.8))
                leaf.fill()
            }
            // Petals
            petalColor.setFill()
            for i in 0..<5 {
                let a = Double(i) * Double.pi * 2.0 / 5.0
                let px = center.x + CGFloat(cos(a)) * r * 0.8
                let py = center.y + CGFloat(sin(a)) * r * 0.8
                let petal = UIBezierPath(ovalIn: CGRect(x: px - r * 0.5, y: py - r * 0.5, width: r, height: r))
                petal.fill()
            }
            // Center core
            uiColor(hex: "FDE047").setFill()
            UIBezierPath(ovalIn: CGRect(x: center.x - r * 0.3, y: center.y - r * 0.3, width: r * 0.6, height: r * 0.6)).fill()
        }
        
        drawFlowerCluster(at: CGPoint(x: frameRect.minX + frameR * 0.6, y: frameRect.minY + frameR * 0.6), petalColor: uiColor(hex: "FB7185"), leafColor: uiColor(hex: "4ADE80"))
        drawFlowerCluster(at: CGPoint(x: frameRect.maxX - frameR * 0.6, y: frameRect.maxY - frameR * 0.6), petalColor: uiColor(hex: "FB7185"), leafColor: uiColor(hex: "4ADE80"))
        
        // Centered QR Code
        let qrSize = rect.width * 0.66
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: (rect.height - qrSize) / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
    }

    // MARK: - 19. Cyberpunk Dark Neon Glow

    private static func drawNeonGlowCard(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        accent: UIColor,
        text: String
    ) {
        // Deep midnight canvas
        uiColor(hex: "06141B").setFill()
        cgCtx.fill(rect)
        
        let margin = rect.width * 0.08
        let innerRect = rect.insetBy(dx: margin, dy: margin)
        let innerR = rect.width * 0.06
        
        // Neon outer glow (3 blurred stroke passes)
        let glowColor = accent
        for (w, alpha) in [(rect.width * 0.035, 0.20), (rect.width * 0.020, 0.40), (rect.width * 0.008, 0.90)] {
            let path = UIBezierPath(roundedRect: innerRect, cornerRadius: innerR)
            path.lineWidth = w
            glowColor.withAlphaComponent(alpha).setStroke()
            path.stroke()
        }
        
        // QR Code inside
        let qrSize = rect.width * 0.68
        let qrRect = CGRect(
            x: (rect.width - qrSize) / 2,
            y: (rect.height - qrSize) / 2 - rect.height * 0.03,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Bottom neon label
        let labelH = rect.height * 0.07
        let labelRect = CGRect(x: 0, y: innerRect.maxY - labelH - rect.height * 0.015, width: rect.width, height: labelH)
        drawCenteredText(text.uppercased(), in: labelRect, fontSize: labelH * 0.42, color: accent, bold: true)
    }

    // MARK: - 20. Coffee Mug (Business & Café Menu)

    private static func drawCoffeeMug(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage,
        text: String
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        let mugDark = uiColor(hex: "1C1917")
        let warmCream = uiColor(hex: "FEF3C7")
        
        // Coffee mug body
        let mugW = rect.width * 0.68
        let mugH = rect.height * 0.72
        let mugRect = CGRect(
            x: rect.width * 0.12,
            y: (rect.height - mugH) / 2,
            width: mugW,
            height: mugH
        )
        let mugPath = UIBezierPath(roundedRect: mugRect, cornerRadius: rect.width * 0.08)
        mugDark.setFill()
        mugPath.fill()
        
        // Mug handle on right
        let handleRect = CGRect(
            x: mugRect.maxX - rect.width * 0.04,
            y: mugRect.midY - rect.height * 0.18,
            width: rect.width * 0.18,
            height: rect.height * 0.36
        )
        let handlePath = UIBezierPath(roundedRect: handleRect, cornerRadius: handleRect.width / 2)
        handlePath.lineWidth = rect.width * 0.04
        mugDark.setStroke()
        handlePath.stroke()
        
        // Cream label on mug body holding QR
        let labelSize = mugW * 0.76
        let labelRect = CGRect(
            x: mugRect.midX - labelSize / 2,
            y: mugRect.minY + rect.height * 0.04,
            width: labelSize,
            height: labelSize
        )
        let labelPath = UIBezierPath(roundedRect: labelRect, cornerRadius: rect.width * 0.04)
        warmCream.setFill()
        labelPath.fill()
        
        let qrSize = labelSize * 0.88
        let qrRect = CGRect(
            x: labelRect.midX - qrSize / 2,
            y: labelRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
        
        // Label on mug below QR
        let bottomH = rect.height * 0.06
        let bottomRect = CGRect(x: mugRect.minX, y: labelRect.maxY + rect.height * 0.015, width: mugRect.width, height: bottomH)
        drawCenteredText(text.uppercased(), in: bottomRect, fontSize: bottomH * 0.42, color: warmCream, bold: true)
    }

    // MARK: - 21. French Fries Carton (Fast Food Menu)

    private static func drawFrenchFries(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        let fryGold = uiColor(hex: "FBBF24")
        let cartonRed = uiColor(hex: "EF4444")
        
        // Golden fries sticking out top
        let fryCount = 7
        let fryW = rect.width * 0.065
        let startX = rect.width * 0.22
        for i in 0..<fryCount {
            let x = startX + CGFloat(i) * fryW * 1.15
            let fryH = rect.height * (0.20 + CGFloat((i * 3) % 4) * 0.03)
            let fryRect = CGRect(x: x, y: rect.height * 0.06, width: fryW, height: fryH)
            fryGold.setFill()
            UIBezierPath(roundedRect: fryRect, cornerRadius: 4).fill()
        }
        
        // Red fry carton box
        let cartonPath = UIBezierPath()
        let cTopY = rect.height * 0.26
        let cBotY = rect.height * 0.92
        cartonPath.move(to: CGPoint(x: rect.width * 0.16, y: cTopY))
        cartonPath.addLine(to: CGPoint(x: rect.width * 0.84, y: cTopY))
        cartonPath.addLine(to: CGPoint(x: rect.width * 0.74, y: cBotY))
        cartonPath.addLine(to: CGPoint(x: rect.width * 0.26, y: cBotY))
        cartonPath.close()
        cartonRed.setFill()
        cartonPath.fill()
        
        // White rounded card on carton holding QR
        let cardSize = rect.width * 0.52
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: cTopY + rect.height * 0.06,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.08)
        UIColor.white.setFill()
        whiteCard.fill()
        
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
    }

    // MARK: - 22. Popcorn Box (Movie Theater Menu)

    private static func drawPopcornBox(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        let redColor = uiColor(hex: "DC2626")
        let cornColor = uiColor(hex: "FEF08A")
        
        // Popcorn puffs at top
        cornColor.setFill()
        for i in 0..<8 {
            let x = rect.width * (0.20 + CGFloat(i) * 0.08)
            let y = rect.height * (0.08 + CGFloat((i * 2) % 3) * 0.03)
            let puff = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: rect.width * 0.10, height: rect.height * 0.09))
            puff.fill()
        }
        
        // Red & White vertical striped carton
        let boxTopY = rect.height * 0.24
        let boxBotY = rect.height * 0.92
        let numStripes = 7
        let stripeW = rect.width * 0.68 / CGFloat(numStripes)
        let startX = rect.width * 0.16
        
        for i in 0..<numStripes {
            let x = startX + CGFloat(i) * stripeW
            let stripe = CGRect(x: x, y: boxTopY, width: stripeW, height: boxBotY - boxTopY)
            if i % 2 == 0 {
                redColor.setFill()
            } else {
                UIColor.white.setFill()
            }
            cgCtx.fill(stripe)
        }
        
        // Inset white card on box holding QR
        let cardSize = rect.width * 0.54
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: boxTopY + rect.height * 0.06,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.08)
        UIColor.white.setFill()
        whiteCard.fill()
        
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
    }

    // MARK: - 23. Ice Cream Sundae Cup

    private static func drawIceCreamSundae(
        cgCtx: CGContext,
        rect: CGRect,
        qrImage: UIImage
    ) {
        UIColor.white.setFill()
        cgCtx.fill(rect)
        
        // Ice cream scoops at top (Strawberry & Vanilla)
        let scoopPink = uiColor(hex: "F472B6")
        let scoopCream = uiColor(hex: "FEF3C7")
        
        scoopPink.setFill()
        UIBezierPath(ovalIn: CGRect(x: rect.width * 0.22, y: rect.height * 0.08, width: rect.width * 0.32, height: rect.height * 0.22)).fill()
        
        scoopCream.setFill()
        UIBezierPath(ovalIn: CGRect(x: rect.width * 0.46, y: rect.height * 0.09, width: rect.width * 0.32, height: rect.height * 0.22)).fill()
        
        // Waffle cup body
        let cupPath = UIBezierPath()
        let cupTopY = rect.height * 0.28
        let cupBotY = rect.height * 0.92
        cupPath.move(to: CGPoint(x: rect.width * 0.18, y: cupTopY))
        cupPath.addLine(to: CGPoint(x: rect.width * 0.82, y: cupTopY))
        cupPath.addLine(to: CGPoint(x: rect.width * 0.68, y: cupBotY))
        cupPath.addLine(to: CGPoint(x: rect.width * 0.32, y: cupBotY))
        cupPath.close()
        uiColor(hex: "FDE68A").setFill() // Waffle yellow
        cupPath.fill()
        
        // White rounded card for QR
        let cardSize = rect.width * 0.50
        let cardRect = CGRect(
            x: (rect.width - cardSize) / 2,
            y: cupTopY + rect.height * 0.06,
            width: cardSize,
            height: cardSize
        )
        let whiteCard = UIBezierPath(roundedRect: cardRect, cornerRadius: cardSize * 0.08)
        UIColor.white.setFill()
        whiteCard.fill()
        
        let qrSize = cardSize * 0.88
        let qrRect = CGRect(
            x: cardRect.midX - qrSize / 2,
            y: cardRect.midY - qrSize / 2,
            width: qrSize,
            height: qrSize
        )
        qrImage.draw(in: qrRect)
    }

    // MARK: - Core Graphics Helpers

    private static func drawCenteredText(
        _ text: String,
        in rect: CGRect,
        fontSize: CGFloat,
        color: UIColor,
        bold: Bool
    ) {
        let weight: UIFont.Weight = bold ? .bold : .semibold
        let font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: style
        ]
        let size = (text as NSString).size(withAttributes: attrs)
        let textRect = CGRect(
            x: rect.minX,
            y: rect.midY - size.height / 2,
            width: rect.width,
            height: size.height
        )
        (text as NSString).draw(in: textRect, withAttributes: attrs)
    }

    private static func drawHeart(
        cgCtx: CGContext,
        center: CGPoint,
        size: CGFloat,
        color: UIColor
    ) {
        let path = UIBezierPath()
        let s = size
        let ox = center.x
        let oy = center.y - s * 0.3
        
        path.move(to: CGPoint(x: ox, y: oy + s * 0.7))
        path.addCurve(
            to: CGPoint(x: ox - s * 0.5, y: oy + s * 0.1),
            controlPoint1: CGPoint(x: ox - s * 0.25, y: oy + s * 0.55),
            controlPoint2: CGPoint(x: ox - s * 0.5, y: oy + s * 0.35)
        )
        path.addArc(
            withCenter: CGPoint(x: ox - s * 0.25, y: oy),
            radius: s * 0.25,
            startAngle: CGFloat.pi,
            endAngle: 0,
            clockwise: true
        )
        path.addArc(
            withCenter: CGPoint(x: ox + s * 0.25, y: oy),
            radius: s * 0.25,
            startAngle: CGFloat.pi,
            endAngle: 0,
            clockwise: true
        )
        path.addCurve(
            to: CGPoint(x: ox, y: oy + s * 0.7),
            controlPoint1: CGPoint(x: ox + s * 0.5, y: oy + s * 0.35),
            controlPoint2: CGPoint(x: ox + s * 0.25, y: oy + s * 0.55)
        )
        path.close()
        
        color.setFill()
        path.fill()
    }

    private static func uiColor(hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        let r = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgbValue & 0xFF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
