import Foundation
import SwiftUI

extension Service: View where Base: View {
    public var body: Base {
        return base
    }
    public func asAnyView() -> AnyView {
        return AnyView(base)
    }
}

public extension View {
    var app: Service<Self> {
        return Service(self)
    }
}
//
//#if canImport(UIKit)
//import UIKit
//
//extension Service: View where Base: UIView {
//}
//
//extension Service: UIViewRepresentable where Base: UIView {
//    public func makeUIView(context: Context) -> Base {
//        return base
//    }
//
//    public func updateUIView(_ uiView: Base, context: Context) {}
//
//    public typealias UIViewType = Base
//}
//#elseif canImport(AppKit)
//import AppKit
//
//extension Service: NSViewRepresentable where Base: NSView {
//    public func makeNSView(context: Context) -> Base {
//        return base
//    }
//
//    public func updateNSView(_ nsView: Base, context: Context) {}
//
//    public typealias NSViewType = Base
//}
//#endif
//
//
