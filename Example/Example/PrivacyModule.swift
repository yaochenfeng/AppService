//
//  PrivacyModule.swift
//  Example
//
//  Created by yaochenfeng on 2025/1/27.
//

import Foundation
import AppService
import AppEntry

struct PrivacyModule: ServiceModule {
    func callAsFunction(method: String, args: Any...) throws -> Any {
        throw ServiceError.unimplemented()
    }
    
    
    var stage: ServiceModuleStage = .privacy
    @MainActor
    func bootstrap(_ context: AppService.ApplicationContext) {
        context.dispatch(.setMain(routerView))
    }
    
    var routerView: RouterView = RouterView { param in
        PrivacyView()
    }
}
