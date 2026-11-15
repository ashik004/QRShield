import AVFoundation
import UIKit
import Combine
import CoreImage

public final class CameraScannerService: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published public var isTorchOn: Bool = false
    @Published public var isCameraAvailable: Bool = false
    @Published public var scannedCode: String? = nil
    @Published public var permissionDenied: Bool = false
    
    public let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice?
    private let sessionQueue = DispatchQueue(label: "com.qrshield.cameraQueue")
    
    public override init() {
        super.init()
        checkPermissions()
    }
    
    public func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera()
                    } else {
                        self?.permissionDenied = true
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                self.permissionDenied = true
            }
        }
    }
    
    public func setupCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                DispatchQueue.main.async {
                    self.isCameraAvailable = false
                }
                return
            }
            
            self.videoDevice = videoDevice
            
            self.captureSession.beginConfiguration()
            
            do {
                let videoInput = try AVCaptureDeviceInput(device: videoDevice)
                if self.captureSession.canAddInput(videoInput) {
                    self.captureSession.addInput(videoInput)
                }
                
                let metadataOutput = AVCaptureMetadataOutput()
                if self.captureSession.canAddOutput(metadataOutput) {
                    self.captureSession.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                }
                
                self.captureSession.commitConfiguration()
                
                DispatchQueue.main.async {
                    self.isCameraAvailable = true
                }
                
                self.startSession()
            } catch {
                self.captureSession.commitConfiguration()
                DispatchQueue.main.async {
                    self.isCameraAvailable = false
                }
            }
        }
    }
    
    public func startSession() {
        sessionQueue.async { [weak self] in
            guard let self = self, !self.captureSession.isRunning else { return }
            self.captureSession.startRunning()
        }
    }
    
    public func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self, self.captureSession.isRunning else { return }
            self.captureSession.stopRunning()
        }
    }
    
    public func toggleTorch() {
        guard let device = videoDevice, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if isTorchOn {
                device.torchMode = .off
                isTorchOn = false
            } else {
                try device.setTorchModeOn(level: 1.0)
                isTorchOn = true
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch error: \(error)")
        }
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringVal = metadataObj.stringValue else { return }
        
        // Haptic feedback
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        stopSession()
        DispatchQueue.main.async {
            self.scannedCode = stringVal
        }
    }
    
    /// Decodes a QR code from a picked UIImage
    public func decodeFromImage(_ image: UIImage) -> String? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: ciImage) ?? []
        for feature in features {
            if let qrFeature = feature as? CIQRCodeFeature, let message = qrFeature.messageString {
                return message
            }
        }
        return nil
    }
}
