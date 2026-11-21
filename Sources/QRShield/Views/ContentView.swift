import SwiftUI

// MARK: - Slide Offset Transition Modifier
public struct SlideOffsetModifier: ViewModifier {
    public let offset: CGFloat
    
    public init(offset: CGFloat) {
        self.offset = offset
    }
    
    public func body(content: Content) -> some View {
        content.offset(x: offset)
    }
}

// MARK: - Navigation Direction (Preserved for backward compatibility)
public enum NavigationDirection {
    case forward
    case backward
}

// MARK: - Navigation Route Definition
public enum NavigationRoute: Equatable, Identifiable {
    case main
    case generate
    case create(template: QRTemplate)
    case contentInput(item: GeneratorItem, template: QRTemplate? = nil)
    case customize(content: String, type: QRContentType, style: QRStyleConfig, template: QRTemplate? = nil)
    case myCodes(onlyFavorites: Bool)
    case checkingSafety(content: String)
    case scanResult(result: SafetyAnalysisResult)
    case history
    case settings
    
    public var id: String {
        switch self {
        case .main: return "main"
        case .generate: return "generate"
        case .create(let t): return "create_\(t.id)"
        case .contentInput(let item, let t): return "content_\(item.id)_\(t?.id ?? "none")"
        case .customize(let c, let type, _, let t): return "customize_\(c.hashValue)_\(type.rawValue)_\(t?.id ?? "none")"
        case .myCodes(let fav): return "myCodes_\(fav)"
        case .checkingSafety(let c): return "safety_\(c.hashValue)"
        case .scanResult(let r): return "scanResult_\(r.id.uuidString)"
        case .history: return "history"
        case .settings: return "settings"
        }
    }
}

// MARK: - Customize Return Target
public enum CustomizeReturnTarget: Equatable {
    case main
    case generate
    case create(template: QRTemplate)
    case contentInput(item: GeneratorItem, template: QRTemplate? = nil)
    case templateTab
}

// MARK: - Main Application Navigation & Screen Container
public struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var routeStack: [NavigationRoute] = [.main]
    @State private var customizeReturnTarget: CustomizeReturnTarget = .main
    @State private var showProPaywall: Bool = false
    @State private var isShowingScanner: Bool = false
    
    // Interactive edge swipe gesture state
    @State private var dragOffset: CGFloat = 0
    @State private var isDraggingBack: Bool = false
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                // Global Background
                Color(hex: "06141B").ignoresSafeArea()
                
                // Active Screen Stack (Full Layered Parallax Navigation)
                ForEach(Array(routeStack.enumerated()), id: \.element.id) { index, route in
                    let isTop = index == routeStack.count - 1
                    let isUnderneath = index == routeStack.count - 2
                    let isDeeper = index < routeStack.count - 2
                    
                    if !isDeeper {
                        let activeDrag = isTop ? max(0, dragOffset) : 0
                        let progress = activeDrag / max(1, screenWidth)
                        let underneathOffset = -screenWidth * 0.22 * (1.0 - progress)
                        let underneathOpacity = 0.88 + 0.12 * progress
                        
                        renderScreen(route)
                            .frame(width: screenWidth, height: screenHeight)
                            .background(Color(hex: "06141B"))
                            .offset(x: isTop ? activeDrag : underneathOffset)
                            .opacity(isTop ? 1.0 : underneathOpacity)
                            .shadow(
                                color: Color.black.opacity(isTop && index > 0 ? 0.35 : 0),
                                radius: 14,
                                x: -6,
                                y: 0
                            )
                            .zIndex(Double(index))
                            .allowsHitTesting(isTop)
                            .transition(.asymmetric(
                                insertion: .modifier(
                                    active: SlideOffsetModifier(offset: screenWidth),
                                    identity: SlideOffsetModifier(offset: 0)
                                ),
                                removal: .modifier(
                                    active: SlideOffsetModifier(offset: screenWidth),
                                    identity: SlideOffsetModifier(offset: 0)
                                )
                            ))
                    }
                }
            }
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        guard routeStack.count > 1 else { return }
                        if isDraggingBack || (value.startLocation.x <= 36 && value.translation.width > 5 && abs(value.translation.height) < abs(value.translation.width) * 1.5) {
                            isDraggingBack = true
                            dragOffset = max(0, value.translation.width)
                        }
                    }
                    .onEnded { value in
                        guard isDraggingBack else { return }
                        isDraggingBack = false
                        let threshold = screenWidth * 0.33
                        let velocity = value.predictedEndLocation.x - value.location.x
                        if value.translation.width > threshold || velocity > 250 {
                            withAnimation(.spring(response: 0.30, dampingFraction: 0.94)) {
                                dragOffset = screenWidth
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                dragOffset = 0
                                goBack()
                            }
                        } else {
                            withAnimation(.spring(response: 0.26, dampingFraction: 0.92)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        // Full screen scanner cover
        .fullScreenCover(isPresented: $isShowingScanner) {
            ScanQRCodeView(
                onBack: {
                    isShowingScanner = false
                },
                onCodeDetected: { code in
                    isShowingScanner = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigate(to: .checkingSafety(content: code))
                    }
                }
            )
        }
        // Pro Paywall
        .fullScreenCover(isPresented: $showProPaywall) {
            ProPaywallView()
        }
    }
    
    // MARK: - Screen Renderer
    @ViewBuilder
    private func renderScreen(_ route: NavigationRoute) -> some View {
        switch route {
        case .main:
            mainRootView
            
        case .generate:
            GenerateQRView(
                title: "Generator",
                selectedTemplate: nil,
                onBack: { goBack() },
                onOpenPro: { showProPaywall = true },
                onSelectItem: { item, template in
                    navigate(to: .contentInput(item: item, template: template))
                },
                onProceedToCustomize: { payload, type, _ in
                    customizeReturnTarget = .generate
                    navigate(to: .customize(
                        content: payload,
                        type: type,
                        style: QRStyleConfig(),
                        template: nil
                    ))
                }
            )
            
        case .create(let template):
            GenerateQRView(
                title: "Create",
                selectedTemplate: template,
                onBack: {
                    selectedTab = .template
                    goBack(to: .main)
                },
                onOpenPro: { showProPaywall = true },
                onSelectItem: { item, tmpl in
                    navigate(to: .contentInput(item: item, template: tmpl ?? template))
                },
                onProceedToCustomize: { payload, type, t in
                    let chosenTemplate = t ?? template
                    customizeReturnTarget = .create(template: chosenTemplate)
                    navigate(to: .customize(
                        content: payload,
                        type: type,
                        style: chosenTemplate.styleConfig,
                        template: chosenTemplate
                    ))
                }
            )
            
        case .contentInput(let item, let template):
            ContentInputView(
                item: item,
                selectedTemplate: template,
                onBack: {
                    goBack()
                },
                onCreate: { payload, contentType in
                    customizeReturnTarget = .contentInput(item: item, template: template)
                    var style = template?.styleConfig ?? QRStyleConfig()
                    if style.logoType == .none, let logo = QRLogoType.from(itemId: item.id) {
                        style.logoType = logo
                    }
                    navigate(to: .customize(
                        content: payload,
                        type: contentType,
                        style: style,
                        template: template
                    ))
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
                    case .contentInput(let item, let tmpl):
                        goBack(to: .contentInput(item: item, template: tmpl))
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
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.94)) {
                        self.routeStack = [.main, .myCodes(onlyFavorites: false)]
                    }
                }
            )
            
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
                    ))
                }
            )
            
        case .checkingSafety(let content):
            CheckingLinkSafetyView(
                rawContent: content,
                onBack: { goBack(to: .main) },
                onFinished: { result in
                    navigate(to: .scanResult(result: result))
                }
            )
            
        case .scanResult(let result):
            ScanResultView(
                result: result,
                onBack: { goBack(to: .main) },
                onDone: { goBack(to: .main) }
            )
            
        case .history:
            HistoryView(onBack: { goBack(to: .main) })
            
        case .settings:
            SettingsView(
                onBack: { goBack(to: .main) },
                onOpenPro: { showProPaywall = true }
            )
        }
    }
    
    // MARK: - Main Root View (Tabs + Custom Bottom Navigation Bar)
    private var mainRootView: some View {
        ZStack(alignment: .bottom) {
            tabContent
            
            CustomTabBar(
                selectedTab: $selectedTab,
                onScanTapped: {
                    isShowingScanner = true
                }
            )
        }
    }
    
    // MARK: - Root Tab Content
    @ViewBuilder
    private var tabContent: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView(
                    onNavigateToGenerate: {
                        navigate(to: .generate)
                    },
                    onNavigateToScan: {
                        isShowingScanner = true
                    },
                    onNavigateToTemplates: {
                        switchTab(to: .template)
                    },
                    onSelectTemplate: { template in
                        navigate(to: .create(template: template))
                    },
                    onNavigateToMyCodes: {
                        navigate(to: .myCodes(onlyFavorites: false))
                    },
                    onNavigateToHistory: {
                        switchTab(to: .history)
                    },
                    onNavigateToFavorites: {
                        navigate(to: .myCodes(onlyFavorites: true))
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
                        navigate(to: .create(template: template))
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
                    onBack: { switchTab(to: .home) }
                )
                
            case .settings:
                SettingsView(
                    onBack: { switchTab(to: .home) },
                    onOpenPro: { showProPaywall = true }
                )
            }
        }
        .transition(.opacity)
    }
    
    // MARK: - Navigation Helpers (Butter-smooth Spring Animations)
    private func navigate(to route: NavigationRoute) {
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
        withAnimation(.spring(response: 0.38, dampingFraction: 0.94, blendDuration: 0.05)) {
            self.routeStack.append(route)
        }
    }
    
    private func goBack() {
        guard routeStack.count > 1 else { return }
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
        withAnimation(.spring(response: 0.38, dampingFraction: 0.94, blendDuration: 0.05)) {
            _ = self.routeStack.removeLast()
        }
    }
    
    private func goBack(to route: NavigationRoute) {
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
        if let index = routeStack.lastIndex(where: { $0.id == route.id }) {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.94, blendDuration: 0.05)) {
                self.routeStack = Array(self.routeStack.prefix(through: index))
            }
        } else {
            goBack()
        }
    }
    
    private func switchTab(to tab: AppTab) {
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
        withAnimation(.easeInOut(duration: 0.2)) {
            self.selectedTab = tab
            self.routeStack = [.main]
        }
    }
}
