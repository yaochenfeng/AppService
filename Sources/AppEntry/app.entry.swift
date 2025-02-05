import SwiftUI
import AppService

@main
struct Entry {
    static func main() {
        let context = ApplicationContext.shared
        if let mainBundle = Bundle.main.app.bundleName,
           let cls = NSClassFromString("\(mainBundle).EntryModule") as? ServiceDecode.Type,
            let obj = cls.init(context) as? ServiceModule {
            context.add(obj)
        }
        context.bootstrap(.application)
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            EntryApp.main()
        } else if #unavailable(iOS 14.0) {
            #if canImport(UIKit)
            UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
            #endif
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct EntryApp: App {
    var body: some Scene {
        MainScene()
    }
}
