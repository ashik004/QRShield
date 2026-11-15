import SwiftUI

public enum NavigationRoute: Equatable {
    case main
    case templates
    case generate
    case customize(content: String, type: QRContentType, style: QRStyleConfig)
    case myCodes(onlyFavorites: Bool)
    case scan
    case checkingSafety(content: String)
    case scanResult(result: SafetyAnalysisResult)
    case history
    case settings
}

public struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var currentRoute: NavigationRoute = .main
    @State private var showProPaywall: Bool = false
    
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
                        onBack: { currentRoute = .main },
                        onSelectTemplate: { template in
                            currentRoute = .customize(
                                content: template.defaultContent,
                                type: .website,
                                style: template.styleConfig
                            )
                        }
                    )
                    
                case .generate:
                    GenerateQRView(
                        onBack: { currentRoute = .main },
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
                    
                case .scan:
                    ScanQRCodeView(
                        onBack: { currentRoute = .main },
                        onCodeDetected: { code in
                            currentRoute = .checkingSafety(content: code)
                        }
                    )
                    
                case .checkingSafety(let content):
                    CheckingLinkSafetyView(
                        rawContent: content,
                        onBack: { currentRoute = .scan },
                        onFinished: { result in
                            currentRoute = .scanResult(result: result)
                        }
                    )
                    
                case .scanResult(let result):
                    ScanResultView(
                        result: result,
                        onBack: { currentRoute = .scan },
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
                        currentRoute = .scan
                    }
                )
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showProPaywall) {
            ProPaywallView()
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:
            HomeView(
                onNavigateToGenerate: {
                    currentRoute = .generate
                },
                onNavigateToScan: {
                    currentRoute = .scan
                },
                onNavigateToTemplates: {
                    currentRoute = .templates
                },
                onNavigateToMyCodes: {
                    currentRoute = .myCodes(onlyFavorites: false)
                },
                onNavigateToHistory: {
                    currentRoute = .history
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
                onBack: { selectedTab = .home },
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
            ScanQRCodeView(
                onBack: { selectedTab = .home },
                onCodeDetected: { code in
                    currentRoute = .checkingSafety(content: code)
                }
            )
            
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
