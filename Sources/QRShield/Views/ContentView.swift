import SwiftUI

public enum NavigationDirection {
    case forward
    case backward
}

public extension AnyTransition {
    static func screenTransition(direction: NavigationDirection) -> AnyTransition {
        if direction == .forward {
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        } else {
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        }
    }
}

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
    @State private var navigationDirection: NavigationDirection = .forward
    @State private var customizeReturnTarget: CustomizeReturnTarget = .main
    @State private var showProPaywall: Bool = false
    @State private var isShowingScanner: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "06141B").ignoresSafeArea()
            
            // Main Content Area with butter-smooth animated screen transitions
            ZStack {
                switch currentRoute {
                case .main:
                    tabContent
                        .transition(.screenTransition(direction: navigationDirection))
                    
                case .generate:
                    GenerateQRView(
                        title: "Generator",
                        selectedTemplate: nil,
                        onBack: { goBack(to: .main) },
                        onOpenPro: { showProPaywall = true },
                        onProceedToCustomize: { payload, type, _ in
                            customizeReturnTarget = .generate
                            navigate(to: .customize(
                                content: payload,
                                type: type,
                                style: QRStyleConfig(),
                                template: nil
                            ), direction: .forward)
                        }
                    )
                    .transition(.screenTransition(direction: navigationDirection))
                    
                case .create(let template):
                    GenerateQRView(
                        title: "Create",
                        selectedTemplate: template,
                        onBack: {
                            selectedTab = .template
                            goBack(to: .main)
                        },
                        onOpenPro: { showProPaywall = true },
                        onProceedToCustomize: { payload, type, t in
                            let chosenTemplate = t ?? template
                            customizeReturnTarget = .create(template: chosenTemplate)
                            navigate(to: .customize(
                                content: payload,
                                type: type,
                                style: chosenTemplate.styleConfig,
                                template: chosenTemplate
                            ), direction: .forward)
                        }
                    )
                    .transition(.screenTransition(direction: navigationDirection))
                    
                case .customize(let content, let type, let style, let template):
                    CustomizeQRView(
                        content: content,
                        contentType: type,
                        styleConfig: style,
                        selectedTemplate: template,
                        onBack: {
                            switch customizeReturnTarget {
                            case .create(let tmpl):
                                goBack(to: .create(template: tmpl))
                            case .generate:
                                goBack(to: .generate)
                            case .templateTab:
                                selectedTab = .template
                                goBack(to: .main)
                            case .main:
                                goBack(to: .main)
                            }
                        },
                        onSaved: {
                            navigate(to: .myCodes(onlyFavorites: false), direction: .forward)
                        }
                    )
                    .transition(.screenTransition(direction: navigationDirection))
                    
                case .myCodes(let onlyFavorites):
                    MyCodesView(
                        initialOnlyFavorites: onlyFavorites,
                        onBack: { goBack(to: .main) },
                        onEditItem: { item in
                            customizeReturnTarget = .main
                            navigate(to: .customize(
                                content: item.rawContent,
                                type: item.contentType,
                                style: item.styleConfig,
                                template: nil
                            ), direction: .forward)
                        }
                    )
                    .transition(.screenTransition(direction: navigationDirection))
                    
                case .checkingSafety(let content):
                    CheckingLinkSafetyView(
                        rawContent: content,
                        onBack: { goBack(to: .main) },
                        onFinished: { result in
                            navigate(to: .scanResult(result: result), direction: .forward)
                        }
                    )
                    .transition(.screenTransition(direction: navigationDirection))
                    
                case .scanResult(let result):
                    ScanResultView(
                        result: result,
                        onBack: { goBack(to: .main) },
                        onDone: { goBack(to: .main) }
                    )
                    .transition(.screenTransition(direction: navigationDirection))
                    
                case .history:
                    HistoryView(onBack: { goBack(to: .main) })
                        .transition(.screenTransition(direction: navigationDirection))
                    
                case .settings:
                    SettingsView(
                        onBack: { goBack(to: .main) },
                        onOpenPro: { showProPaywall = true }
                    )
                    .transition(.screenTransition(direction: navigationDirection))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Tab Bar (shown on root tabs with smooth slide & fade)
            if currentRoute == .main {
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onScanTapped: {
                        isShowingScanner = true
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
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
                        navigate(to: .checkingSafety(content: code), direction: .forward)
                    }
                }
            )
        }
        // Fully viewed Pro Paywall
        .fullScreenCover(isPresented: $showProPaywall) {
            ProPaywallView()
        }
    }
    
    // MARK: - Navigation Helpers
    private func navigate(to route: NavigationRoute, direction: NavigationDirection = .forward) {
        withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
            self.navigationDirection = direction
            self.currentRoute = route
        }
    }
    
    private func goBack(to route: NavigationRoute) {
        navigate(to: route, direction: .backward)
    }
    
    private func switchTab(to tab: AppTab) {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
            self.selectedTab = tab
            self.currentRoute = .main
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView(
                    onNavigateToGenerate: {
                        navigate(to: .generate, direction: .forward)
                    },
                    onNavigateToScan: {
                        isShowingScanner = true
                    },
                    onNavigateToTemplates: {
                        switchTab(to: .template)
                    },
                    onSelectTemplate: { template in
                        navigate(to: .create(template: template), direction: .forward)
                    },
                    onNavigateToMyCodes: {
                        navigate(to: .myCodes(onlyFavorites: false), direction: .forward)
                    },
                    onNavigateToHistory: {
                        switchTab(to: .history)
                    },
                    onNavigateToFavorites: {
                        navigate(to: .myCodes(onlyFavorites: true), direction: .forward)
                    },
                    onOpenPro: {
                        showProPaywall = true
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.99)))
                
            case .template:
                TemplatesView(
                    showHeader: true,
                    showSearchBar: false,
                    onSelectTemplate: { template in
                        navigate(to: .create(template: template), direction: .forward)
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.99)))
                
            case .scan:
                Color.black
                    .ignoresSafeArea()
                    .onAppear {
                        isShowingScanner = true
                        selectedTab = .home
                    }
                
            case .history:
                HistoryView(
                    onBack: { switchTab(to: .home) }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.99)))
                
            case .settings:
                SettingsView(
                    onBack: { switchTab(to: .home) },
                    onOpenPro: { showProPaywall = true }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.99)))
            }
        }
    }
}
