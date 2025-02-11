
public class ApplicationContext {
    public static var shared = ApplicationContext()
    public init() {}
    
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
