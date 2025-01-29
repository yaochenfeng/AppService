import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit

extension Service: View where Base: UIView {
    
}

extension Service: UIViewRepresentable where Base: UIView {
    public func makeUIView(context: Context) -> Base {
        return base
    }
    
    public func updateUIView(_ uiView: Base, context: Context) {}
    
    public typealias UIViewType = Base
}
#elseif canImport(AppKit)
import AppKit

extension Service: View where Base: NSView {}

extension Service: NSViewRepresentable where Base: NSView {
    public func makeNSView(context: Context) -> Base {
        return base
    }
    
    public func updateNSView(_ nsView: Base, context: Context) {}
    
    public typealias NSViewType = Base
}
#endif


