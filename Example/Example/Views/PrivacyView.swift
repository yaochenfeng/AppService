//
//  PrivacyView.swift
//  Example
//
//  Created by yaochenfeng on 2025/1/27.
//

import SwiftUI
import AppService



struct PrivacyView: View {
    @Environment(\.router) var router
    
    var body: some View {
        VStack {
            Text("欢迎使用\(Bundle.app.displayName)")
                .font(.headline)
            
            Button("点击网页") {
                router.push(.webPage)
            }
        }.padding()
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
