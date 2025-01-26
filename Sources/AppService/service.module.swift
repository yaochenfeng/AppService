import Foundation

public protocol ServiceModule {
    
}

public extension ApplicationContext {
    func add(_ module: ServiceModule) {
        self.modules.append(module)
    }
}
