import SwiftUI
import AppService

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct MainScene: Scene {
    @ObservedObject
    var store: ServiceStore<ApplicationContext.State>
    
    var body: some Scene {
        WindowGroup {
            store.state.mainView
        }
    }
    init(context: ApplicationContext = .shared) {
        self.store = context.store
        context.bootstrap(.window)
    }
}

public extension ApplicationContext {
    struct State: ServiceStateType {
        public static func reducer(state: State, action: Action) -> State {
            var newValue = state
            switch action {
                
            case .setMain(let builder):
                newValue.mainView = builder()
            }
            return newValue;
        }
        
        
        public enum Action {
            case setMain(_ builder: () -> AnyView)
        }
        var mainView: AnyView = Text("import AppEntry dispatch setMainView")
            .app.asAnyView()
            
        init() {
            
        }
        
    }
    var store: ServiceStore<State> {
        if let value: ServiceStore<State> = getValue("appStore") {
            return value
        }
        
        let value = ServiceStore<State>.init(State())
        setValue(value, key: "appStore")
        return value
    }
    
    @MainActor
        func dispatch(_ action: State.Action, forceUpdate: Bool = false) {
            store.dispatch(action)
        }
}
