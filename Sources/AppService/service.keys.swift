import Foundation

public protocol ServiceKey {
    static var namespace: String { get }
}

public extension ServiceKey {
    static var namespace: String {
        return String(describing: Self.self)
    }
    
    var app: Service<Self> {
        return Service(self)
    }
    static var app: Service<Self>.Type {
        return Service<Self>.self
    }
}

extension NSObject: ServiceKey {}


public extension Service where Base: ServiceKey {
    @discardableResult
    func callAsFunction(method: String, arg: Any) throws -> Any {
        let namespace = Base.namespace
        return try getContext.callAsFunction(namespace: namespace, method: method, arg: arg)
    }
}
