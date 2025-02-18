//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2025/2/19.
//

import SwiftUI

public struct RouterView {
    @ObservedObject
    var router: Router
    var rootPath: Router.RoutePath
    
    var rootPage: RoutePage<AnyView>?
    public init(router: Router = .shared , root: Router.RoutePath = .index) {
        self.router = router
        self.rootPath = root
    }
    public init<Content: View>(router: Router = .shared ,
                               builder: @escaping (Router.RouteParam) -> Content) {
        self.router = router
        self.rootPath = .index
        self.rootPage = RoutePage(path: rootPath, builder: builder)
    }
    
    func getRoot() -> some View {
        if let page = rootPage {
            return page
        }
        return router.getPage(path: rootPath, param: [:])
    }
}

extension RouterView: View {
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: $router.pageStack) {
                getRoot()
                    .navigationDestination(for: RoutePage<AnyView>.self) { page in
                        page
                    }
            }.environment(\.router, self.router)
            
        } else {
            NavigationView {
                ZStack {
                    if let currentPage = router.pageStack.last {
                        currentPage
                            .transition(.slide)
                    } else {
                        getRoot()
                    }
                }
                .navigationBarHidden(true)
            }.environment(\.router, self.router)
        }
    }
}

struct RouterPage_Previews: PreviewProvider {
    static var previews: some View {
        RouterView()
        
        RouterView { arg in
            Text("ttmp")
        }
    }
}
