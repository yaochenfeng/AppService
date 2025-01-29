//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2025/1/28.
//

import SwiftUI
import WebKit

class HybridWeb: WKWebView {
    
}

struct AppWebView: View {
    let webView = HybridWeb(frame: .zero, configuration: Self.config).app
        .chain { web in
        
    }
    var body: some View {
        webView.onAppear {
            webView.base.load(URLRequest(url: URL(string: "https://m.baidu.com")!))
        }
    }
    
    static let config = WKWebViewConfiguration().app.then { base in
        base
    }
}

struct AppWebView_Previews: PreviewProvider {
    static var previews: some View {
        AppWebView()
    }
}
