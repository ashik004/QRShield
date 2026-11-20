import SwiftUI

public struct CheckingLinkSafetyView: View {
    public let rawContent: String
    public var onBack: () -> Void
    public var onFinished: (SafetyAnalysisResult) -> Void
    
    @State private var completedStepIndex: Int = 0
    @State private var radarRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    public init(
        rawContent: String,
        onBack: @escaping () -> Void,
        onFinished: @escaping (SafetyAnalysisResult) -> Void
    ) {
        self.rawContent = rawContent
        self.onBack = onBack
        self.onFinished = onFinished
    }
    
    public var body: some View {
        ZStack {
            // Deepest Midnight Navy Background
            Color(hex: "06141B").ignoresSafeArea()
            
            VStack {
                // Top Header
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "CCD0CF"))
                            .frame(width: 40, height: 40)
                            .background(Color(hex: "253745"))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Animated Concentric Radar & Shield
                ZStack {
                    // Outer Ring 3
                    Circle()
                        .stroke(Color(hex: "253745"), lineWidth: 1.5)
                        .frame(width: 240, height: 240)
                    
                    // Ring 2
                    Circle()
                        .stroke(Color(hex: "253745"), lineWidth: 1.5)
                        .frame(width: 180, height: 180)
                    
                    // Ring 1
                    Circle()
                        .stroke(Color(hex: "4A5C6A"), lineWidth: 1.5)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                    
                    // Rotating Radar Sweep Beam
                    Circle()
                        .fill(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color(hex: "4A5C6A").opacity(0.0),
                                    Color(hex: "4A5C6A").opacity(0.35)
                                ]),
                                center: .center
                            )
                        )
                        .frame(width: 240, height: 240)
                        .rotationEffect(.degrees(radarRotation))
                    
                    // Central Glowing Shield
                    ZStack {
                        Circle()
                            .fill(Color(hex: "4A5C6A"))
                            .frame(width: 68, height: 68)
                            .shadow(color: Color(hex: "4A5C6A").opacity(0.6), radius: 18, x: 0, y: 0)
                        
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: "CCD0CF"))
                    }
                }
                .frame(height: 260)
                
                // Title
                Text("Checking link safety...")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .padding(.top, 24)
                
                // Progress Checklist
                VStack(alignment: .leading, spacing: 14) {
                    checklistRow(step: 0, text: "Reading QR code...")
                    checklistRow(step: 1, text: "Extracting link...")
                    checklistRow(step: 2, text: "Analyzing for threats...")
                    checklistRow(step: 3, text: "Checking against safety database...")
                }
                .padding(.top, 28)
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startAnimationAndAnalysis()
        }
    }
    
    private func checklistRow(step: Int, text: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                if completedStepIndex > step {
                    // Completed checkmark
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "10B981"))
                } else if completedStepIndex == step {
                    // In-progress spinner
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "4A5C6A")))
                        .scaleEffect(0.85)
                } else {
                    // Pending hollow circle
                    Circle()
                        .stroke(Color(hex: "253745"), lineWidth: 1.5)
                        .frame(width: 16, height: 16)
                }
            }
            .frame(width: 20, height: 20)
            
            Text(text)
                .font(.system(size: 14, weight: completedStepIndex >= step ? .medium : .regular))
                .foregroundColor(completedStepIndex >= step ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
            
            Spacer()
        }
    }
    
    private func startAnimationAndAnalysis() {
        // Continuous radar rotation
        withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
            radarRotation = 360
        }
        // Pulse animation
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            pulseScale = 1.08
        }
        
        // Step progression
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completedStepIndex = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            completedStepIndex = 2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            completedStepIndex = 3
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            completedStepIndex = 4
            
            // Finish analysis
            let result = SafetyCheckerService.shared.analyze(rawContent: rawContent)
            QRStorageService.shared.recordScan(result: result)
            
            let feedback = UINotificationFeedbackGenerator()
            switch result.status {
            case .safe: feedback.notificationOccurred(.success)
            case .suspicious: feedback.notificationOccurred(.warning)
            case .dangerous: feedback.notificationOccurred(.error)
            }
            
            onFinished(result)
        }
    }
}
