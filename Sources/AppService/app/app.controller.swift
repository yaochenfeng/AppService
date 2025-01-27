import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
public typealias SwiftController = UIViewController
public extension Service where Base: SwiftController {
    static var launch: SwiftController? {
        guard let name = Bundle.main.app.launchStoryboard else { return nil }
        return UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
    }
    
    var host: some View {
        return HostController(base)
    }
}
public struct HostController<Base: SwiftController>: UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> Base {
        return base
    }
    
    public func updateUIViewController(_ uiViewController: Base, context: Context) {}
    
    public typealias UIViewControllerType = Base
    
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
#elseif canImport(AppKit)
import AppKit
public typealias SwiftController = NSViewController

public extension Service where Base: SwiftController {
    static var launch: SwiftController? {
        return nil
    }
    var host: some View {
        return HostController(base)
    }
}
public struct HostController<Base: SwiftController>: NSViewControllerRepresentable {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
    public func makeNSViewController(context: Context) -> Base {
        return base
    }
    
    public func updateNSViewController(_ nsViewController: Base, context: Context) {}
    
    public typealias NSViewControllerType = Base
    
}
#else
public class SwiftController: NSObject {
    
}

public struct HostController<Base: SwiftController>: View {
    public var body: Never {
        fatalError()
    }
    
    public typealias Body = Never
    
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
#endif


