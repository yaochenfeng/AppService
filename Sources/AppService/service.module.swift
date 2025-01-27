import Foundation

public enum ServiceModuleStage {
    case application
    case window
    case splash
}

public protocol ServiceModule {
    var id: String { get }
    func bootstrap(_ context: ApplicationContext)
}

public extension ServiceModule {
    var id: String {
        return String(describing: Self.self)
    }
}

public extension ApplicationContext {
    @MainActor
    func add(_ module: ServiceModule) {
        self.modules.append(module)
        self.serviceModules.append(AnyServiceModule(value: module))
    }
    @MainActor
    func add<T: ServiceModule & ServiceDecode>(_ module: T.Type = T.self) {
        let obj = T.init(self)
        self.add(obj)
    }

    @MainActor
    func bootstrap() {
        for module in serviceModules where !module.isBooted {
            module.isBooted = true
            module.value.bootstrap(self)
        }
    }
}


class AnyServiceModule {
    var value: ServiceModule
    let name: String
    var isBooted = false
    init(value: ServiceModule) {
        self.value = value
        self.name = value.id
    }
}
