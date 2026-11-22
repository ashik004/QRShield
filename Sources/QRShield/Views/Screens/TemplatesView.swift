import SwiftUI

public struct TemplatesView: View {
    public var showHeader: Bool
    public var showSearchBar: Bool
    public var onSelectTemplate: (QRTemplate) -> Void
    
    @State private var selectedCategory: QRTemplateCategory = .all
    @State private var selectedSubCategory: String? = nil
    @State private var searchText: String = ""
    
    public init(
        showHeader: Bool = true,
        showSearchBar: Bool = false,
        onSelectTemplate: @escaping (QRTemplate) -> Void
    ) {
        self.showHeader = showHeader
        self.showSearchBar = showSearchBar
        self.onSelectTemplate = onSelectTemplate
    }
    
    private var availableSubCategories: [String] {
        let baseList: [QRTemplate]
        if selectedCategory == .all {
            baseList = QRTemplate.predefinedTemplates
        } else if selectedCategory == .popular {
            baseList = QRTemplate.popularTemplates
        } else {
            baseList = QRTemplate.predefinedTemplates.filter { $0.category == selectedCategory }
        }
        let list = baseList.compactMap { $0.subCategory }
        // Preserve a clean order:
        var unique: [String] = []
        for item in list where !unique.contains(item) {
            unique.append(item)
        }
        return unique
    }
    
    private var filteredTemplates: [QRTemplate] {
        var list: [QRTemplate]
        if selectedCategory == .all {
            list = QRTemplate.predefinedTemplates
        } else if selectedCategory == .popular {
            list = QRTemplate.popularTemplates
        } else {
            list = QRTemplate.predefinedTemplates.filter { $0.category == selectedCategory }
        }
        
        if let sub = selectedSubCategory {
            list = list.filter { $0.subCategory == sub }
        }
        
        if searchText.isEmpty {
            return list
        } else {
            return list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
                ($0.subCategory?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                ($0.badgeText?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Optional Header (Hidden when inside Generate screen)
            if showHeader {
                HStack {
                    Spacer()
                    Text("Templates")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 8)
            }
            
            // Optional Search Bar
            if showSearchBar {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "9BA8AB"))
                    
                    TextField("Search templates...", text: $searchText)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "CCD0CF"))
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "9BA8AB"))
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color(hex: "11212D"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "253745"), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
            
            // Filter Chips Bar: [ All | Popular | Business | Colorful | Social | Wi-Fi | Event ]
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(QRTemplateCategory.allCases) { category in
                        categoryChip(category)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
            }
            
            // Sub-category Horizontal Filter Bar (e.g., Menu, Store, Blockchain, Coupon, Pay)
            if availableSubCategories.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button(action: {
                            let feedback = UIImpactFeedbackGenerator(style: .light)
                            feedback.impactOccurred()
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                selectedSubCategory = nil
                            }
                        }) {
                            Text("All")
                                .font(.system(size: 12, weight: selectedSubCategory == nil ? .bold : .medium))
                                .foregroundColor(selectedSubCategory == nil ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule().fill(selectedSubCategory == nil ? Color(hex: "4A5C6A") : Color(hex: "11212D"))
                                )
                                .overlay(
                                    Capsule().stroke(Color(hex: "253745"), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                        
                        ForEach(availableSubCategories, id: \.self) { subCat in
                            let isSelected = selectedSubCategory == subCat
                            Button(action: {
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                    selectedSubCategory = isSelected ? nil : subCat
                                }
                            }) {
                                Text(subCat)
                                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(
                                        Capsule().fill(isSelected ? Color(hex: "4A5C6A") : Color(hex: "11212D"))
                                    )
                                    .overlay(
                                        Capsule().stroke(isSelected ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
            }
            
            // 2-Column Templates Grid with full, unrestricted vertical scrolling
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 18) {
                    ForEach(filteredTemplates) { template in
                        TemplateCardView(template: template) {
                            onSelectTemplate(template)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 130) // Full bottom clearance above tab bar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "06141B").ignoresSafeArea())
    }
    
    private func categoryChip(_ category: QRTemplateCategory) -> some View {
        let isSelected = selectedCategory == category
        return Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedCategory = category
                selectedSubCategory = nil
            }
        }) {
            HStack(spacing: 5) {
                Image(systemName: category.sfSymbol)
                    .font(.system(size: 11, weight: .semibold))
                
                Text(category.rawValue)
                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                
                let count: Int = {
                    if category == .all {
                        return QRTemplate.predefinedTemplates.count
                    } else if category == .popular {
                        return QRTemplate.popularTemplates.count
                    } else {
                        return QRTemplate.predefinedTemplates.filter { $0.category == category }.count
                    }
                }()
                Text("\(count)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                    .padding(.horizontal, 5)
                    .padding(.vertical, 1)
                    .background(
                        Capsule().fill(Color(hex: "11212D"))
                    )
            }
            .foregroundColor(isSelected ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: "4A5C6A") : Color(hex: "253745"))
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color(hex: "4A5C6A") : Color(hex: "253745"), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
