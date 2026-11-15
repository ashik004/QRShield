import SwiftUI

public enum NavigationRoute: Equatable {
    case main
    case templates
    case customize(content: String, type: QRContentType, style: QRStyleConfig)
    case myCodes(onlyFavorites: Bool)
    case checkingSafety(content: String)
    case scanResult(result: SafetyAnalysisResult)
    case history
    case settings
}

public struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var currentRoute: NavigationRoute = .main
    @State private var showProPaywall: Bool = false
    @State private var isShowingScanner: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content Area
            Group {
                switch currentRoute {
                case .main:
                    tabContent
                    
                case .templates:
                    TemplatesView(
                        onSelectTemplate: { template in
                            currentRoute = .customize(
                                content: template.defaultContent,
                                type: .website,
                                style: template.styleConfig
                            )
                        }
                    )
                    .safeAreaInset(edge: .top) {
                        // Clean back button bar for when Templates is pushed from Home quick tile
                        HStack {
                            Button(action: { currentRoute = .main }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("Back")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(Color.shieldPurple)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .background(Color.white)
                    }
                    
                case .customize(let content, let type, let style):
                    CustomizeQRView(
                        content: content,
                        contentType: type,
                        styleConfig: style,
                        onBack: { currentRoute = .main },
                        onSaved: {
                            currentRoute = .myCodes(onlyFavorites: false)
                        }
                    )
                    
                case .myCodes(let onlyFavorites):
                    MyCodesView(
                        initialOnlyFavorites: onlyFavorites,
                        onBack: { currentRoute = .main },
                        onEditItem: { item in
                            currentRoute = .customize(
                                content: item.rawContent,
                                type: item.contentType,
                                style: item.styleConfig
                            )
                        }
                    )
                    
                case .checkingSafety(let content):
                    CheckingLinkSafetyView(
                        rawContent: content,
                        onBack: { currentRoute = .main },
                        onFinished: { result in
                            currentRoute = .scanResult(result: result)
                        }
                    )
                    
                case .scanResult(let result):
                    ScanResultView(
                        result: result,
                        onBack: { currentRoute = .main },
                        onDone: { currentRoute = .main }
                    )
                    
                case .history:
                    HistoryView(onBack: { currentRoute = .main })
                    
                case .settings:
                    SettingsView(
                        onBack: { currentRoute = .main },
                        onOpenPro: { showProPaywall = true }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Tab Bar (shown on root tabs)
            if currentRoute == .main {
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onScanTapped: {
                        isShowingScanner = true
                    }
                )
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        // Butter-smooth full screen scanner cover (Zero jumping!)
        .fullScreenCover(isPresented: $isShowingScanner) {
            ScanQRCodeView(
                onBack: {
                    isShowingScanner = false
                },
                onCodeDetected: { code in
                    isShowingScanner = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        currentRoute = .checkingSafety(content: code)
                    }
                }
            )
        }
        // Fully viewed Pro Paywall
        .fullScreenCover(isPresented: $showProPaywall) {
            ProPaywallView()
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:
            HomeView(
                onNavigateToGenerate: {
                    selectedTab = .generate
                },
                onNavigateToScan: {
                    isShowingScanner = true
                },
                onNavigateToTemplates: {
                    currentRoute = .templates
                },
                onNavigateToMyCodes: {
                    currentRoute = .myCodes(onlyFavorites: false)
                },
                onNavigateToHistory: {
                    selectedTab = .history
                },
                onNavigateToFavorites: {
                    currentRoute = .myCodes(onlyFavorites: true)
                },
                onOpenPro: {
                    showProPaywall = true
                }
            )
            
        case .generate:
            GenerateQRView(
                onProceedToCustomize: { payload, type in
                    currentRoute = .customize(
                        content: payload,
                        type: type,
                        style: QRStyleConfig()
                    )
                },
                onSelectTemplate: { template in
                    currentRoute = .customize(
                        content: template.defaultContent,
                        type: .website,
                        style: template.styleConfig
                    )
                }
            )
            
        case .scan:
            // If the user navigates directly to Scan tab, show scanner smoothly
            Color.black
                .ignoresSafeArea()
                .onAppear {
                    isShowingScanner = true
                    selectedTab = .home
                }
            
        case .history:
            HistoryView(
                onBack: { selectedTab = .home }
            )
            
        case .settings:
            SettingsView(
                onBack: { selectedTab = .home },
                onOpenPro: { showProPaywall = true }
            )
        }
    }
}
