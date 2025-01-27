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
        
        context.add(PrivacyModule())
        context.store.dispatch(.set(key: "isLogin", value: true))
        context.store.dispatch(.setMainView(builder: {
            ContentView()
        }))
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
