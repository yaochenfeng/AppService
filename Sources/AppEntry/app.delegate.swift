import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
@available(iOS, deprecated: 14.0, message: "")
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIHostingController(rootView: EntryApp.context.store.state.mainView)
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        self.window = window
        return true;
    }
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
            config.delegateClass = SceneDelegate.classForCoder()
            return config
        }
}
@available(iOS, deprecated: 14.0, message: "")
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            let window = UIWindow(windowScene: windowScene)
            let vc = UIHostingController(rootView: WindowView())
            window.rootViewController = vc
            window.makeKeyAndVisible()
            self.window = window
            }
}

struct WindowView: View {
    @ObservedObject var store = EntryApp.context.store
    var body: some View {
        store.state.mainView
    }
}
#else

class AppDelegate: NSObject {
}
#endif
