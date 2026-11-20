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
        let cacheKey = "\(content)_\(style.dotStyle.rawValue)_\(style.eyeStyle.rawValue)_\(style.colorTheme.rawValue)_\(style.backgroundColorHex)_\(style.logoType.rawValue)_\(Int(size.width))x\(Int(size.height))" as NSString
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
                let img = UIImage(cgImage: cgImage)
                imageCache.setObject(img, forKey: cacheKey)
                return img
            }
            return nil
        }
        
        // Render custom styled image
        let rendered = renderStyledQR(matrix: matrix, style: style, canvasSize: size)
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
    
    /// Renders custom dot styles, gradients, and central logo onto a UIGraphicsImageRenderer canvas
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
            
            let padding: CGFloat = canvasSize.width * 0.06
            let qrDrawWidth = canvasSize.width - (padding * 2)
            let qrDrawHeight = canvasSize.height - (padding * 2)
            let moduleWidth = qrDrawWidth / CGFloat(numCols)
            let moduleHeight = qrDrawHeight / CGFloat(numRows)
            
            // Center clear zone if logo is present
            let centerRatio: CGFloat = style.logoType != .none ? 0.24 : 0.0
            let centerRect = CGRect(
                x: canvasSize.width * (0.5 - centerRatio / 2),
                y: canvasSize.height * (0.5 - centerRatio / 2),
                width: canvasSize.width * centerRatio,
                height: canvasSize.height * centerRatio
            )
            
            // Setup gradient colors
            let uiColors = style.colorTheme.hexColors.map { UIColor(Color(hex: $0)).cgColor }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: uiColors as CFArray, locations: nil)
            
            // Create path for all active QR modules
            let dotsPath = UIBezierPath()
            
            for y in 0..<numRows {
                for x in 0..<numCols {
                    guard matrix[y][x] else { continue }
                    
                    let rect = CGRect(
                        x: padding + CGFloat(x) * moduleWidth,
                        y: padding + CGFloat(y) * moduleHeight,
                        width: moduleWidth,
                        height: moduleHeight
                    )
                    
                    // Skip dots covered by center logo
                    if centerRatio > 0 && centerRect.intersects(rect) {
                        continue
                    }
                    
                    // Check if module belongs to one of the 3 corner finder patterns (7x7 eyes)
                    let isFinderPattern = (x < 7 && y < 7) ||
                                          (x >= numCols - 7 && y < 7) ||
                                          (x < 7 && y >= numRows - 7)
                    
                    if isFinderPattern {
                        // Finder eye style
                        switch style.eyeStyle {
                        case .rounded:
                            let eyeDot = UIBezierPath(roundedRect: rect.insetBy(dx: 0.2, dy: 0.2), cornerRadius: moduleWidth * 0.3)
                            dotsPath.append(eyeDot)
                        case .square:
                            let eyeDot = UIBezierPath(rect: rect.insetBy(dx: 0.2, dy: 0.2))
                            dotsPath.append(eyeDot)
                        case .circular:
                            let eyeDot = UIBezierPath(ovalIn: rect.insetBy(dx: 0.2, dy: 0.2))
                            dotsPath.append(eyeDot)
                        case .leaf:
                            let leafDot = UIBezierPath(roundedRect: rect.insetBy(dx: 0.2, dy: 0.2), byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: moduleWidth * 0.45, height: moduleWidth * 0.45))
                            dotsPath.append(leafDot)
                        }
                    } else {
                        switch style.dotStyle {
                        case .square:
                            let squareDot = UIBezierPath(rect: rect.insetBy(dx: 0.2, dy: 0.2))
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
            }
            
            // 2. Draw gradient through the dots path
            cgContext.saveGState()
            dotsPath.addClip()
            if let gradient = gradient {
                cgContext.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: padding, y: padding),
                    end: CGPoint(x: canvasSize.width - padding, y: canvasSize.height - padding),
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
        
        // System badge icon
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
