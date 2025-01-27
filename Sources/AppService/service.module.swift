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
    static var name: String { get }
    var stage: ServiceModuleStage { get }
    func bootstrap(_ context: ApplicationContext) async
}

public extension ServiceModule {
    static var name: String {
        return String(describing: Self.self)
    }
    var stage: ServiceModuleStage { .window }
}

public extension ApplicationContext {
    @MainActor
    func add(_ module: ServiceModule) {
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
        
        guard !modules.isEmpty, !isTasking else { return }
        isTasking = true
        let groupTasks = Dictionary(grouping: modules, by: {$0.stage})
        
        for(stage, tasks) in groupTasks {
            LogService.app.debug("start \(stage)")
            Task {
                await withTaskGroup(of: Void.self, body: { group in
                    for task in tasks {
                        group.addTask {
                            
                            LogService.app.debug("start task \(task.name)")
                            await task.value.bootstrap(self)
                            task.isBooted = true
                            LogService.app.debug("finish task \(task.name)")
                        }
                    }
                })
                
                LogService.app.debug("finish \(stage)")
                isTasking = false
                if stage <= targetStage {
                    bootstrap(targetStage)
                }
            }
            break
        }
    }



}


class AnyServiceModule {
    var value: ServiceModule
    let name: String
    var isBooted = false
    let stage: ServiceModuleStage
    init<T: ServiceModule>(value: T) {
        self.value = value
        self.name = T.name
        self.stage = value.stage
    }
}
