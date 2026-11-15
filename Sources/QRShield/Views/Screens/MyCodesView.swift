import SwiftUI

public struct MyCodesView: View {
    @ObservedObject private var storage = QRStorageService.shared
    @State private var searchText: String = ""
    @State private var selectedFilter: QRTemplateCategory = .all
    @State private var onlyFavorites: Bool = false
    @State private var selectedItemForDetail: QRCodeItem? = nil
    @State private var selectedItemForEdit: QRCodeItem? = nil
    
    public var onBack: () -> Void
    public var onEditItem: (QRCodeItem) -> Void
    
    public init(
        initialOnlyFavorites: Bool = false,
        onBack: @escaping () -> Void,
        onEditItem: @escaping (QRCodeItem) -> Void
    ) {
        self._onlyFavorites = State(initialValue: initialOnlyFavorites)
        self.onBack = onBack
        self.onEditItem = onEditItem
    }
    
    private var filteredCodes: [QRCodeItem] {
        storage.savedCodes.filter { item in
            let matchesSearch = searchText.isEmpty ||
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.contentPreview.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = selectedFilter == .all || item.category == selectedFilter
            let matchesFavorite = !onlyFavorites || item.isFavorite
            
            return matchesSearch && matchesCategory && matchesFavorite
        }
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
                
                Text(onlyFavorites ? "Favorites" : "My Codes")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                // Toggle favorites only
                Button(action: {
                    withAnimation {
                        onlyFavorites.toggle()
                    }
                }) {
                    Image(systemName: onlyFavorites ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(onlyFavorites ? .red : Color(hex: "6B7280"))
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Search Bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .font(.system(size: 16))
                
                TextField("Search your QR codes", text: $searchText)
                    .font(.system(size: 14))
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(hex: "F3F4F6"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 20)
            .padding(.top, 4)
            
            // Filter Chips Bar [ All | Social | Wi-Fi | Business ]
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    filterChip(title: "All", category: .all)
                    filterChip(title: "Social", category: .social)
                    filterChip(title: "Wi-Fi", category: .wifi)
                    filterChip(title: "Business", category: .business)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            
            // List of Saved Codes
            if filteredCodes.isEmpty {
                VStack(spacing: 14) {
                    Spacer()
                    Image(systemName: "qrcode")
                        .font(.system(size: 54))
                        .foregroundColor(Color(hex: "D1D5DB"))
                    Text("No QR codes found")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "6B7280"))
                    Spacer()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredCodes) { item in
                            codeRow(item)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        .sheet(item: $selectedItemForDetail) { item in
            CodeDetailModalView(item: item)
        }
    }
    
    private func filterChip(title: String, category: QRTemplateCategory) -> some View {
        Button(action: {
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            withAnimation {
                selectedFilter = category
            }
        }) {
            Text(title)
                .font(.system(size: 13, weight: selectedFilter == category ? .bold : .medium))
                .foregroundColor(selectedFilter == category ? .white : Color(hex: "4B5563"))
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(selectedFilter == category ? Color.shieldPurple : Color(hex: "F3F4F6"))
                )
        }
        .buttonStyle(.plain)
    }
    
    private func codeRow(_ item: QRCodeItem) -> some View {
        HStack(spacing: 14) {
            // Thumbnail Preview
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: item.styleConfig.backgroundColorHex))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                    )
                
                // Small QR mini preview
                miniThumbnail(for: item)
            }
            .frame(width: 50, height: 50)
            
            // Title & Preview Text & Date
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                    .lineLimit(1)
                
                Text(item.contentPreview)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "6B7280"))
                    .lineLimit(1)
                
                Text(item.relativeTimeString)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
            
            Spacer()
            
            // Star Favorite Button
            Button(action: {
                let feedback = UIImpactFeedbackGenerator(style: .light)
                feedback.impactOccurred()
                storage.toggleFavorite(for: item.id)
            }) {
                Image(systemName: item.isFavorite ? "star.fill" : "star")
                    .font(.system(size: 17))
                    .foregroundColor(item.isFavorite ? Color.shieldGold : Color(hex: "D1D5DB"))
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            
            // Three Dots `...` Menu
            Menu {
                Button(action: { selectedItemForDetail = item }) {
                    Label("View Fullscreen", systemImage: "arrow.up.left.and.arrow.down.right")
                }
                Button(action: { onEditItem(item) }) {
                    Label("Customize", systemImage: "slider.horizontal.3")
                }
                Button(action: {
                    UIPasteboard.general.string = item.rawContent
                }) {
                    Label("Copy Content", systemImage: "doc.on.doc")
                }
                Button(role: .destructive, action: {
                    storage.delete(id: item.id)
                }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .frame(width: 32, height: 32)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(hex: "F3F4F6"), lineWidth: 1.2)
                )
        )
        .contentShape(Rectangle())
        .onTapGesture {
            selectedItemForDetail = item
        }
    }
    
    private func miniThumbnail(for item: QRCodeItem) -> some View {
        Group {
            if let logoIcon = item.styleConfig.logoType.systemIcon {
                Image(systemName: logoIcon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: item.styleConfig.colorTheme.hexColors.first ?? "6C5CE7"))
            } else {
                Image(systemName: "qrcode")
                    .font(.system(size: 26))
                    .foregroundColor(Color(hex: item.styleConfig.colorTheme.hexColors.first ?? "6C5CE7"))
            }
        }
    }
}

/// Detail Sheet for viewing a QR Code in full presentation mode
public struct CodeDetailModalView: View {
    @Environment(\.dismiss) private var dismiss
    public let item: QRCodeItem
    
    public init(item: QRCodeItem) {
        self.item = item
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                QRDisplayView(
                    content: item.rawContent,
                    styleConfig: item.styleConfig,
                    size: 260
                )
                
                VStack(spacing: 6) {
                    Text(item.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "1F2937"))
                    
                    Text(item.contentPreview)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "6B7280"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // Copy & Share buttons
                HStack(spacing: 14) {
                    Button(action: {
                        UIPasteboard.general.string = item.rawContent
                        let feedback = UINotificationFeedbackGenerator()
                        feedback.notificationOccurred(.success)
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy Link")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color.shieldPurple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "F3F0FF"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    Button(action: {
                        if let img = QRCodeGeneratorService.shared.generateQRCode(from: item.rawContent, style: item.styleConfig) {
                            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                            let feedback = UINotificationFeedbackGenerator()
                            feedback.notificationOccurred(.success)
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.to.line")
                            Text("Save Photo")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.shieldPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            .navigationTitle("QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
