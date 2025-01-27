import Foundation

public struct Service<Base> {
    public let base: Base
    private let context: ApplicationContext
    
    public init(_ base: Base, context: ApplicationContext = .shared) {
        self.base = base
        self.context = context
    }
}

public protocol ServiceState: Equatable {
    typealias Reducer = (_ state: Self, _ action: Action) -> Self
    associatedtype Action
}

public protocol ServiceDecode {
    init(_ context: ApplicationContext)
}


func equals(_ x : Any, _ y : Any) -> Bool {
    guard let x = x as? AnyHashable,
          let y = y as? AnyHashable else { return false }
    return x == y
}
