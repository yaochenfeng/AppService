
public class ApplicationContext {
    public static var shared = ApplicationContext()
    public init() {
//        store = ServiceStore(State(), reducer: { state, action in
//            switch action {
//            case .load(let newState):
//                return newState
//            case .set(key: let key, value: let value):
//                var newState = state
//                newState.storage[key] = value
//                return state.setValue(value, key: key)
//            case .delete(key: let key):
//                var newState = state
//                newState.storage[key] = nil
//                return newState
//            }
//        })
    }
    
    var serviceModules: [AnyServiceModule] = []
    var targetStage: ServiceModuleStage = .application
    var isTasking = false
    var storage: [String: Any] = [:]
}
#if canImport(Combine)
import Combine
extension ApplicationContext: ObservableObject {}
#endif




public extension ApplicationContext {
    @discardableResult
    func setValue(_ value: Any, key: String) -> Self {
        storage[key] = value
        return self
    }

    func getValue<T>(_ key: String) -> T? {
        return storage[key] as? T
    }
    func contains(_ key: String) -> Bool {
        return storage.keys.contains(key)
    }
    
    @discardableResult
    func callAsFunction(namespace: String, method: String, arg: Any) throws -> Any {
        
        guard let module = serviceModules.first(where: { $0.name == namespace }) else {
            throw ServiceError.notFound(namespace)
        }
        return try module.value(method: String(method), arg: arg)
    }
}
