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
    var stage: ServiceModuleStage = .privacy
    @MainActor
    func bootstrap(_ context: AppService.ApplicationContext) {
        context.dispatch(.setMainView(builder: {
            PrivacyView()
        }))
    }
}
