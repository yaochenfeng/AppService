import Foundation
import SwiftUI
import AppService
import AppEntry

class EntryModule: NSObject, ServiceDecode {
//    let context: ApplicationContext
    @MainActor
    required init(_ context: AppService.ApplicationContext) {
//        self.context = context
        super.init()
        context.add(LoggerModule())
        context.add(PrivacyModule())
        context.setValue(true, key: "isLogin")
        context.dispatch(.setMain(routerView))
    }
    
    var routerView: RouterView = RouterView { param in
        ContentView()
    }
    
//    @MainActor
//    func bootstrap(_ context: ApplicationContext) {
//        context.bootstrap(.window)
//    }
//
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
