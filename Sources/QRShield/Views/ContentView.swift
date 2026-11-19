import SwiftUI

public enum NavigationRoute: Equatable {
    case main
    case generate
    case create(template: QRTemplate)
    case customize(content: String, type: QRContentType, style: QRStyleConfig, template: QRTemplate? = nil)
    case myCodes(onlyFavorites: Bool)
    case checkingSafety(content: String)
    case scanResult(result: SafetyAnalysisResult)
    case history
    case settings
}

public enum CustomizeReturnTarget: Equatable {
    case main
    case generate
    case create(template: QRTemplate)
    case templateTab
}

public struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var currentRoute: NavigationRoute = .main
    @State private var customizeReturnTarget: CustomizeReturnTarget = .main
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
                    
                case .generate:
                    GenerateQRView(
                        title: "Generate QR Code",
                        selectedTemplate: nil,
                        onBack: { currentRoute = .main },
                        onProceedToCustomize: { payload, type, _ in
                            customizeReturnTarget = .generate
                            currentRoute = .customize(
                                content: payload,
                                type: type,
                                style: QRStyleConfig(),
                                template: nil
                            )
                        }
                    )
                    
                case .create(let template):
                    GenerateQRView(
                        title: "Create",
                        selectedTemplate: template,
                        onBack: {
                            selectedTab = .template
                            currentRoute = .main
                        },
                        onProceedToCustomize: { payload, type, t in
                            let chosenTemplate = t ?? template
                            customizeReturnTarget = .create(template: chosenTemplate)
                            currentRoute = .customize(
                                content: payload,
                                type: type,
                                style: chosenTemplate.styleConfig,
                                template: chosenTemplate
                            )
                        }
                    )
                    
                case .customize(let content, let type, let style, let template):
                    CustomizeQRView(
                        content: content,
                        contentType: type,
                        styleConfig: style,
                        selectedTemplate: template,
                        onBack: {
                            switch customizeReturnTarget {
                            case .create(let tmpl):
                                currentRoute = .create(template: tmpl)
                            case .generate:
                                currentRoute = .generate
                            case .templateTab:
                                selectedTab = .template
                                currentRoute = .main
                            case .main:
                                currentRoute = .main
                            }
                        },
                        onSaved: {
                            currentRoute = .myCodes(onlyFavorites: false)
                        }
                    )
                    
                case .myCodes(let onlyFavorites):
                    MyCodesView(
                        initialOnlyFavorites: onlyFavorites,
                        onBack: { currentRoute = .main },
                        onEditItem: { item in
                            customizeReturnTarget = .main
                            currentRoute = .customize(
                                content: item.rawContent,
                                type: item.contentType,
                                style: item.styleConfig,
                                template: nil
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
                    currentRoute = .generate
                },
                onNavigateToScan: {
                    isShowingScanner = true
                },
                onNavigateToTemplates: {
                    selectedTab = .template
                    currentRoute = .main
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
            
        case .template:
            TemplatesView(
                showHeader: true,
                showSearchBar: false,
                onSelectTemplate: { template in
                    currentRoute = .create(template: template)
                }
            )
            
        case .scan:
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
