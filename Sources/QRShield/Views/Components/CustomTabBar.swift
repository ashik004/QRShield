import SwiftUI

public struct AnimatedScannerButton: View {
    public var action: () -> Void
    
    @State private var waveScale1: CGFloat = 1.0
    @State private var waveOpacity1: Double = 0.65
    @State private var waveScale2: CGFloat = 1.0
    @State private var waveOpacity2: Double = 0.5
    @State private var rotationAngle: Double = 0
    @State private var laserOffset: CGFloat = -11
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
            action()
        }) {
            ZStack {
                // Wave 1: Outer glowing pulsing radar ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "7952FC"), Color(hex: "00F2FE")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 58, height: 58)
                    .scaleEffect(waveScale1)
                    .opacity(waveOpacity1)
                
                // Wave 2: Staggered second radar pulse
                Circle()
                    .stroke(Color(hex: "A78BFA"), lineWidth: 1.5)
                    .frame(width: 58, height: 58)
                    .scaleEffect(waveScale2)
                    .opacity(waveOpacity2)
                
                // Rotating Cyber Halo Border Ring
                Circle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "7952FC"),
                                Color(hex: "38BDF8"),
                                Color(hex: "F43F5E"),
                                Color(hex: "7952FC")
                            ]),
                            center: .center
                        ),
                        lineWidth: 2.5
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotationAngle))
                
                // Core Button Orb
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: Color(hex: "6C5CE7").opacity(0.55), radius: 10, x: 0, y: 5)
                
                // Viewfinder Icon + Animated Laser Beam inside
                ZStack {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Moving neon laser beam
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color(hex: "00F2FE"), Color.white, Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 20, height: 2)
                        .shadow(color: Color(hex: "00F2FE"), radius: 3)
                        .offset(y: laserOffset)
                        .mask(
                            Image(systemName: "viewfinder")
                                .font(.system(size: 26, weight: .bold))
                        )
                }
            }
            .offset(y: -14)
        }
        .buttonStyle(.plain)
        .onAppear {
            startInfiniteAnimations()
        }
    }
    
    private func startInfiniteAnimations() {
        // 1. Radar Wave 1 expansion
        withAnimation(.easeOut(duration: 1.8).repeatForever(autoreverses: false)) {
            waveScale1 = 1.48
            waveOpacity1 = 0.0
        }
        
        // 2. Radar Wave 2 delayed expansion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 1.8).repeatForever(autoreverses: false)) {
                waveScale2 = 1.45
                waveOpacity2 = 0.0
            }
        }
        
        // 3. Continuous 360° Halo Rotation
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // 4. Bouncing Laser Sweep Beam
        withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
            laserOffset = 11
        }
    }
}

public enum AppTab: Int, CaseIterable {
    case home = 0
    case template = 1
    case scan = 2
    case history = 3
    case settings = 4
    
    public var title: String {
        switch self {
        case .home: return "Home"
        case .template: return "Template"
        case .scan: return "Scan"
        case .history: return "History"
        case .settings: return "Settings"
        }
    }
    
    public var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .template: return "square.grid.2x2"
        case .scan: return "viewfinder"
        case .history: return "clock.arrow.circlepath"
        case .settings: return "gearshape.fill"
        }
    }
}

public struct CustomTabBar: View {
    @Binding public var selectedTab: AppTab
    public var onScanTapped: () -> Void
    
    public init(selectedTab: Binding<AppTab>, onScanTapped: @escaping () -> Void) {
        self._selectedTab = selectedTab
        self.onScanTapped = onScanTapped
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            // Home
            tabButton(for: .home)
            
            // Template (Replaced Generate)
            tabButton(for: .template)
            
            // Center Elevated Animated Scan Button
            AnimatedScannerButton(action: onScanTapped)
                .frame(maxWidth: .infinity)
            
            // History
            tabButton(for: .history)
            
            // Settings
            tabButton(for: .settings)
        }
        .padding(.horizontal, 8)
        .padding(.top, 6)
        .padding(.bottom, 2)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private func tabButton(for tab: AppTab) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            selectedTab = tab
        }) {
            VStack(spacing: 3) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20, weight: selectedTab == tab ? .semibold : .regular))
                    .foregroundColor(selectedTab == tab ? Color.shieldPurple : Color(hex: "9CA3AF"))
                    .frame(height: 24)
                
                Text(tab.title)
                    .font(.system(size: 11, weight: selectedTab == tab ? .bold : .medium))
                    .foregroundColor(selectedTab == tab ? Color.shieldPurple : Color(hex: "9CA3AF"))
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
