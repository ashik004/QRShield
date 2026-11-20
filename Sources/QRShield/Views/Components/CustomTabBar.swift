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
                // Wave 1: Outer glowing pulsing radar ring in #4A5C6A
                Circle()
                    .stroke(Color(hex: "4A5C6A"), lineWidth: 2)
                    .frame(width: 58, height: 58)
                    .scaleEffect(waveScale1)
                    .opacity(waveOpacity1)
                
                // Wave 2: Staggered second radar pulse
                Circle()
                    .stroke(Color(hex: "4A5C6A").opacity(0.7), lineWidth: 1.5)
                    .frame(width: 58, height: 58)
                    .scaleEffect(waveScale2)
                    .opacity(waveOpacity2)
                
                // Outer ring (#253745)
                Circle()
                    .stroke(Color(hex: "253745"), lineWidth: 2.5)
                    .frame(width: 60, height: 60)
                
                // Core Floating Button Orb (#4A5C6A)
                Circle()
                    .fill(Color(hex: "4A5C6A"))
                    .frame(width: 56, height: 56)
                    .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                
                // Viewfinder Icon (#CCD0CF) + Animated Laser Beam inside
                ZStack {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    // Moving laser beam in #CCD0CF
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color(hex: "CCD0CF"), Color.white, Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 20, height: 2)
                        .shadow(color: Color(hex: "CCD0CF"), radius: 2)
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
            
            // Template
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
            Color(hex: "11212D")
                .overlay(
                    Rectangle()
                        .fill(Color(hex: "253745"))
                        .frame(height: 1),
                    alignment: .top
                )
                .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: -4)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private func tabButton(for tab: AppTab) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 3) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20, weight: selectedTab == tab ? .semibold : .regular))
                    .foregroundColor(selectedTab == tab ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                    .frame(height: 24)
                    .scaleEffect(selectedTab == tab ? 1.08 : 1.0)
                    .animation(.spring(response: 0.28, dampingFraction: 0.75), value: selectedTab)
                
                Text(tab.title)
                    .font(.system(size: 11, weight: selectedTab == tab ? .bold : .medium))
                    .foregroundColor(selectedTab == tab ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
