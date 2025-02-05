import SwiftUI
import AppService

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct MainScene: Scene {
    @ObservedObject
    var store: ServiceStore<ApplicationContext.State>
    
    var body: some Scene {
        store.state.mainScene ?? WindowGroup {
            store.state.mainView
        }
    }
    init(context: ApplicationContext = .shared) {
        self.store = context.store
        context.bootstrap(.window)
    }
}



public extension ApplicationContext.State {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    var mainScene: WindowGroup<AnyView>? {
        get {
            return self.getValue("mainScene")
        }
    }
    
    var mainView: AnyView {
    
        
        return self.getValue("mainView") ?? AnyView(emptyView)
    }
    
    internal var emptyView: some View {
        #if canImport(UIKit)
//        SwiftController.app.launch
        Text("import AppEntry dispatch setMainView")
        #else
        Text("import AppEntry dispatch setMainView")
        #endif
    }
}


extension ApplicationContext.State.Action {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func setMainScene(_ value: WindowGroup<AnyView>) -> Self {
        return .set(key: "mainScene", value: value)
    }
    @available(iOS 13.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func setMainView<Content: View>(@ViewBuilder builder: () -> Content) -> Self {
        return .set(key: "mainView", value: AnyView(builder()))
    }
}
