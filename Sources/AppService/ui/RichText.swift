import SwiftUI
import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public struct RichText: View {
    static let action = "action://rich.link/"
    let text: String
    let rules: [Rule]
    var matches: [MatchItem] = []
    
    public init(text: String, rules: [Rule]) {
        self.text = text
        self.rules = rules
        self.matches = findMatches(in: text)
    }
    
    /// 规则类型
    public enum RuleType {
        case url
        case mention
        case hashtag
        case staticText(String) // 静态文本
        case custom(regex: String)
    }
    
    /// 规则定义
    public struct Rule {
        let type: RuleType
        let color: Color
        let isUnderline: Bool
        let action: (String) -> Void
        let id: String
        
        public init(type: RuleType, color: Color = .blue, isUnderline: Bool = false, action: @escaping (String) -> Void) {
            self.type = type
            self.color = color
            self.isUnderline = isUnderline
            self.action = action
            self.id = UUID().uuidString
        }
    }
    
    struct MatchItem {
        let text: String
        let rule: Rule
        let id: String // 让 id 唯一

        init(text: String, rule: Rule) {
            self.text = text
            self.rule = rule
            self.id = rule.id + "_" + text // 组合 id 让其唯一
        }
    }
    
    
    public var body: some View {
        Text(makeAttributedString(from: text))
            .padding()
            .environment(\.openURL, OpenURLAction(handler: { url in
                let str = url.absoluteString
                guard str.hasPrefix(Self.action) else {
                    return .handled
                }
                let id = str.replacingOccurrences(of: Self.action, with: "")
                
                for item in matches where item.id == id {
                    item.rule.action(item.text)
                }
//                        guard let (matchedText, rule) = ruleMap[id] else {
//                            return .handled
//                        }
//                        rule.action(matchedText) // 现在传入的是完整的匹配文本
                return .handled
            }))
        
    }
    
    /// 解析文本为 `AttributedString`
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    private func makeAttributedString(from text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        for match in matches {
            if let range = attributedString.range(of: match.text) {
                attributedString[range].foregroundColor = match.rule.color
                if match.rule.isUnderline {
                    attributedString[range].underlineStyle = .single
                }
                attributedString[range].link = URL(string: Self.action.appending(match.id))
            }
        }
        
        return attributedString
    }
    
    /// 查找匹配的文本
    private func findMatches(in text: String) -> [MatchItem] {
        var matches: [MatchItem] = []
        var seenRanges: Set<NSRange> = []  // 存储已匹配的 range，防止 staticText 误匹配

        let nsText = text as NSString

        // 规则按优先级排序（mention > hashtag > staticText）
        let sortedRules = rules.sorted { lhs, rhs in
            switch (lhs.type, rhs.type) {
            case (.mention, .staticText), (.mention, .hashtag), (.hashtag, .staticText):
                return true  // mention > hashtag > staticText
            default:
                return false
            }
        }

        for rule in sortedRules {
            guard let regex = makeRegex(for: rule) else { continue }

            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length))

            for result in results {
                let range = result.range
                let matchedText = nsText.substring(with: range)

                // ✅ 确保相同范围不会被重复匹配
                if seenRanges.contains(range) { continue }
                seenRanges.insert(range)

                matches.append(MatchItem(text: matchedText, rule: rule))
            }
        }

        return matches
    }


    
    /// 生成正则表达式
    private func makeRegex(for rule: Rule) -> NSRegularExpression? {
        let pattern: String
        switch rule.type {
        case .url:
            pattern = #"https?:\/\/[a-zA-Z0-9./?&=_-]+"#
        case .mention:
            pattern = #"(?<!\w)@[a-zA-Z0-9_]+"#  // `@swift` 只能整体匹配
        case .hashtag:
            pattern = #"#\w+"#
        case .staticText(let keyword):
            // ✅ 确保匹配的 `keyword` 不是其他单词的一部分
            pattern = #"(?<![\w@#])\Q\#(keyword)\E(?!\w)"#
        case .custom(let regex):
            pattern = regex
        }
        return try? NSRegularExpression(pattern: pattern, options: [])
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
struct RichText_Previews: PreviewProvider {
    static var previews: some View {
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
