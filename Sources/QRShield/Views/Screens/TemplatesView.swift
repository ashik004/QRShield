import SwiftUI

public struct TemplatesView: View {
    @State private var selectedCategory: QRTemplateCategory = .all
    public var onBack: () -> Void
    public var onSelectTemplate: (QRTemplate) -> Void
    
    public init(onBack: @escaping () -> Void, onSelectTemplate: @escaping (QRTemplate) -> Void) {
        self.onBack = onBack
        self.onSelectTemplate = onSelectTemplate
    }
    
    private var filteredTemplates: [QRTemplate] {
        if selectedCategory == .all {
            return QRTemplate.predefinedTemplates
        }
        return QRTemplate.predefinedTemplates.filter { $0.category == selectedCategory }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "1F2937"))
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Templates")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Color.clear.frame(width: 38, height: 38)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Filter Chips Bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(QRTemplateCategory.allCases) { category in
                        categoryChip(category)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
            
            // 2-Column Templates Grid
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                    ForEach(filteredTemplates) { template in
                        TemplateCardView(template: template) {
                            onSelectTemplate(template)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    private func categoryChip(_ category: QRTemplateCategory) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedCategory = category
            }
        }) {
            Text(category.rawValue)
                .font(.system(size: 13, weight: selectedCategory == category ? .bold : .medium))
                .foregroundColor(selectedCategory == category ? .white : Color(hex: "4B5563"))
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(selectedCategory == category ? Color.shieldPurple : Color(hex: "F3F4F6"))
                )
        }
        .buttonStyle(.plain)
    }
}
