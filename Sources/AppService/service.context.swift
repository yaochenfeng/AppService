
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
    
    var serviceModules: [AnyServiceModule] = []
    var targetStage: ServiceModuleStage = .application
    var isTasking = false
    
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
    
    @discardableResult
    func callAsFunction(api: String, args: Any...) throws -> Any {
        throw ServiceError.unimplemented()
        /// 解析api, 分割成命名空间 和 方法名
//        let components = api.components(separatedBy: ".")
//        let namespace = components.prefix(components.count - 1).joined(separator: ".")
//        let method = components.last!
//
//        /// 查找命名空间
//        let module = serviceModules.first { $0.name == namespace }
//        guard let module else {
//            fatalError("not found module \(namespace)")
//        }
//
//        /// 查找方法
//        let method = module.methods.first { $0.name == method }
//        guard let method else {
//            fatalError("not found method \(method)")
//        }
//        /// 调用方法
//        return method.call(args: args)
//        api.components(separatedBy: ".")
    }
}
