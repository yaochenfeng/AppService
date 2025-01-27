import Foundation

/// 服务模块
/// 服务模块的生命周期
/// 1. 应用启动     application
/// 2. 隐私协议未同意 privacy
/// 3. 窗口创建     window
/// 4. 闪屏页启动   splash
/// 5. 首页启动     home
public enum ServiceModuleStage: CaseIterable, Comparable {
    case application
    case privacy
    case window
    case splash
    case home
    case idle
}

public protocol ServiceModule {
    var id: String { get }
    var stage: ServiceModuleStage { get }
    func bootstrap(_ context: ApplicationContext) async
}

public extension ServiceModule {
    var id: String {
        return String(describing: Self.self)
    }
    var stage: ServiceModuleStage { .window }
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
    func bootstrap(_ stage: ServiceModuleStage) {
        if self.targetStage < stage {
            self.targetStage = stage
        }

        // 未启动 按照stage排序, 从小到大
        let modules = self.serviceModules
            .filter { !$0.isBooted && $0.stage <= targetStage}
            .sorted { lhs, rhs in
                return lhs.stage < rhs.stage
        }

        // 创建一个任务组
        Task {
            for module in modules where !module.isBooted {
                module.isBooted = true
                // 在任务组中添加任务
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await module.value.bootstrap(self)
                    }
                    // 等待任务组中的所有任务完成
                    await group.waitForAll()
                }
            }
        }
    }



}


class AnyServiceModule {
    var value: ServiceModule
    let name: String
    var isBooted = false
    let stage: ServiceModuleStage
    init(value: ServiceModule) {
        self.value = value
        self.name = value.id
        self.stage = value.stage
    }
}
