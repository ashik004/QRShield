import SwiftUI

public struct QuickAccessGrid: View {
    public var onSelectTemplates: () -> Void
    public var onSelectMyCodes: () -> Void
    public var onSelectHistory: () -> Void
    public var onSelectFavorites: () -> Void
    
    public init(
        onSelectTemplates: @escaping () -> Void,
        onSelectMyCodes: @escaping () -> Void,
        onSelectHistory: @escaping () -> Void,
        onSelectFavorites: @escaping () -> Void
    ) {
        self.onSelectTemplates = onSelectTemplates
        self.onSelectMyCodes = onSelectMyCodes
        self.onSelectHistory = onSelectHistory
        self.onSelectFavorites = onSelectFavorites
    }
    
    public var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
            // 1. Templates
            quickTile(
                iconName: "square.stack.3d.up.fill",
                title: "Templates",
                action: onSelectTemplates
            )
            
            // 2. My Codes
            quickTile(
                iconName: "square.grid.2x2.fill",
                title: "My Codes",
                action: onSelectMyCodes
            )
            
            // 3. Scan History
            quickTile(
                iconName: "clock.arrow.circlepath",
                title: "Scan History",
                action: onSelectHistory
            )
            
            // 4. Favorites
            quickTile(
                iconName: "heart.fill",
                title: "Favorites",
                action: onSelectFavorites
            )
        }
    }
    
    private func quickTile(iconName: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            action()
        }) {
            VStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color.shieldPurple)
                
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "1F2937"))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(hex: "F8F7FF"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color(hex: "ECE8FC"), lineWidth: 1.2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
