import SwiftUI
import AppService

@main
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct EntryApp: App {
    static let context = ApplicationContext()
    
    var context = Self.context
    
    var body: some Scene {
        MainScene(store: context.store)
    }
    
    init() {
        if let mainMudle = Bundle.main.infoDictionary?["CFBundleName"] as? String,
           let cls = NSClassFromString("\(mainMudle).EntryModule") as? ServiceModule.Type {
            Self.context.add(cls.init(context))
        }
    }
}
