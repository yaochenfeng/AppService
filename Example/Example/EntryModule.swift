import Foundation
import SwiftUI
import AppService
import AppEntry

class EntryModule: NSObject, ServiceModule, ServiceDecode {
    let context: ApplicationContext
    required init(_ context: AppService.ApplicationContext) {
        self.context = context
        super.init()
        context.store.dispatch(.set(key: "isLogin", value: true))
        context.store.dispatch(.setMainView(builder: {
            ContentView()
        }))
    }
    
    
}
