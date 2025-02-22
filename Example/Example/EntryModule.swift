import Foundation
import SwiftUI
import AppService
import AppEntry

class EntryModule: NSObject, ServiceDecode {
    @MainActor
    required init(_ context: AppService.ApplicationContext) {
        super.init()
        context.add(LoggerModule())
        context.add(RouterModule())
        context.setValue(true, key: "isLogin")
        context.dispatch(.setMain(routerView))
    }
    
    var routerView: RouterView = RouterView { param in
        Page_home()
    }
    var stage: ServiceModuleStage = .application
    static var name: String { "" }
}

extension EntryModule: ServiceModule {
    
    func bootstrap(_ context: ApplicationContext) async {
        await context.bootstrap(.window)
    }
}


extension Router.RoutePath {
    static let webPage: Router.RoutePath  = "webpage"
}
