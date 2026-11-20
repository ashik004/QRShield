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
                        .foregroundColor(Color(hex: "CCD0CF"))
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "253745"))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(onlyFavorites ? "Favorites" : "My Codes")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                
                Spacer()
                
                // Toggle favorites only
                Button(action: {
                    withAnimation {
                        onlyFavorites.toggle()
                    }
                }) {
                    Image(systemName: onlyFavorites ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(onlyFavorites ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                        .frame(width: 38, height: 38)
                        .background(onlyFavorites ? Color(hex: "4A5C6A") : Color(hex: "253745"))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Search Bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(hex: "9BA8AB"))
                    .font(.system(size: 16))
                
                TextField("Search your QR codes", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "CCD0CF"))
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(hex: "9BA8AB"))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(hex: "11212D"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "253745"), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 4)
            
            // Filter Chips Bar: Supports all categories
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(QRTemplateCategory.allCases) { cat in
                        filterChip(title: cat.rawValue, category: cat)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            
            // List of Saved Codes
            if filteredCodes.isEmpty {
                VStack(spacing: 14) {
                    Spacer()
                    Image(systemName: "qrcode")
                        .font(.system(size: 54))
                        .foregroundColor(Color(hex: "253745"))
                    Text("No QR codes found")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "9BA8AB"))
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
        .background(Color(hex: "06141B").ignoresSafeArea())
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
                .foregroundColor(selectedFilter == category ? Color(hex: "CCD0CF") : Color(hex: "9BA8AB"))
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(selectedFilter == category ? Color(hex: "4A5C6A") : Color(hex: "253745"))
                )
        }
        .buttonStyle(.plain)
    }
    
    private func codeRow(_ item: QRCodeItem) -> some View {
        HStack(spacing: 14) {
            // Thumbnail Preview - Pure White Card for QR visibility
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color(hex: "253745"), lineWidth: 1)
                    )
                
                // Small QR mini preview
                miniThumbnail(for: item)
            }
            .frame(width: 50, height: 50)
            
            // Title & Preview Text & Date
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "CCD0CF"))
                    .lineLimit(1)
                
                Text(item.contentPreview)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "9BA8AB"))
                    .lineLimit(1)
                
                Text(item.relativeTimeString)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "9BA8AB"))
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
                    .foregroundColor(item.isFavorite ? Color(hex: "4A5C6A") : Color(hex: "253745"))
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
                    .foregroundColor(Color(hex: "9BA8AB"))
                    .frame(width: 32, height: 32)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: "11212D"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(hex: "253745"), lineWidth: 1.2)
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
                    .foregroundColor(Color(hex: item.styleConfig.colorTheme.hexColors.first ?? "4A5C6A"))
            } else {
                Image(systemName: "qrcode")
                    .font(.system(size: 26))
                    .foregroundColor(Color(hex: item.styleConfig.colorTheme.hexColors.first ?? "4A5C6A"))
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
            ZStack {
                Color(hex: "06141B").ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Pure white QR container card
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color(hex: "253745"), lineWidth: 1)
                            )
                        
                        QRDisplayView(
                            content: item.rawContent,
                            styleConfig: item.styleConfig,
                            size: 230
                        )
                        .padding(14)
                    }
                    .frame(width: 260, height: 260)
                    
                    VStack(spacing: 6) {
                        Text(item.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(hex: "CCD0CF"))
                        
                        Text(item.contentPreview)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "9BA8AB"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    
                    Spacer()
                    
                    // Copy & Save Photo buttons
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
                            .foregroundColor(Color(hex: "CCD0CF"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(hex: "253745"))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        
                        Button(action: {
                            let exportImg = QRCodeGeneratorService.shared.generateQRCode(
                                from: item.rawContent,
                                style: item.styleConfig,
                                size: CGSize(width: 1024, height: 1024)
                            )
                            
                            if let img = exportImg {
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
                            .foregroundColor(Color(hex: "CCD0CF"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(hex: "4A5C6A"))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Color(hex: "CCD0CF"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
