import Foundation

public protocol ServiceModule {
   
}

public extension ApplicationContext {
    @MainActor
    func add(_ module: ServiceModule) {
        self.modules.append(module)
    }
}
