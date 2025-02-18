//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2025/2/18.
//

import SwiftUI

public struct RoutePage<Content:View> {
    let id: UUID
    let path: Router.RoutePath
    let param : Router.RouteParam
    let builder: (Router.RouteParam) -> Content
    
    public init(id: UUID = UUID(),
         path: Router.RoutePath,
                param: Router.RouteParam = [:],
         @ViewBuilder builder: @escaping (Router.RouteParam) -> Content) {
        self.id = id
        self.path = path
        self.builder = builder
        self.param = param
    }
}
extension RoutePage where Content == AnyView {
    public init<Page: View>(
        id: UUID = UUID(),
         path: Router.RoutePath,
        param: Router.RouteParam = [:],
         builder content: @escaping (Router.RouteParam) -> Page) {
        self.id = id
        self.path = path
             self.param = param
        self.builder =  { arg in
            content(arg).appAny()
        }
    }
}

extension RoutePage: Equatable where Content == AnyView {
    public static func == (lhs: RoutePage<Content>, rhs: RoutePage<Content>) -> Bool {
        return lhs.id == rhs.id && lhs.path == rhs.path && lhs.param == rhs.param
    }
}

extension RoutePage: Hashable where Content == AnyView {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(path)
    }
}

extension RoutePage: View {
    public var body: some View {
        builder(param)
    }
}

struct RoutePage_Previews: PreviewProvider {
    static var previews: some View {
//        SwiftUIView()
        RoutePage.init(path: .index) { param in
            Text("hello")
        }
        
    }
}
