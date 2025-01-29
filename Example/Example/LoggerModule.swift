//
//  LoggerModule.swift
//  Example
//
//  Created by yaochenfeng on 2025/1/30.
//

import Foundation
import AppService
struct LoggerModule: ServiceModule {
    var name: String = LogService.name
    func callAsFunction(method: String, args: Any...) throws -> Any {
        print(args)
    }
    
    func bootstrap(_ context: AppService.ApplicationContext) async {
        
    }
    
}
