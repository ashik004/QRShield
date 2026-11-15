import SwiftUI

public struct TemplatesView: View {
    @State private var selectedCategory: QRTemplateCategory = .all
    @State private var searchText: String = ""
    public var onSelectTemplate: (QRTemplate) -> Void
    
    public init(onSelectTemplate: @escaping (QRTemplate) -> Void) {
        self.onSelectTemplate = onSelectTemplate
    }
    
    private var filteredTemplates: [QRTemplate] {
        let list: [QRTemplate]
        if selectedCategory == .all {
            list = QRTemplate.predefinedTemplates
        } else {
            list = QRTemplate.predefinedTemplates.filter { $0.category == selectedCategory }
        }
        
        if searchText.isEmpty {
            return list
        } else {
            return list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
                ($0.badgeText?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header: Clean centered title (No Back button per specification)
            HStack {
                Spacer()
                Text("Templates")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 8)
            
            // Search Bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "9CA3AF"))
                
                TextField("Search templates...", text: $searchText)
                    .font(.system(size: 14))
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(hex: "F3F4F6"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            // Filter Chips Bar: [ All | Social | Wi-Fi | Business | Event ]
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(QRTemplateCategory.allCases) { category in
                        categoryChip(category)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
            }
            
            // 2-Column Templates Grid
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    // Count badge
                    Text("\(filteredTemplates.count) Templates Available")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "6B7280"))
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 18) {
                        ForEach(filteredTemplates) { template in
                            TemplateCardView(template: template) {
                                onSelectTemplate(template)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120) // Generous bottom space to scroll fully
                }
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
            HStack(spacing: 5) {
                Text(category.rawValue)
                    .font(.system(size: 13, weight: selectedCategory == category ? .bold : .medium))
                
                // Show count in chip
                let count = category == .all ? QRTemplate.predefinedTemplates.count : QRTemplate.predefinedTemplates.filter { $0.category == category }.count
                Text("\(count)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(selectedCategory == category ? Color.shieldPurple : Color(hex: "9CA3AF"))
                    .padding(.horizontal, 5)
                    .padding(.vertical, 1)
                    .background(
                        Capsule().fill(selectedCategory == category ? Color.white : Color(hex: "E5E7EB"))
                    )
            }
            .foregroundColor(selectedCategory == category ? .white : Color(hex: "4B5563"))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(selectedCategory == category ? Color.shieldPurple : Color(hex: "F3F4F6"))
            )
        }
        .buttonStyle(.plain)
    }
}
