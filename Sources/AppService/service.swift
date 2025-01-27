import Foundation


public protocol ServiceState: Equatable {
    typealias Reducer = (_ state: Self, _ action: Action) -> Self
    associatedtype Action
}

public protocol ServiceDecode {
    @MainActor
    init(_ context: ApplicationContext)
}


func equals(_ x : Any, _ y : Any) -> Bool {
    guard let x = x as? AnyHashable,
          let y = y as? AnyHashable else { return false }
    return x == y
}
