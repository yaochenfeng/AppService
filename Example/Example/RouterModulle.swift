import Foundation
import AppService

enum PageEnum: String, CaseIterable, Identifiable {
    case index
    case settings
    case navigator
    
    var id: String {
        return rawValue
    }
}

extension PageEnum {
    var pagePath: Router.RoutePath {
        if PageEnum.index == self {
            return .index
        }
        return .init("page/\(rawValue)")
    }
    
    func register(_ router: Router) {
        router.register(path: pagePath) { param in
            switch self {
            case .index:
                Page_home()
            case .settings:
                Page_settings()
            case .navigator:
                Page_navigator()
            }
        }
    }
}

class RouterModule: ServiceModule {
    
    var stage: ServiceModuleStage = .application
    func bootstrap(_ context: AppService.ApplicationContext) async {
        for item in PageEnum.allCases {
            item.register(.shared)
        }
    }
}
