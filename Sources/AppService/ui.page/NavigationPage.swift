import SwiftUI

public class Navigator: ObservableObject {
    public static var shared = Navigator()
    public typealias Route = String
    typealias RouteBuilder = (Any) -> AnyView
    
    public init() {}
    @Published
    var paths: [String] = []
    
    var routes: [String: RouteBuilder] = [:]
    var onGenerateRoute: RouteBuilder?
    
    public func push(_ path: Route) {
        paths.append(path)
    }
    public func pop() {
        if !paths.isEmpty {
            _ = paths.removeLast()
        }
    }
    @discardableResult
    public func register<Page: View>(_ route: Route, @ViewBuilder builder: @escaping (Route) -> Page) -> Self {
        self.routes[route] = { arg in
            guard let route = arg as? Route else {
                return AnyView(EmptyView())
            }
            return AnyView(builder(route))
        }
        return self
    }
    
    @discardableResult
    public func onGenerateRoute<Page: View>(@ViewBuilder builder: @escaping (Route) -> Page) -> Self {
        self.onGenerateRoute = { arg in
            guard let route = arg as? Route else {
                return AnyView(EmptyView())
            }
            return AnyView(builder(route))
        }
        return self
    }
    
    
    public func resolve(_ route: Route) -> AnyView {
        if let builder = routes[route] {
            return builder(route)
        } else if let builder = onGenerateRoute {
            return builder(route)
        }
        return AnyView(EmptyView())
    }
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct NavigationPage<Content: View>: View {
    @StateObject var navigator: Navigator
    public init(navigator: Navigator = .shared,
                @ViewBuilder content builder: () -> Content) {
        self._navigator = StateObject(wrappedValue: navigator)
        self.content = builder()
    }
    let content: Content
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: $navigator.paths) {
                content
                    .navigationDestination(for: String.self) { route in
                        routeView(route)
                    }
            }.environment(\.navigator, .shared)
            
        } else {
            NavigationView {
                content
                    .appBackground {
                        NavigationLink(destination: destinationView(), isActive: .init(get: {
                            !navigator.paths.isEmpty
                        }, set: { value in
                            print(value)
                        }), label: {
                            EmptyView()
                        })
                    }
            }.environment(\.navigator, .shared)
        }
    }
    private func routeView(_ route: String) -> some View {
        navigator.resolve(route)
    }
    @ViewBuilder
    private func destinationView() -> some View {
        if let last = navigator.paths.last {
            routeView(last)
        } else {
            EmptyView()
        }
    }
}


struct NavigatorKey: EnvironmentKey {
    static var defaultValue = Navigator.shared
}

extension EnvironmentValues {
    public var navigator: Navigator {
        get {
            return self[NavigatorKey.self]
        }
        set {
            self[NavigatorKey.self] = newValue
        }
    }
}
