import SwiftUI

public enum AppTab: Int, CaseIterable {
    case home = 0
    case generate = 1
    case scan = 2
    case history = 3
    case settings = 4
    
    public var title: String {
        switch self {
        case .home: return "Home"
        case .generate: return "Generate"
        case .scan: return "Scan"
        case .history: return "History"
        case .settings: return "Settings"
        }
    }
    
    public var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .generate: return "qrcode"
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
            
            // Generate
            tabButton(for: .generate)
            
            // Center Elevated Scan Button
            Button(action: {
                let feedback = UIImpactFeedbackGenerator(style: .medium)
                feedback.impactOccurred()
                onScanTapped()
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "7952FC"), Color(hex: "5A32E8")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: Color(hex: "6C5CE7").opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "viewfinder")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(y: -14)
            }
            .frame(maxWidth: .infinity)
            
            // History
            tabButton(for: .history)
            
            // Settings
            tabButton(for: .settings)
        }
        .padding(.horizontal, 8)
        .padding(.top, 6)
        .padding(.bottom, 2) // Extra space removed!
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
