import Foundation

public protocol ServiceModule {
    @MainActor
    init(_ context: ApplicationContext)
}

public extension ApplicationContext {
    func add(_ module: ServiceModule) {
        self.modules.append(module)
    }
}
