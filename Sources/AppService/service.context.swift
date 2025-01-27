
public class ApplicationContext {
    public static var shared = ApplicationContext()
    public init() {
        store = ServiceStore(.init(), reducers: [])
        store.add { state, action in
            switch action {
            case .load(let newState):
                return newState
            case .set(key: let key, value: let value):
                var newState = state
                newState.storage[key] = value
                return state.setValue(value, key: key)
            case .delete(key: let key):
                var newState = state
                newState.storage[key] = nil
                return newState
            }
        }
    }
    public var modules: [ServiceModule] = []
    
    var serviceModules: [AnyServiceModule] = []
    
    public var store: ServiceStore<State>
}
#if canImport(Combine)
import Combine
extension ApplicationContext: ObservableObject {}
#endif




public extension ApplicationContext {
    struct State: ServiceState {
        public static func == (lhs: ApplicationContext.State, rhs: ApplicationContext.State) -> Bool {
            return lhs.storage.elementsEqual(rhs.storage) { lhs, rhs in
                return lhs.key == rhs.key && equals(lhs.value, rhs.value)
            }
        }
        
        var storage: [String: Any] = [:]
        
        public enum Action {
            case load(State)
            case set(key: String, value: Any)
            case delete(key: String)
        }
        
        public func setValue(_ value: Any, key: String) -> Self {
            var newState = self
            newState.storage[key] = value
            return newState
        }
        
        public func getValue<T>(_ key: String) -> T? {
            return storage[key] as? T
        }
    }
    
    @MainActor
    func dispatch(_ action: State.Action, forceUpdate: Bool = false) {
        store.dispatch(action, forceUpdate: forceUpdate)
    }
    
    var state: State {
        store.state
    }
}
