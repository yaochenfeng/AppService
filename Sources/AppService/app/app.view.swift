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
#if canImport(AppKit)
import AppKit
public extension Service where Base: NSView {
    func asView() -> some View {
        PlatformView<Base>(base)
    }
}
struct PlatformView<T: NSView>: NSViewRepresentable {
    func makeNSView(context: Context) -> T {
        return base
    }
    
    func updateNSView(_ nsView: T, context: Context) {
        
    }
    
    typealias NSViewType = T
    
    
    let base: T
    init(_ base: T) {
        self.base = base
    }
}
#endif
