import Foundation


public protocol ServiceStateType {
    associatedtype Action
    typealias Reducer = (_ state: Self, _ action: Action) -> Self
    /// 默认action reducer实现
    static func reducer(state: Self, action: Action) -> Self
}
