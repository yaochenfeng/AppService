import Foundation
import SwiftUI
import AppService
import AppEntry

class EntryModule: NSObject, ServiceModule {
    let context: ApplicationContext
    @MainActor
    required init(_ context: AppService.ApplicationContext) {
        self.context = context
        super.init()
        
        context.add(PrivacyModule())
        context.store.dispatch(.set(key: "isLogin", value: true))
        context.store.dispatch(.setMainView(builder: {
            ContentView()
        }))
    }
    
    @MainActor
    func bootstrap(_ context: ApplicationContext) {
        context.bootstrap(.window)
    }
    
    var stage: ServiceModuleStage = .application
    
}
