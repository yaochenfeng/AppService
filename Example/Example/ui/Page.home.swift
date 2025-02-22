//
//  Page.home.swift
//  Example
//
//  Created by yaochenfeng on 2025/2/22.
//

import SwiftUI
import AppService
struct Page_home: View {
    var body: some View {
        List {
            ForEach(PageEnum.allCases) { page in
                RouterLink(path: page.pagePath) {
                    Text("page\(page.rawValue)")
                }
            }
        }
    }
}

struct Page_home_Previews: PreviewProvider {
    static var previews: some View {
        Page_home()
    }
}
