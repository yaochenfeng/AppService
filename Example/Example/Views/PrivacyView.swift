//
//  PrivacyView.swift
//  Example
//
//  Created by yaochenfeng on 2025/1/27.
//

import SwiftUI
import AppService

struct PrivacyView: View {
    var body: some View {
        VStack {
            Text("欢迎使用\(Bundle.app.displayName)")
                .font(.headline)
            
            contentText
        }.padding()
    }
    
    var contentText: RichText {
        let richText = RichText(
                 text: "访问 https://xxzh.store 关注 @Swift 话题 #SwiftUI  苹果 Apple 2025-02-20",
                 rules: [
                     .init(type: .url, isUnderline: true) { url in print("打开链接: \(url)") },
                     .init(type: .mention, color: .purple) { name in print("点击了用户: \(name)") },
                     .init(type: .hashtag, color: .green) { tag in print("点击了话题: \(tag)") },
                     .init(type: .staticText("Swift"), color: .orange) { keyword in print("点击了静态文本: \(keyword)") },
                     .init(type: .staticText("Apple"), color: .red) { keyword in print("点击了静态文本: \(keyword)") },
                     .init(type: .custom(regex: "\\d{4}-\\d{2}-\\d{2}"), color: .red) { date in print("点击了日期: \(date)") }
                 ]
             )

             return richText
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
