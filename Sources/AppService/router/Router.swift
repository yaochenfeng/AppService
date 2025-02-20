import SwiftUI

public final class Router: ObservableObject {
    public static var shared = Router()
    public init() {}
    typealias RouteFactory = (RouteParam) -> RoutePage<AnyView>
    @Published
    var pageStack: [RoutePage<AnyView>] = []
    var routeMap: [RoutePath: RouteFactory] = [:]
    var onGenerateRoute: RouteFactory?
    public var parseRoute: (String) -> (RoutePath, RouteParam)? = { str in
        return nil
    }
    public var notFound: RoutePage<AnyView> = RoutePage<AnyView>(path: .page404) { arg in
        Text("404")
    }
}

public extension Router {
    // MARK: - 注册路由
    @discardableResult
    func register<Content: View>(path: RoutePath, builder: @escaping (RouteParam) -> Content) -> Self {
        routeMap[path] = { arg in
            RoutePage<AnyView>(path: path, param: arg, builder: builder)
        }
        return self
    }
    
    func handleLink(_ string: String) {
        guard let item = self.parseRoute(string) else {
            return
        }
        push(item.0, params: item.1)
    }
    
    
    func push(_ path: RoutePath, params: RouteParam = [:]) {
        let page = getPage(path: path, param: params)
        pageStack.append(page)
    }
    func pop() {
        if !pageStack.isEmpty {
            pageStack.removeLast()
        }
    }
    
    func getPage(path: RoutePath, param: RouteParam) -> RoutePage<AnyView> {
        if let factory = routeMap[path] {
            return factory(param)
        } else if let factory = onGenerateRoute {
            return factory(param)
        }
        return notFound
    }
}

extension Router {
    ///  路由路径
    public struct RoutePath: RawRepresentable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    /// 路由参数
    public struct RouteParam {
        public var values: [String: Any] = [:]
        public init() {}
    }
}

extension Router.RoutePath: Hashable, ExpressibleByStringLiteral {
    public static let index = Self("/")
    public static let page404 = Self("/404")
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
    public init(_ value: String) {
        self.rawValue = value
    }
}

extension Router.RouteParam {
    public init(_ dictionary: [String: Any]) {
        self.values = dictionary
    }
    
    /// **获取参数的值**
    public func get<T>(_ key: String, as type: T.Type = T.self) -> T? {
        return values[key] as? T
    }
    
    /// **设置参数值**
    public mutating func set<T>(_ key: String, value: T) {
        values[key] = value
    }
    
    /// **检查是否包含某个参数**
    public func contains(_ key: String) -> Bool {
        return values.keys.contains(key)
    }
}

extension Router.RouteParam: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Any)...) {
        self.values = Dictionary(uniqueKeysWithValues: elements)
    }
}

extension Router.RouteParam: Equatable {
    public static func == (lhs: Router.RouteParam, rhs: Router.RouteParam) -> Bool {
        return String(describing: lhs.values) == String(describing: rhs.values)
    }
}


struct RouterKey: EnvironmentKey {
    static var defaultValue = Router.shared
}

extension EnvironmentValues {
    public var router: Router {
        get {
            return self[RouterKey.self]
        }
        set {
            self[RouterKey.self] = newValue
        }
    }
}
