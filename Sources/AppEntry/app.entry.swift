import SwiftUI
import AppService

@main
struct Entry {
    static func main() {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            EntryApp.main()
        } else if #available(iOS 13.0, *) {
            _ = EntryApp()
            UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
        }
    }
}

@available(iOS 13.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct EntryApp: App {
    static let context = ApplicationContext()
    
    var context = Self.context
    
    
    @MainActor
    init() {
        if let mainMudle = Bundle.main.infoDictionary?["CFBundleName"] as? String,
           let cls = NSClassFromString("\(mainMudle).EntryModule") as? ServiceModule.Type {
            Self.context.add(cls.init(context))
        }
    }
    
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension EntryApp: App {
    var body: some Scene {
        MainScene(store: context.store)
    }
}
