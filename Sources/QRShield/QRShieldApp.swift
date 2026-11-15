import SwiftUI

@main
public struct QRShieldApp: App {
    public init() {
        // Configure standard appearance
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.shieldPurple)
    }
    
    public var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
