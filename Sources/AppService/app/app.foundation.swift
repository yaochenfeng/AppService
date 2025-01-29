import Foundation

public extension Service where Base == Bundle {
    var bundleName: String? {
        return value("CFBundleName")
    }
    var launchStoryboard: String? {
        return value("UILaunchStoryboardName")
    }
    
    var version: String? {
        return value("CFBundleShortVersionString")
    }
    
    var bundleVersion: String? {
        return value("CFBundleVersion")
    }
    
    var bundleIdentifier: String? {
        return value("CFBundleIdentifier")
    }
    
    func value<T>(_ key: String) -> T? {
        return base.infoDictionary?[key] as? T
    }
    
    static var version: String {
        return Bundle.main.app.version ?? "unkown"
    }
    
    static var bundleVersion: String {
        return Bundle.main.app.bundleVersion ?? "unkown"
    }
    
    static var bundleIdentifier: String {
        return Bundle.main.app.bundleIdentifier ?? "unkown"
    }
}


public extension Service where Base: AnyObject {
    @discardableResult
    func chain(_ block: (Base) throws -> Void) rethrows -> Service<Base> {
        try block(base)
        return self
    }
    @discardableResult
    func then(_ block: (Base) throws -> Void) rethrows -> Base {
        try block(self.base)
        return self.base
    }
}
