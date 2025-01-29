import SwiftUI
import AppService

@main
struct Entry {
    static func main() {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            EntryApp.main()
        } else if #unavailable(iOS 14.0) {
            #if canImport(UIKit)
            _ = EntryApp()
            UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
            #endif
        }
    }
}

@available(iOS 13.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct EntryApp: App {
    static let context = ApplicationContext.shared
    
    var context = Self.context
    
    
    @MainActor
    init() {
        if let mainBundle = Bundle.main.app.bundleName,
           let cls = NSClassFromString("\(mainBundle).EntryModule") as? ServiceDecode.Type,
            let obj = cls.init(context) as? ServiceModule {
            Self.context.add(obj)
        }
        
        context.bootstrap(.application)
    }
    
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension EntryApp: App {
    var body: some Scene {
        MainScene(store: context.store)
    }
}
