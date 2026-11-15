import SwiftUI
import PhotosUI
import AVFoundation

public struct ScanQRCodeView: View {
    @StateObject private var cameraService = CameraScannerService()
    @State private var scanLineOffset: CGFloat = -110
    @State private var showTipsSheet: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showSimulatorPicker: Bool = false
    @State private var viewAppeared: Bool = false
    
    public var onBack: () -> Void
    public var onCodeDetected: (String) -> Void
    
    public init(onBack: @escaping () -> Void, onCodeDetected: @escaping (String) -> Void) {
        self.onBack = onBack
        self.onCodeDetected = onCodeDetected
    }
    
    public var body: some View {
        ZStack {
            // Dark Base Background
            Color.black.ignoresSafeArea()
            
            // Camera feed or mock camera background
            if cameraService.isCameraAvailable {
                CameraPreviewView(session: cameraService.captureSession)
                    .ignoresSafeArea()
                    .opacity(viewAppeared ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.25), value: viewAppeared)
            } else {
                // Mock ambient dark camera texture for simulator or when camera is restricted
                LinearGradient(
                    colors: [Color(hex: "1F2937"), Color(hex: "111827")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
            
            // Viewfinder Overlay & Cutout
            VStack {
                // Header Bar
                HStack {
                    Button(action: {
                        cameraService.stopSession()
                        onBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.45))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Scan QR Code")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Simulator Trigger Button
                    Button(action: {
                        showSimulatorPicker = true
                    }) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.45))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Central Viewfinder Target Area
                ZStack {
                    // Targeting Frame with rounded corners and glowing brackets
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 250, height: 250)
                    
                    // 4 Corner Brackets
                    cornerBrackets
                    
                    // Animated Laser Scanning Line
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color.shieldPurple, Color(hex: "A78BFA"), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 230, height: 3)
                        .shadow(color: Color.shieldPurple, radius: 6, x: 0, y: 0)
                        .offset(y: scanLineOffset)
                }
                
                // Floating instruction badge
                Text("Align the QR code within the frame")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.6))
                    )
                    .padding(.top, 24)
                
                Spacer()
                
                // Bottom Controls: Gallery, Flashlight, Scan Tips
                HStack(spacing: 40) {
                    // Gallery
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        bottomControlButton(icon: "photo.on.rectangle", label: "Gallery")
                    }
                    .onChange(of: selectedPhotoItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data),
                               let detected = cameraService.decodeFromImage(uiImage) {
                                onCodeDetected(detected)
                            }
                        }
                    }
                    
                    // Flashlight
                    Button(action: {
                        cameraService.toggleTorch()
                    }) {
                        bottomControlButton(
                            icon: cameraService.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill",
                            label: "Flashlight",
                            isActive: cameraService.isTorchOn
                        )
                    }
                    
                    // Scan Tips
                    Button(action: {
                        showTipsSheet = true
                    }) {
                        bottomControlButton(icon: "info.circle", label: "Scan Tips")
                    }
                }
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            cameraService.startSession()
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                scanLineOffset = 110
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewAppeared = true
            }
        }
        .onDisappear {
            cameraService.stopSession()
        }
        .onChange(of: cameraService.scannedCode) { newCode in
            if let code = newCode {
                onCodeDetected(code)
            }
        }
        .confirmationDialog("Simulate QR Scan", isPresented: $showSimulatorPicker, titleVisibility: .visible) {
            Button("Safe: Instagram (https://www.instagram.com)") {
                onCodeDetected("https://www.instagram.com")
            }
            Button("Suspicious: Promo Gift (http://promo-free-gift.com)") {
                onCodeDetected("http://promo-free-gift.com")
            }
            Button("Dangerous: Phishing Win (http://free-iphone-win.ru)") {
                onCodeDetected("http://free-iphone-win.ru")
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Select a simulated QR scan to test safety analysis:")
        }
        .sheet(isPresented: $showTipsSheet) {
            ScanTipsSheetView()
        }
    }
    
    private var cornerBrackets: some View {
        ZStack {
            // Top Left
            bracketShape
                .position(x: 20, y: 20)
            // Top Right
            bracketShape
                .rotationEffect(.degrees(90))
                .position(x: 230, y: 20)
            // Bottom Right
            bracketShape
                .rotationEffect(.degrees(180))
                .position(x: 230, y: 230)
            // Bottom Left
            bracketShape
                .rotationEffect(.degrees(270))
                .position(x: 20, y: 230)
        }
        .frame(width: 250, height: 250)
    }
    
    private var bracketShape: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 28))
            path.addLine(to: CGPoint(x: 0, y: 10))
            path.addQuadCurve(to: CGPoint(x: 10, y: 0), control: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 28, y: 0))
        }
        .stroke(Color.white, style: StrokeStyle(lineWidth: 4.5, lineCap: .round))
        .frame(width: 28, height: 28)
    }
    
    private func bottomControlButton(icon: String, label: String, isActive: Bool = false) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.shieldPurple : Color.black.opacity(0.55))
                    .frame(width: 52, height: 52)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isActive ? .white : .white.opacity(0.9))
            }
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

/// Custom Hardware-Accelerated Camera Preview Layer without asynchronous jumping
public final class CameraPreviewContainerView: UIView {
    public override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

public struct CameraPreviewView: UIViewRepresentable {
    public let session: AVCaptureSession
    
    public init(session: AVCaptureSession) {
        self.session = session
    }
    
    public func makeUIView(context: Context) -> CameraPreviewContainerView {
        let view = CameraPreviewContainerView()
        view.backgroundColor = .black
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    public func updateUIView(_ uiView: CameraPreviewContainerView, context: Context) {
        if uiView.videoPreviewLayer.session !== session {
            uiView.videoPreviewLayer.session = session
        }
    }
}

/// Scan Tips Sheet
public struct ScanTipsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                tipRow(icon: "lightbulb.fill", title: "Good Lighting", description: "Ensure the QR code is clearly lit and not shaded.")
                tipRow(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "Optimal Distance", description: "Keep your camera around 6 to 12 inches away from the QR code.")
                tipRow(icon: "hand.raised.fill", title: "Hold Steady", description: "Hold your device steadily so the scanner can focus accurately.")
                tipRow(icon: "shield.lefthalf.filled", title: "Safety Inspection", description: "Every scanned link is automatically verified by QR Shield before opening.")
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Scanning Tips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func tipRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.shieldPurple)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                Text(description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(hex: "6B7280"))
            }
        }
    }
}
