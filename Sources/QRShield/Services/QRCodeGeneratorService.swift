import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

public final class QRCodeGeneratorService {
    public static let shared = QRCodeGeneratorService()
    
    private let context = CIContext()
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {
        imageCache.countLimit = 150
    }
    
    /// Generates a high-resolution styled UIImage for the given content and configuration
    public func generateQRCode(
        from content: String,
        style: QRStyleConfig,
        size: CGSize = CGSize(width: 800, height: 800)
    ) -> UIImage? {
        let textKey = style.customText ?? ""
        let bannerKey = style.bannerText ?? ""
        let brandColorsKey = (style.frameBrandColors ?? []).joined(separator: "-")
        let cacheKey = "\(content)_\(style.dotStyle.rawValue)_\(style.eyeStyle.rawValue)_\(style.colorTheme.rawValue)_\(style.backgroundColorHex)_\(style.logoType.rawValue)_\(textKey)_\(style.textPositionAbove)_\(style.textFont)_\(style.textColorHex)_\(style.decorativeFrame.rawValue)_\(bannerKey)_\(brandColorsKey)_\(Int(size.width))x\(Int(size.height))" as NSString
        if let cached = imageCache.object(forKey: cacheKey) {
            return cached
        }
        
        guard let data = content.data(using: .utf8) else { return nil }
        
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel") // High error correction
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        // Extract the boolean matrix
        let matrix = extractMatrix(from: outputCIImage)
        guard !matrix.isEmpty else {
            // Fallback to basic scaling if matrix extraction fails
            let transform = CGAffineTransform(scaleX: size.width / outputCIImage.extent.width,
                                              y: size.height / outputCIImage.extent.height)
            let scaledCI = outputCIImage.transformed(by: transform)
            if let cgImage = context.createCGImage(scaledCI, from: scaledCI.extent) {
                var img = UIImage(cgImage: cgImage)
                if style.decorativeFrame != .none {
                    img = TemplateFrameRenderer.renderFramedQR(
                        qrImage: img,
                        frameType: style.decorativeFrame,
                        canvasSize: size,
                        brandColors: style.frameBrandColors ?? style.colorTheme.hexColors,
                        bannerText: style.bannerText,
                        accentColorHex: style.colorTheme.hexColors.first ?? "000000"
                    )
                }
                imageCache.setObject(img, forKey: cacheKey)
                return img
            }
            return nil
        }
        
        // Render custom styled image
        var rendered = renderStyledQR(matrix: matrix, style: style, canvasSize: size)
        
        // Apply decorative frame if specified
        if style.decorativeFrame != .none {
            rendered = TemplateFrameRenderer.renderFramedQR(
                qrImage: rendered,
                frameType: style.decorativeFrame,
                canvasSize: size,
                brandColors: style.frameBrandColors ?? style.colorTheme.hexColors,
                bannerText: style.bannerText,
                accentColorHex: style.colorTheme.hexColors.first ?? "000000"
            )
        }
        
        imageCache.setObject(rendered, forKey: cacheKey)
        return rendered
    }
    
    /// Extracts module grid (true = dark, false = light)
    private func extractMatrix(from ciImage: CIImage) -> [[Bool]] {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return [] }
        let width = cgImage.width
        let height = cgImage.height
        
        guard let data = cgImage.dataProvider?.data,
              let bytes = CFDataGetBytePtr(data) else { return [] }
        
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let bytesPerRow = cgImage.bytesPerRow
        
        var matrix: [[Bool]] = Array(repeating: Array(repeating: false, count: width), count: height)
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelOffset = y * bytesPerRow + x * bytesPerPixel
                // CIQRCodeGenerator produces 1-byte grayscale or 4-byte RGBA where black = 0
                let intensity = bytes[pixelOffset]
                matrix[y][x] = intensity < 128
            }
        }
        return matrix
    }
    
    /// Renders custom dot styles, gradients, finder patterns, and central logo onto a UIGraphicsImageRenderer canvas
    private func renderStyledQR(matrix: [[Bool]], style: QRStyleConfig, canvasSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        
        return renderer.image { ctx in
            let cgContext = ctx.cgContext
            
            // 1. Background fill
            let bgColor = UIColor(Color(hex: style.backgroundColorHex))
            cgContext.setFillColor(bgColor.cgColor)
            cgContext.fill(CGRect(origin: .zero, size: canvasSize))
            
            let numRows = matrix.count
            let numCols = matrix.first?.count ?? 1
            
            let hasText = style.hasCustomText
            let textHeight: CGFloat = hasText ? canvasSize.height * 0.08 : 0
            let basePadding: CGFloat = canvasSize.width * 0.06
            
            let paddingLeft = basePadding
            let paddingRight = basePadding
            let paddingTop = basePadding + (hasText && style.textPositionAbove ? textHeight : 0)
            let paddingBottom = basePadding + (hasText && !style.textPositionAbove ? textHeight : 0)
            
            let qrDrawWidth = canvasSize.width - (paddingLeft + paddingRight)
            let qrDrawHeight = canvasSize.height - (paddingTop + paddingBottom)
            let moduleWidth = qrDrawWidth / CGFloat(numCols)
            let moduleHeight = qrDrawHeight / CGFloat(numRows)
            
            // Draw Custom Text Label if present
            if let text = style.customText, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let fontSize = canvasSize.width * 0.048
                let font = uiFont(for: style.textFont, size: fontSize)
                let textColor = UIColor(Color(hex: style.textColorHex))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: textColor,
                    .paragraphStyle: paragraphStyle
                ]
                let textRect: CGRect
                if style.textPositionAbove {
                    textRect = CGRect(x: basePadding, y: basePadding * 0.4, width: canvasSize.width - (basePadding * 2), height: textHeight)
                } else {
                    textRect = CGRect(x: basePadding, y: canvasSize.height - (basePadding * 0.4) - textHeight, width: canvasSize.width - (basePadding * 2), height: textHeight)
                }
                (text as NSString).draw(in: textRect, withAttributes: attributes)
            }
            
            // Center clear zone if logo is present
            let centerRatio: CGFloat = style.logoType != .none ? 0.24 : 0.0
            let qrCenterX = paddingLeft + qrDrawWidth * 0.5
            let qrCenterY = paddingTop + qrDrawHeight * 0.5
            let centerRect = CGRect(
                x: qrCenterX - (qrDrawWidth * centerRatio) / 2,
                y: qrCenterY - (qrDrawHeight * centerRatio) / 2,
                width: qrDrawWidth * centerRatio,
                height: qrDrawHeight * centerRatio
            )
            
            // Setup gradient colors
            let uiColors = style.colorTheme.hexColors.map { UIColor(Color(hex: $0)).cgColor }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: uiColors as CFArray, locations: nil)
            
            // Create path for all active QR modules
            let dotsPath = UIBezierPath()
            dotsPath.usesEvenOddFillRule = true
            
            // Body dots (Skip the 3 7x7 corner finder patterns)
            for y in 0..<numRows {
                for x in 0..<numCols {
                    guard matrix[y][x] else { continue }
                    
                    // Skip 7x7 finder patterns (Top-Left, Top-Right, Bottom-Left)
                    let isFinderPattern = (x < 7 && y < 7) ||
                                          (x >= numCols - 7 && y < 7) ||
                                          (x < 7 && y >= numRows - 7)
                    if isFinderPattern { continue }
                    
                    let rect = CGRect(
                        x: paddingLeft + CGFloat(x) * moduleWidth,
                        y: paddingTop + CGFloat(y) * moduleHeight,
                        width: moduleWidth,
                        height: moduleHeight
                    )
                    
                    // Skip dots covered by center logo
                    if centerRatio > 0 && centerRect.intersects(rect) {
                        continue
                    }
                    
                    switch style.dotStyle {
                    case .square:
                        // Smooth micro-radius eliminates sharp spiky spurs at module intersections
                        let cornerR = max(1.0, moduleWidth * 0.15)
                        let squareDot = UIBezierPath(roundedRect: rect.insetBy(dx: 0.2, dy: 0.2), cornerRadius: cornerR)
                        dotsPath.append(squareDot)
                        
                    case .rounded:
                        let roundedDot = UIBezierPath(roundedRect: rect.insetBy(dx: 0.4, dy: 0.4), cornerRadius: moduleWidth * 0.35)
                        dotsPath.append(roundedDot)
                        
                    case .circular:
                        let circleDot = UIBezierPath(ovalIn: rect.insetBy(dx: moduleWidth * 0.12, dy: moduleHeight * 0.12))
                        dotsPath.append(circleDot)
                        
                    case .diamond:
                        let diamondDot = UIBezierPath()
                        let insetRect = rect.insetBy(dx: 0.4, dy: 0.4)
                        diamondDot.move(to: CGPoint(x: insetRect.midX, y: insetRect.minY))
                        diamondDot.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.midY))
                        diamondDot.addLine(to: CGPoint(x: insetRect.midX, y: insetRect.maxY))
                        diamondDot.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.midY))
                        diamondDot.close()
                        dotsPath.append(diamondDot)
                    }
                }
            }
            
            // Draw Composite 7x7 Corner Finder Patterns (Outer Ring + Inner Dot)
            enum FinderCorner {
                case topLeft, topRight, bottomLeft
            }
            
            func addFinderPattern(col: Int, row: Int, corner: FinderCorner) {
                let originX = paddingLeft + CGFloat(col) * moduleWidth
                let originY = paddingTop + CGFloat(row) * moduleHeight
                
                let outerRect = CGRect(x: originX, y: originY, width: 7 * moduleWidth, height: 7 * moduleHeight)
                let innerCutoutRect = CGRect(x: originX + moduleWidth, y: originY + moduleHeight, width: 5 * moduleWidth, height: 5 * moduleHeight)
                let centerDotRect = CGRect(x: originX + 2 * moduleWidth, y: originY + 2 * moduleHeight, width: 3 * moduleWidth, height: 3 * moduleHeight)
                
                let outerPath: UIBezierPath
                let innerHolePath: UIBezierPath
                let centerDotPath: UIBezierPath
                
                switch style.eyeStyle {
                case .square:
                    // Subtle smooth rounding for square eyes so corners don't spike or poke out
                    let outerR = moduleWidth * 0.5
                    let innerR = moduleWidth * 0.3
                    let centerR = moduleWidth * 0.25
                    outerPath = UIBezierPath(roundedRect: outerRect, cornerRadius: outerR)
                    innerHolePath = UIBezierPath(roundedRect: innerCutoutRect, cornerRadius: innerR)
                    centerDotPath = UIBezierPath(roundedRect: centerDotRect, cornerRadius: centerR)
                    
                case .rounded:
                    outerPath = UIBezierPath(roundedRect: outerRect, cornerRadius: moduleWidth * 1.8)
                    innerHolePath = UIBezierPath(roundedRect: innerCutoutRect, cornerRadius: moduleWidth * 1.0)
                    centerDotPath = UIBezierPath(roundedRect: centerDotRect, cornerRadius: moduleWidth * 0.9)
                    
                case .circular:
                    outerPath = UIBezierPath(ovalIn: outerRect)
                    innerHolePath = UIBezierPath(ovalIn: innerCutoutRect)
                    centerDotPath = UIBezierPath(ovalIn: centerDotRect)
                    
                case .leaf:
                    let corners: UIRectCorner
                    switch corner {
                    case .topLeft:
                        corners = [.topLeft, .bottomRight]
                    case .topRight:
                        corners = [.topRight, .bottomLeft]
                    case .bottomLeft:
                        corners = [.bottomLeft, .topRight]
                    }
                    outerPath = UIBezierPath(roundedRect: outerRect, byRoundingCorners: corners, cornerRadii: CGSize(width: moduleWidth * 3.5, height: moduleWidth * 3.5))
                    innerHolePath = UIBezierPath(roundedRect: innerCutoutRect, byRoundingCorners: corners, cornerRadii: CGSize(width: moduleWidth * 2.2, height: moduleWidth * 2.2))
                    centerDotPath = UIBezierPath(roundedRect: centerDotRect, byRoundingCorners: corners, cornerRadii: CGSize(width: moduleWidth * 1.5, height: moduleWidth * 1.5))
                }
                
                dotsPath.append(outerPath)
                dotsPath.append(innerHolePath)
                dotsPath.append(centerDotPath)
            }
            
            // Top-Left Finder
            addFinderPattern(col: 0, row: 0, corner: .topLeft)
            // Top-Right Finder
            addFinderPattern(col: numCols - 7, row: 0, corner: .topRight)
            // Bottom-Left Finder
            addFinderPattern(col: 0, row: numRows - 7, corner: .bottomLeft)
            
            // 2. Draw gradient through the complete dots path (using Even-Odd fill)
            cgContext.saveGState()
            cgContext.addPath(dotsPath.cgPath)
            cgContext.clip(using: .evenOdd)
            
            if let gradient = gradient {
                cgContext.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: paddingLeft, y: paddingTop),
                    end: CGPoint(x: canvasSize.width - paddingRight, y: canvasSize.height - paddingBottom),
                    options: []
                )
            } else {
                cgContext.setFillColor(UIColor.black.cgColor)
                cgContext.fill(CGRect(origin: .zero, size: canvasSize))
            }
            cgContext.restoreGState()
            
            // 3. Draw Center Logo if enabled
            if style.logoType != .none {
                drawCenterLogo(
                    style: style,
                    rect: centerRect,
                    in: cgContext,
                    canvasSize: canvasSize
                )
            }
        }
    }
    
    private func uiFont(for fontName: String, size: CGFloat) -> UIFont {
        let weight: UIFont.Weight = .bold
        switch fontName {
        case "Rounded":
            let baseFont = UIFont.systemFont(ofSize: size, weight: weight)
            if let descriptor = baseFont.fontDescriptor.withDesign(.rounded) {
                return UIFont(descriptor: descriptor, size: size)
            }
            return baseFont
        case "Serif":
            let baseFont = UIFont.systemFont(ofSize: size, weight: weight)
            if let descriptor = baseFont.fontDescriptor.withDesign(.serif) {
                return UIFont(descriptor: descriptor, size: size)
            }
            return baseFont
        case "Mono":
            let baseFont = UIFont.systemFont(ofSize: size, weight: weight)
            if let descriptor = baseFont.fontDescriptor.withDesign(.monospaced) {
                return UIFont(descriptor: descriptor, size: size)
            }
            return baseFont
        default:
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func drawCenterLogo(
        style: QRStyleConfig,
        rect: CGRect,
        in cgContext: CGContext,
        canvasSize: CGSize
    ) {
        // Background card behind logo
        let bgPadding: CGFloat = 6
        let logoBgRect = rect.insetBy(dx: -bgPadding, dy: -bgPadding)
        let cornerRadius: CGFloat = logoBgRect.width * 0.28
        
        let path = UIBezierPath(roundedRect: logoBgRect, cornerRadius: cornerRadius)
        UIColor.white.setFill()
        path.fill()
        
        // Soft shadow stroke
        UIColor(white: 0.9, alpha: 1.0).setStroke()
        path.lineWidth = 1.5
        path.stroke()
        
        // Inner logo container
        let innerRect = rect.insetBy(dx: 4, dy: 4)
        
        if let customData = style.customLogoData, let customImg = UIImage(data: customData) {
            let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: cornerRadius * 0.8)
            cgContext.saveGState()
            innerPath.addClip()
            customImg.draw(in: innerRect)
            cgContext.restoreGState()
            return
        }
        
        // Check if logo corresponds to an authentic brand logo
        if let brand = BrandType.match(from: style.logoType.rawValue) {
            BrandLogoRenderer.draw(brand: brand, in: innerRect, in: cgContext)
            return
        }
        
        // System badge icon fallback for non-brand icons (Wi-Fi, Link, Shield, etc.)
        if let iconName = style.logoType.systemIcon {
            let badgeBg = UIBezierPath(roundedRect: innerRect, cornerRadius: cornerRadius * 0.75)
            let badgeColor = UIColor(style.logoType.badgeBackgroundColor)
            badgeColor.setFill()
            badgeBg.fill()
            
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: innerRect.width * 0.5, weight: .bold)
            if let symbolImg = UIImage(systemName: iconName, withConfiguration: symbolConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal) {
                let iconSize = symbolImg.size
                let drawRect = CGRect(
                    x: innerRect.midX - iconSize.width / 2,
                    y: innerRect.midY - iconSize.height / 2,
                    width: iconSize.width,
                    height: iconSize.height
                )
                symbolImg.draw(in: drawRect)
            }
        }
    }
}
