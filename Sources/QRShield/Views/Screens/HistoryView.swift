import SwiftUI

public struct HistoryView: View {
    @ObservedObject private var storage = QRStorageService.shared
    @State private var selectedStatusFilter: SafetyStatusFilter = .all
    @State private var selectedResultForDetail: SafetyAnalysisResult? = nil
    @State private var showClearConfirm: Bool = false
    
    public var onBack: () -> Void
    
    public enum SafetyStatusFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case safe = "Safe"
        case suspicious = "Suspicious"
        case dangerous = "Dangerous"
        
        public var id: String { rawValue }
    }
    
    public init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }
    
    private var filteredHistory: [SafetyAnalysisResult] {
        storage.scanHistory.filter { item in
            switch selectedStatusFilter {
            case .all: return true
            case .safe: return item.status == .safe
            case .suspicious: return item.status == .suspicious
            case .dangerous: return item.status == .dangerous
            }
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
                
                Text("Scan History")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Button(action: { showClearConfirm = true }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(storage.scanHistory.isEmpty ? Color(hex: "D1D5DB") : Color(hex: "EF4444"))
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(Circle())
                }
                .disabled(storage.scanHistory.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Status Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(SafetyStatusFilter.allCases) { filter in
                        Button(action: {
                            withAnimation {
                                selectedStatusFilter = filter
                            }
                        }) {
                            Text(filter.rawValue)
                                .font(.system(size: 13, weight: selectedStatusFilter == filter ? .bold : .medium))
                                .foregroundColor(selectedStatusFilter == filter ? .white : Color(hex: "4B5563"))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(selectedStatusFilter == filter ? Color.shieldPurple : Color(hex: "F3F4F6"))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            
            // History List
            if filteredHistory.isEmpty {
                VStack(spacing: 14) {
                    Spacer()
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 54))
                        .foregroundColor(Color(hex: "D1D5DB"))
                    Text("No scan history yet")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "6B7280"))
                    Spacer()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredHistory) { item in
                            historyRow(item)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        .confirmationDialog("Clear Scan History?", isPresented: $showClearConfirm, titleVisibility: .visible) {
            Button("Clear All History", role: .destructive) {
                storage.clearScanHistory()
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(item: $selectedResultForDetail) { result in
            ScanResultView(
                result: result,
                onBack: { selectedResultForDetail = nil },
                onDone: { selectedResultForDetail = nil }
            )
        }
    }
    
    private func historyRow(_ item: SafetyAnalysisResult) -> some View {
        Button(action: {
            selectedResultForDetail = item
        }) {
            HStack(spacing: 14) {
                // Status icon badge
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(item.status.primaryColor.opacity(0.12))
                        .frame(width: 46, height: 46)
                    
                    Image(systemName: item.status.iconName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(item.status.primaryColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.urlString)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "1F2937"))
                        .lineLimit(1)
                    
                    HStack(spacing: 6) {
                        Text(item.status.title)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(item.status.primaryColor)
                        
                        Text("•")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "9CA3AF"))
                        
                        Text(relativeDate(for: item.scannedAt))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "D1D5DB"))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(hex: "F3F4F6"), lineWidth: 1.2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    private func relativeDate(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
