import Foundation
import SwiftUI
import AppService
import AppEntry

class EntryModule: NSObject, ServiceModule {
    let context: ApplicationContext
    required init(_ context: AppService.ApplicationContext) {
        self.context = context
        super.init()
        context.store.dispatch(.set(key: "isLogin", value: true))
        context.store.dispatch(.set(key: "mainScene", value: WindowGroup {
            AnyView(
                Text("entry demo")
                    .padding()
                    .onAppear(perform: {
                        context.store.dispatch(.set(key: "mainScene", value: WindowGroup(content: {
                            AnyView(Text("sdllsd").padding())
                        })))
                    })
            )
                    
            }))
    }
    
    
}
