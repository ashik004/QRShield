//
//  TemplateFrameRenderer.swift
//  QRShield
//
//  Programmatic Core Graphics frame renderer for decorative QR code frames.
//

import UIKit

// MARK: - QRDecorativeFrame Enum

public enum QRDecorativeFrame: String, CaseIterable, Identifiable, Codable {
    case none = "None"

    // === BORDER FRAMES ===
    case solidBorder = "Solid Border"
    case gradientBorder = "Gradient Border"
    case doubleLine = "Double Line"
    case dashedBorder = "Dashed Border"

    // === BANNER FRAMES ===
    case scanMeBanner = "Scan Me Banner"
    case topBanner = "Top Banner"
    case fullBanner = "Full Banner"
    case ribbonBanner = "Ribbon Banner"

    // === SOCIAL BRAND FRAMES ===
    case socialGradientFrame = "Social Gradient"
    case socialHeaderFrame = "Social Header"

    // === THEMED DECORATIVE ===
    case cornerBrackets = "Corner Brackets"
    case cornerDots = "Corner Dots"
    case cornerHearts = "Corner Hearts"
    case cornerStars = "Corner Stars"
    case cornerFlourish = "Corner Flourish"

    // === SOLID BACKGROUND CARDS ===
    case colorCard = "Color Card"
    case gradientCard = "Gradient Card"

    // === SPECIAL OCCASION ===
    case neonGlowRing = "Neon Glow"
    case stampBorder = "Stamp Border"
    case wavesBorder = "Waves Border"
    case geometricFrame = "Geometric Frame"

    public var id: String { rawValue }
}

// MARK: - TemplateFrameRenderer

public final class TemplateFrameRenderer {

    // MARK: - Public API

    /// Renders the given QR image inside a decorative frame on a square canvas.
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

            // Default white background
            UIColor.white.setFill()
            cgCtx.fill(rect)

            switch frameType {
            case .none:
                drawQR(qrImage, in: rect, padding: 0.05, context: cgCtx)

            case .solidBorder:
                drawSolidBorder(cgCtx: cgCtx, rect: rect, accent: accent)
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)

            case .gradientBorder:
                drawGradientBorder(cgCtx: cgCtx, rect: rect, colors: brand.isEmpty ? [accent, accent.withAlphaComponent(0.5)] : brand)
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)

            case .doubleLine:
                drawDoubleLine(cgCtx: cgCtx, rect: rect, accent: accent)
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)

            case .dashedBorder:
                drawDashedBorder(cgCtx: cgCtx, rect: rect, accent: accent)
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)

            case .scanMeBanner:
                drawScanMeBanner(cgCtx: cgCtx, rect: rect, accent: accent, text: bannerText ?? "SCAN ME")
                drawQR(qrImage, in: rect, padding: 0.08, yOffset: -rect.height * 0.06, context: cgCtx)

            case .topBanner:
                drawTopBanner(cgCtx: cgCtx, rect: rect, accent: accent, text: bannerText ?? "SCAN ME")
                drawQR(qrImage, in: rect, padding: 0.08, yOffset: rect.height * 0.06, context: cgCtx)

            case .fullBanner:
                drawFullBanner(cgCtx: cgCtx, rect: rect, accent: accent,
                               topText: bannerText ?? "SCAN ME",
                               bottomText: "FOLLOW US")
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)

            case .ribbonBanner:
                drawQR(qrImage, in: rect, padding: 0.08, yOffset: -rect.height * 0.06, context: cgCtx)
                drawRibbonBanner(cgCtx: cgCtx, rect: rect, accent: accent, text: bannerText ?? "SCAN ME")

            case .socialGradientFrame:
                drawSocialGradientFrame(cgCtx: cgCtx, rect: rect,
                                        colors: brand.isEmpty ? [accent, accent.withAlphaComponent(0.5)] : brand)
                drawQR(qrImage, in: rect, padding: 0.14, context: cgCtx)

            case .socialHeaderFrame:
                drawSocialHeaderFrame(cgCtx: cgCtx, rect: rect, accent: accent,
                                      colors: brand.isEmpty ? [accent] : brand,
                                      headerText: bannerText ?? "FOLLOW US",
                                      footerText: "SCAN TO CONNECT")
                drawQR(qrImage, in: rect, padding: 0.12, yOffset: rect.height * 0.02, context: cgCtx)

            case .cornerBrackets:
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)
                drawCornerBrackets(cgCtx: cgCtx, rect: rect, accent: accent)

            case .cornerDots:
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)
                drawCornerDots(cgCtx: cgCtx, rect: rect, accent: accent)

            case .cornerHearts:
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)
                drawCornerHearts(cgCtx: cgCtx, rect: rect, accent: accent)

            case .cornerStars:
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)
                drawCornerStars(cgCtx: cgCtx, rect: rect, accent: accent)

            case .cornerFlourish:
                drawQR(qrImage, in: rect, padding: 0.12, context: cgCtx)
                drawCornerFlourish(cgCtx: cgCtx, rect: rect, accent: accent)

            case .colorCard:
                drawColorCard(cgCtx: cgCtx, rect: rect, accent: accent, text: bannerText)
                drawQR(qrImage, in: rect, padding: 0.15, context: cgCtx)

            case .gradientCard:
                drawGradientCard(cgCtx: cgCtx, rect: rect,
                                 colors: brand.isEmpty ? [accent, accent.withAlphaComponent(0.6)] : brand,
                                 text: bannerText)
                drawQR(qrImage, in: rect, padding: 0.15, context: cgCtx)

            case .neonGlowRing:
                drawNeonGlowRing(cgCtx: cgCtx, rect: rect, accent: accent)
                drawQR(qrImage, in: rect, padding: 0.14, context: cgCtx)

            case .stampBorder:
                drawStampBorder(cgCtx: cgCtx, rect: rect, accent: accent)
                drawQR(qrImage, in: rect, padding: 0.14, context: cgCtx)

            case .wavesBorder:
                drawWavesBorder(cgCtx: cgCtx, rect: rect, accent: accent)
                drawQR(qrImage, in: rect, padding: 0.14, context: cgCtx)

            case .geometricFrame:
                drawGeometricFrame(cgCtx: cgCtx, rect: rect, accent: accent)
                drawQR(qrImage, in: rect, padding: 0.14, context: cgCtx)
            }
        }
    }

    // MARK: - Hex Color Helper

    private static func uiColor(hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)

        let length = hexSanitized.count
        let r, g, b, a: CGFloat
        switch length {
        case 6:
            r = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
            g = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
            b = CGFloat(rgbValue & 0xFF) / 255.0
            a = 1.0
        case 8:
            r = CGFloat((rgbValue >> 24) & 0xFF) / 255.0
            g = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
            b = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
            a = CGFloat(rgbValue & 0xFF) / 255.0
        default:
            r = 0; g = 0; b = 0; a = 1.0
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    // MARK: - QR Drawing Helper

    /// Draws the QR image centered in `rect` with proportional padding. Optional vertical offset.
    private static func drawQR(
        _ image: UIImage,
        in rect: CGRect,
        padding: CGFloat,
        yOffset: CGFloat = 0,
        context: CGContext
    ) {
        let inset = rect.width * padding
        let qrSide = rect.width - inset * 2
        let qrRect = CGRect(
            x: rect.midX - qrSide / 2,
            y: rect.midY - qrSide / 2 + yOffset,
            width: qrSide,
            height: qrSide
        )
        // Ensure the QR area stays pure white
        context.setFillColor(UIColor.white.cgColor)
        context.fill(qrRect)
        image.draw(in: qrRect)
    }

    // MARK: - Gradient Helper

    private static func makeGradient(colors: [UIColor]) -> CGGradient? {
        let cgColors = colors.map { $0.cgColor } as CFArray
        return CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors, locations: nil)
    }

    // MARK: - Text Drawing Helper

    private static func drawCenteredText(
        _ text: String,
        in rect: CGRect,
        fontSize: CGFloat,
        color: UIColor,
        bold: Bool = true
    ) {
        let font = bold ? UIFont.systemFont(ofSize: fontSize, weight: .bold) : UIFont.systemFont(ofSize: fontSize, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        let size = (text as NSString).boundingRect(
            with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        ).size
        let textRect = CGRect(
            x: rect.origin.x,
            y: rect.midY - size.height / 2,
            width: rect.width,
            height: size.height
        )
        (text as NSString).draw(in: textRect, withAttributes: attributes)
    }

    // MARK: - Border Frames

    private static func drawSolidBorder(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let lineWidth: CGFloat = rect.width * 0.015 // ~12pt on 800
        let inset = lineWidth / 2 + rect.width * 0.03
        let borderRect = rect.insetBy(dx: inset, dy: inset)
        let path = UIBezierPath(roundedRect: borderRect, cornerRadius: rect.width * 0.03)
        path.lineWidth = lineWidth
        accent.setStroke()
        path.stroke()
    }

    private static func drawGradientBorder(cgCtx: CGContext, rect: CGRect, colors: [UIColor]) {
        let lineWidth: CGFloat = rect.width * 0.018
        let inset = lineWidth / 2 + rect.width * 0.03
        let borderRect = rect.insetBy(dx: inset, dy: inset)
        let outerPath = UIBezierPath(roundedRect: borderRect, cornerRadius: rect.width * 0.03)
        let innerRect = borderRect.insetBy(dx: lineWidth, dy: lineWidth)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: rect.width * 0.025)

        cgCtx.saveGState()
        outerPath.append(innerPath.reversing())
        outerPath.addClip()
        if let gradient = makeGradient(colors: colors) {
            cgCtx.drawLinearGradient(gradient,
                                     start: CGPoint(x: rect.minX, y: rect.minY),
                                     end: CGPoint(x: rect.maxX, y: rect.maxY),
                                     options: [])
        }
        cgCtx.restoreGState()
    }

    private static func drawDoubleLine(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let lineWidth: CGFloat = rect.width * 0.006
        let gap: CGFloat = rect.width * 0.012
        let outerInset = rect.width * 0.04
        let outerRect = rect.insetBy(dx: outerInset, dy: outerInset)
        let innerRect = outerRect.insetBy(dx: lineWidth + gap, dy: lineWidth + gap)
        let cornerRadius = rect.width * 0.025

        accent.setStroke()
        let outer = UIBezierPath(roundedRect: outerRect, cornerRadius: cornerRadius)
        outer.lineWidth = lineWidth
        outer.stroke()

        let inner = UIBezierPath(roundedRect: innerRect, cornerRadius: cornerRadius * 0.8)
        inner.lineWidth = lineWidth
        inner.stroke()
    }

    private static func drawDashedBorder(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let lineWidth: CGFloat = rect.width * 0.01
        let inset = lineWidth / 2 + rect.width * 0.04
        let borderRect = rect.insetBy(dx: inset, dy: inset)
        let path = UIBezierPath(roundedRect: borderRect, cornerRadius: rect.width * 0.03)
        path.lineWidth = lineWidth
        let dashPattern: [CGFloat] = [rect.width * 0.025, rect.width * 0.015]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        accent.setStroke()
        path.stroke()
    }

    // MARK: - Banner Frames

    private static func drawScanMeBanner(cgCtx: CGContext, rect: CGRect, accent: UIColor, text: String) {
        let bannerHeight = rect.height * 0.15
        let bannerRect = CGRect(x: 0, y: rect.height - bannerHeight, width: rect.width, height: bannerHeight)

        let bannerPath = UIBezierPath(
            roundedRect: bannerRect,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: rect.width * 0.03, height: rect.width * 0.03)
        )
        accent.setFill()
        bannerPath.fill()

        let fontSize = bannerHeight * 0.4
        drawCenteredText(text.uppercased(), in: bannerRect, fontSize: fontSize, color: .white)
    }

    private static func drawTopBanner(cgCtx: CGContext, rect: CGRect, accent: UIColor, text: String) {
        let bannerHeight = rect.height * 0.15
        let bannerRect = CGRect(x: 0, y: 0, width: rect.width, height: bannerHeight)

        let bannerPath = UIBezierPath(
            roundedRect: bannerRect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: rect.width * 0.03, height: rect.width * 0.03)
        )
        accent.setFill()
        bannerPath.fill()

        let fontSize = bannerHeight * 0.4
        drawCenteredText(text.uppercased(), in: bannerRect, fontSize: fontSize, color: .white)

        // Thin bottom border line
        let borderY = bannerHeight
        cgCtx.setStrokeColor(accent.cgColor)
        cgCtx.setLineWidth(rect.width * 0.004)
        cgCtx.move(to: CGPoint(x: 0, y: borderY))
        cgCtx.addLine(to: CGPoint(x: rect.width, y: borderY))
        cgCtx.strokePath()
    }

    private static func drawFullBanner(cgCtx: CGContext, rect: CGRect, accent: UIColor,
                                        topText: String, bottomText: String) {
        let bannerH = rect.height * 0.13

        // Top banner
        let topRect = CGRect(x: 0, y: 0, width: rect.width, height: bannerH)
        accent.setFill()
        UIBezierPath(rect: topRect).fill()
        drawCenteredText(topText.uppercased(), in: topRect, fontSize: bannerH * 0.4, color: .white)

        // Bottom banner
        let bottomRect = CGRect(x: 0, y: rect.height - bannerH, width: rect.width, height: bannerH)
        accent.setFill()
        UIBezierPath(rect: bottomRect).fill()
        drawCenteredText(bottomText.uppercased(), in: bottomRect, fontSize: bannerH * 0.35, color: .white)

        // Side borders
        let sideWidth = rect.width * 0.015
        accent.setFill()
        cgCtx.fill(CGRect(x: 0, y: bannerH, width: sideWidth, height: rect.height - bannerH * 2))
        cgCtx.fill(CGRect(x: rect.width - sideWidth, y: bannerH, width: sideWidth, height: rect.height - bannerH * 2))
    }

    private static func drawRibbonBanner(cgCtx: CGContext, rect: CGRect, accent: UIColor, text: String) {
        let ribbonH = rect.height * 0.09
        let ribbonW = rect.width * 0.65
        let notchDepth = ribbonH * 0.35
        let ribbonX = (rect.width - ribbonW) / 2
        let ribbonY = rect.height - rect.height * 0.08 - ribbonH

        let path = UIBezierPath()
        path.move(to: CGPoint(x: ribbonX, y: ribbonY))
        path.addLine(to: CGPoint(x: ribbonX + ribbonW, y: ribbonY))
        path.addLine(to: CGPoint(x: ribbonX + ribbonW, y: ribbonY + ribbonH))
        path.addLine(to: CGPoint(x: ribbonX + ribbonW / 2 + notchDepth, y: ribbonY + ribbonH))
        path.addLine(to: CGPoint(x: ribbonX + ribbonW / 2, y: ribbonY + ribbonH - notchDepth))
        path.addLine(to: CGPoint(x: ribbonX + ribbonW / 2 - notchDepth, y: ribbonY + ribbonH))
        path.addLine(to: CGPoint(x: ribbonX, y: ribbonY + ribbonH))
        path.close()

        accent.setFill()
        path.fill()

        let textRect = CGRect(x: ribbonX, y: ribbonY, width: ribbonW, height: ribbonH)
        drawCenteredText(text.uppercased(), in: textRect, fontSize: ribbonH * 0.42, color: .white)
    }

    // MARK: - Social Brand Frames

    private static func drawSocialGradientFrame(cgCtx: CGContext, rect: CGRect, colors: [UIColor]) {
        let lineWidth: CGFloat = rect.width * 0.025 // 20pt on 800
        let inset = lineWidth / 2 + rect.width * 0.02
        let borderRect = rect.insetBy(dx: inset, dy: inset)
        let outerPath = UIBezierPath(roundedRect: borderRect, cornerRadius: rect.width * 0.04)
        let innerRect = borderRect.insetBy(dx: lineWidth, dy: lineWidth)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: rect.width * 0.03)

        cgCtx.saveGState()
        outerPath.append(innerPath.reversing())
        outerPath.addClip()
        if let gradient = makeGradient(colors: colors) {
            cgCtx.drawLinearGradient(gradient,
                                     start: CGPoint(x: rect.minX, y: rect.maxY),
                                     end: CGPoint(x: rect.maxX, y: rect.minY),
                                     options: [])
        }
        cgCtx.restoreGState()

        // White fill inside for QR
        UIColor.white.setFill()
        innerPath.fill()
    }

    private static func drawSocialHeaderFrame(cgCtx: CGContext, rect: CGRect, accent: UIColor,
                                               colors: [UIColor], headerText: String, footerText: String) {
        let headerH = rect.height * 0.14
        let footerH = rect.height * 0.10

        // Header gradient bg
        cgCtx.saveGState()
        let headerRect = CGRect(x: 0, y: 0, width: rect.width, height: headerH)
        let headerPath = UIBezierPath(
            roundedRect: headerRect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: rect.width * 0.03, height: rect.width * 0.03)
        )
        headerPath.addClip()
        if let gradient = makeGradient(colors: colors.isEmpty ? [accent] : colors) {
            cgCtx.drawLinearGradient(gradient,
                                     start: CGPoint(x: 0, y: 0),
                                     end: CGPoint(x: rect.width, y: 0),
                                     options: [])
        }
        cgCtx.restoreGState()

        drawCenteredText(headerText.uppercased(), in: headerRect, fontSize: headerH * 0.42, color: .white)

        // Thin accent border on sides and bottom
        let borderWidth: CGFloat = rect.width * 0.006
        accent.setStroke()
        let borderRect = CGRect(x: 0, y: headerH, width: rect.width, height: rect.height - headerH)
        let borderPath = UIBezierPath(rect: borderRect)
        borderPath.lineWidth = borderWidth
        borderPath.stroke()

        // Footer text
        let footerRect = CGRect(x: 0, y: rect.height - footerH, width: rect.width, height: footerH)
        accent.withAlphaComponent(0.1).setFill()
        UIBezierPath(rect: footerRect).fill()
        drawCenteredText(footerText.uppercased(), in: footerRect, fontSize: footerH * 0.35, color: accent, bold: false)
    }

    // MARK: - Corner Decorative Frames

    private static func drawCornerBrackets(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let margin = rect.width * 0.06
        let len = rect.width * 0.20
        let lw: CGFloat = rect.width * 0.008

        cgCtx.setStrokeColor(accent.cgColor)
        cgCtx.setLineWidth(lw)
        cgCtx.setLineCap(.round)

        // Top-left
        cgCtx.move(to: CGPoint(x: margin, y: margin + len))
        cgCtx.addLine(to: CGPoint(x: margin, y: margin))
        cgCtx.addLine(to: CGPoint(x: margin + len, y: margin))

        // Top-right
        cgCtx.move(to: CGPoint(x: rect.width - margin - len, y: margin))
        cgCtx.addLine(to: CGPoint(x: rect.width - margin, y: margin))
        cgCtx.addLine(to: CGPoint(x: rect.width - margin, y: margin + len))

        // Bottom-left
        cgCtx.move(to: CGPoint(x: margin, y: rect.height - margin - len))
        cgCtx.addLine(to: CGPoint(x: margin, y: rect.height - margin))
        cgCtx.addLine(to: CGPoint(x: margin + len, y: rect.height - margin))

        // Bottom-right
        cgCtx.move(to: CGPoint(x: rect.width - margin - len, y: rect.height - margin))
        cgCtx.addLine(to: CGPoint(x: rect.width - margin, y: rect.height - margin))
        cgCtx.addLine(to: CGPoint(x: rect.width - margin, y: rect.height - margin - len))

        cgCtx.strokePath()
    }

    private static func drawCornerDots(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let margin = rect.width * 0.06
        let dotR = rect.width * 0.012
        let spacing = rect.width * 0.045

        accent.setFill()

        let corners: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
            (1, 1, margin, margin),                                             // TL
            (-1, 1, rect.width - margin, margin),                              // TR
            (1, -1, margin, rect.height - margin),                             // BL
            (-1, -1, rect.width - margin, rect.height - margin)                // BR
        ]

        for (dx, dy, ox, oy) in corners {
            // Corner dot
            UIBezierPath(ovalIn: CGRect(x: ox - dotR, y: oy - dotR, width: dotR * 2, height: dotR * 2)).fill()
            // Horizontal dots
            for i in 1...2 {
                let x = ox + dx * spacing * CGFloat(i)
                UIBezierPath(ovalIn: CGRect(x: x - dotR, y: oy - dotR, width: dotR * 2, height: dotR * 2)).fill()
            }
            // Vertical dots
            for i in 1...2 {
                let y = oy + dy * spacing * CGFloat(i)
                UIBezierPath(ovalIn: CGRect(x: ox - dotR, y: y - dotR, width: dotR * 2, height: dotR * 2)).fill()
            }
        }
    }

    private static func drawCornerHearts(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let heartSize = rect.width * 0.07
        let margin = rect.width * 0.05

        let positions: [(CGFloat, CGFloat, CGFloat)] = [
            (margin + heartSize / 2, margin + heartSize / 2, 0),                                       // TL
            (rect.width - margin - heartSize / 2, margin + heartSize / 2, 0),                          // TR
            (margin + heartSize / 2, rect.height - margin - heartSize / 2, 0),                         // BL
            (rect.width - margin - heartSize / 2, rect.height - margin - heartSize / 2, 0)             // BR
        ]

        accent.setFill()
        for (cx, cy, _) in positions {
            drawHeart(cgCtx: cgCtx, center: CGPoint(x: cx, y: cy), size: heartSize, color: accent)
        }
    }

    private static func drawHeart(cgCtx: CGContext, center: CGPoint, size: CGFloat, color: UIColor) {
        let path = UIBezierPath()
        let s = size / 2
        let topY = center.y - s * 0.4

        path.move(to: CGPoint(x: center.x, y: center.y + s * 0.7))

        // Left arc
        path.addCurve(
            to: CGPoint(x: center.x - s, y: topY),
            controlPoint1: CGPoint(x: center.x - s * 0.6, y: center.y + s * 0.4),
            controlPoint2: CGPoint(x: center.x - s * 1.2, y: topY + s * 0.3)
        )
        // Left top bump
        path.addArc(
            withCenter: CGPoint(x: center.x - s * 0.5, y: topY),
            radius: s * 0.5,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )
        // Right top bump
        path.addArc(
            withCenter: CGPoint(x: center.x + s * 0.5, y: topY),
            radius: s * 0.5,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )
        // Right curve back down
        path.addCurve(
            to: CGPoint(x: center.x, y: center.y + s * 0.7),
            controlPoint1: CGPoint(x: center.x + s * 1.2, y: topY + s * 0.3),
            controlPoint2: CGPoint(x: center.x + s * 0.6, y: center.y + s * 0.4)
        )
        path.close()

        color.setFill()
        path.fill()
    }

    private static func drawCornerStars(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let starSize = rect.width * 0.06
        let margin = rect.width * 0.06

        let positions: [CGPoint] = [
            CGPoint(x: margin + starSize, y: margin + starSize),
            CGPoint(x: rect.width - margin - starSize, y: margin + starSize),
            CGPoint(x: margin + starSize, y: rect.height - margin - starSize),
            CGPoint(x: rect.width - margin - starSize, y: rect.height - margin - starSize)
        ]

        accent.setFill()
        for center in positions {
            drawStar(center: center, points: 5, outerRadius: starSize, innerRadius: starSize * 0.4, color: accent)
        }
    }

    private static func drawStar(center: CGPoint, points: Int, outerRadius: CGFloat,
                                  innerRadius: CGFloat, color: UIColor) {
        let path = UIBezierPath()
        let angleIncrement = CGFloat.pi / CGFloat(points)
        var angle = -CGFloat.pi / 2

        for i in 0..<(points * 2) {
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            angle += angleIncrement
        }
        path.close()
        color.setFill()
        path.fill()
    }

    private static func drawCornerFlourish(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let margin = rect.width * 0.05
        let size = rect.width * 0.15
        let lw = rect.width * 0.006

        cgCtx.setStrokeColor(accent.cgColor)
        cgCtx.setLineWidth(lw)
        cgCtx.setLineCap(.round)

        // Helper to draw a single flourish spiral starting from a corner
        func drawFlourish(ox: CGFloat, oy: CGFloat, dx: CGFloat, dy: CGFloat) {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: ox, y: oy))

            // Main curve
            path.addCurve(
                to: CGPoint(x: ox + dx * size, y: oy),
                controlPoint1: CGPoint(x: ox, y: oy + dy * size * 0.8),
                controlPoint2: CGPoint(x: ox + dx * size * 0.8, y: oy + dy * size * 0.4)
            )

            // Second curve (spiral inward)
            path.addCurve(
                to: CGPoint(x: ox + dx * size * 0.3, y: oy + dy * size * 0.3),
                controlPoint1: CGPoint(x: ox + dx * size * 0.9, y: oy - dy * size * 0.3),
                controlPoint2: CGPoint(x: ox + dx * size * 0.5, y: oy + dy * size * 0.1)
            )

            // Vertical arm
            let vPath = UIBezierPath()
            vPath.move(to: CGPoint(x: ox, y: oy))
            vPath.addCurve(
                to: CGPoint(x: ox, y: oy + dy * size),
                controlPoint1: CGPoint(x: ox + dx * size * 0.8, y: oy),
                controlPoint2: CGPoint(x: ox + dx * size * 0.4, y: oy + dy * size * 0.8)
            )

            path.lineWidth = lw
            vPath.lineWidth = lw
            accent.setStroke()
            path.stroke()
            vPath.stroke()
        }

        drawFlourish(ox: margin, oy: margin, dx: 1, dy: 1)             // TL
        drawFlourish(ox: rect.width - margin, oy: margin, dx: -1, dy: 1) // TR
        drawFlourish(ox: margin, oy: rect.height - margin, dx: 1, dy: -1) // BL
        drawFlourish(ox: rect.width - margin, oy: rect.height - margin, dx: -1, dy: -1) // BR
    }

    // MARK: - Card Frames

    private static func drawColorCard(cgCtx: CGContext, rect: CGRect, accent: UIColor, text: String?) {
        // Fill entire canvas with accent
        accent.setFill()
        cgCtx.fill(rect)

        // White rounded rect for QR area
        let inset = rect.width * 0.10
        let whiteRect = rect.insetBy(dx: inset, dy: inset)
        let whitePath = UIBezierPath(roundedRect: whiteRect, cornerRadius: rect.width * 0.03)
        UIColor.white.setFill()
        whitePath.fill()

        // Optional banner text at bottom of colored area
        if let text = text, !text.isEmpty {
            let textRect = CGRect(x: 0, y: rect.height - inset * 0.9, width: rect.width, height: inset * 0.6)
            drawCenteredText(text.uppercased(), in: textRect, fontSize: inset * 0.3, color: .white)
        }
    }

    private static func drawGradientCard(cgCtx: CGContext, rect: CGRect, colors: [UIColor], text: String?) {
        // Gradient background
        cgCtx.saveGState()
        if let gradient = makeGradient(colors: colors) {
            cgCtx.drawLinearGradient(gradient,
                                     start: CGPoint(x: 0, y: 0),
                                     end: CGPoint(x: rect.width, y: rect.height),
                                     options: [])
        }
        cgCtx.restoreGState()

        // White rounded rect for QR area
        let inset = rect.width * 0.10
        let whiteRect = rect.insetBy(dx: inset, dy: inset)
        let whitePath = UIBezierPath(roundedRect: whiteRect, cornerRadius: rect.width * 0.03)
        UIColor.white.setFill()
        whitePath.fill()

        // Optional text
        if let text = text, !text.isEmpty {
            let textRect = CGRect(x: 0, y: rect.height - inset * 0.9, width: rect.width, height: inset * 0.6)
            drawCenteredText(text.uppercased(), in: textRect, fontSize: inset * 0.3, color: .white)
        }
    }

    // MARK: - Special Occasion Frames

    private static func drawNeonGlowRing(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let baseInset = rect.width * 0.08
        let baseRect = rect.insetBy(dx: baseInset, dy: baseInset)
        let cornerRadius = rect.width * 0.04

        // Draw multiple layers with decreasing opacity and increasing width for glow
        let layers: [(CGFloat, CGFloat)] = [
            (rect.width * 0.040, 0.08),  // outermost glow
            (rect.width * 0.030, 0.12),
            (rect.width * 0.022, 0.18),
            (rect.width * 0.016, 0.28),
            (rect.width * 0.010, 0.45),
            (rect.width * 0.006, 0.70),
            (rect.width * 0.003, 1.00),  // core stroke
        ]

        for (width, alpha) in layers {
            let path = UIBezierPath(roundedRect: baseRect, cornerRadius: cornerRadius)
            path.lineWidth = width
            accent.withAlphaComponent(alpha).setStroke()
            path.stroke()
        }
    }

    private static func drawStampBorder(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let margin = rect.width * 0.04
        let stampRect = rect.insetBy(dx: margin, dy: margin)
        let notchRadius: CGFloat = rect.width * 0.012
        let spacing: CGFloat = notchRadius * 4

        // Fill the outer rectangle area with accent color
        let outerPath = UIBezierPath(rect: stampRect)

        // Create notch cutouts along each edge
        let notchPath = UIBezierPath()

        // Top edge notches
        var x = stampRect.minX + spacing
        while x < stampRect.maxX - spacing / 2 {
            notchPath.append(UIBezierPath(ovalIn: CGRect(
                x: x - notchRadius, y: stampRect.minY - notchRadius,
                width: notchRadius * 2, height: notchRadius * 2)))
            x += spacing
        }

        // Bottom edge notches
        x = stampRect.minX + spacing
        while x < stampRect.maxX - spacing / 2 {
            notchPath.append(UIBezierPath(ovalIn: CGRect(
                x: x - notchRadius, y: stampRect.maxY - notchRadius,
                width: notchRadius * 2, height: notchRadius * 2)))
            x += spacing
        }

        // Left edge notches
        var y = stampRect.minY + spacing
        while y < stampRect.maxY - spacing / 2 {
            notchPath.append(UIBezierPath(ovalIn: CGRect(
                x: stampRect.minX - notchRadius, y: y - notchRadius,
                width: notchRadius * 2, height: notchRadius * 2)))
            y += spacing
        }

        // Right edge notches
        y = stampRect.minY + spacing
        while y < stampRect.maxY - spacing / 2 {
            notchPath.append(UIBezierPath(ovalIn: CGRect(
                x: stampRect.maxX - notchRadius, y: y - notchRadius,
                width: notchRadius * 2, height: notchRadius * 2)))
            y += spacing
        }

        // Draw stamp: outer rect minus notch circles
        cgCtx.saveGState()
        outerPath.append(notchPath.reversing())
        accent.setFill()
        outerPath.fill()
        cgCtx.restoreGState()

        // White inner area for the QR code
        let innerInset = rect.width * 0.09
        let innerRect = rect.insetBy(dx: innerInset, dy: innerInset)
        UIColor.white.setFill()
        UIBezierPath(rect: innerRect).fill()
    }

    private static func drawWavesBorder(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let margin = rect.width * 0.05
        let waveAmp = rect.width * 0.015
        let waveLen = rect.width * 0.06
        let lw = rect.width * 0.006

        cgCtx.setStrokeColor(accent.cgColor)
        cgCtx.setLineWidth(lw)

        func wavePath(from start: CGPoint, to end: CGPoint, segments: Int, perpX: CGFloat, perpY: CGFloat) -> UIBezierPath {
            let path = UIBezierPath()
            path.move(to: start)
            let dx = (end.x - start.x) / CGFloat(segments)
            let dy = (end.y - start.y) / CGFloat(segments)

            for i in 0..<segments {
                let midX = start.x + dx * (CGFloat(i) + 0.5)
                let midY = start.y + dy * (CGFloat(i) + 0.5)
                let dir: CGFloat = (i % 2 == 0) ? 1 : -1
                let cpX = midX + perpX * waveAmp * dir
                let cpY = midY + perpY * waveAmp * dir
                let endPtX = start.x + dx * CGFloat(i + 1)
                let endPtY = start.y + dy * CGFloat(i + 1)
                path.addQuadCurve(to: CGPoint(x: endPtX, y: endPtY),
                                  controlPoint: CGPoint(x: cpX, y: cpY))
            }
            return path
        }

        let segments = Int(rect.width / waveLen)
        let inset = margin

        // Top wave
        wavePath(from: CGPoint(x: inset, y: inset),
                 to: CGPoint(x: rect.width - inset, y: inset),
                 segments: segments, perpX: 0, perpY: 1).stroke()

        // Bottom wave
        wavePath(from: CGPoint(x: inset, y: rect.height - inset),
                 to: CGPoint(x: rect.width - inset, y: rect.height - inset),
                 segments: segments, perpX: 0, perpY: -1).stroke()

        // Left wave
        wavePath(from: CGPoint(x: inset, y: inset),
                 to: CGPoint(x: inset, y: rect.height - inset),
                 segments: segments, perpX: 1, perpY: 0).stroke()

        // Right wave
        wavePath(from: CGPoint(x: rect.width - inset, y: inset),
                 to: CGPoint(x: rect.width - inset, y: rect.height - inset),
                 segments: segments, perpX: -1, perpY: 0).stroke()
    }

    private static func drawGeometricFrame(cgCtx: CGContext, rect: CGRect, accent: UIColor) {
        let margin = rect.width * 0.04
        let borderWidth = rect.width * 0.06
        let triSize = rect.width * 0.028
        let halfTri = triSize / 2

        // Draw geometric patterns along each edge
        accent.setFill()

        func drawTrianglesH(y: CGFloat, flipped: Bool) {
            var x = margin + triSize
            while x < rect.width - margin - triSize {
                let path = UIBezierPath()
                let tipY = flipped ? y + triSize : y - triSize
                path.move(to: CGPoint(x: x - halfTri, y: y))
                path.addLine(to: CGPoint(x: x + halfTri, y: y))
                path.addLine(to: CGPoint(x: x, y: tipY))
                path.close()
                path.fill()
                x += triSize * 1.5
            }
        }

        func drawTrianglesV(x: CGFloat, flipped: Bool) {
            var y = margin + borderWidth + triSize
            while y < rect.height - margin - borderWidth - triSize {
                let path = UIBezierPath()
                let tipX = flipped ? x + triSize : x - triSize
                path.move(to: CGPoint(x: x, y: y - halfTri))
                path.addLine(to: CGPoint(x: x, y: y + halfTri))
                path.addLine(to: CGPoint(x: tipX, y: y))
                path.close()
                path.fill()
                y += triSize * 1.5
            }
        }

        // Thin border rectangles
        let outerRect = rect.insetBy(dx: margin, dy: margin)
        accent.withAlphaComponent(0.15).setFill()
        let borderPath = UIBezierPath(rect: outerRect)
        let innerRect = outerRect.insetBy(dx: borderWidth, dy: borderWidth)
        borderPath.append(UIBezierPath(rect: innerRect).reversing())
        borderPath.fill()

        // Triangles
        accent.setFill()
        drawTrianglesH(y: margin + borderWidth * 0.5, flipped: true)                  // Top
        drawTrianglesH(y: rect.height - margin - borderWidth * 0.5, flipped: false)   // Bottom
        drawTrianglesV(x: margin + borderWidth * 0.5, flipped: true)                  // Left
        drawTrianglesV(x: rect.width - margin - borderWidth * 0.5, flipped: false)    // Right

        // Accent line inner border
        let innerBorderPath = UIBezierPath(rect: innerRect)
        innerBorderPath.lineWidth = rect.width * 0.003
        accent.setStroke()
        innerBorderPath.stroke()
    }
}
