import SwiftUI
import AppService

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct MainScene: Scene {
    @ObservedObject var store: ServiceStore<ApplicationContext.State>
    
    var body: some Scene {
        store.state.mainScene ?? WindowGroup {
            AnyView(Text("entry defalut")
            .padding())
                
        }
    }
}



extension ApplicationContext.State {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    var mainScene: WindowGroup<AnyView>? {
        get {
            return self.getValue("mainScene")
        }
    }
}
