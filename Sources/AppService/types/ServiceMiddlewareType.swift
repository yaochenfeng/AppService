public protocol ServiceMiddlewareType {
    associatedtype State: ServiceStateType

        func process(
            action: State.Action,
            context: MiddlewareContext<State>,
            next: @escaping (State.Action) async -> Void
        ) async
}
public extension ServiceMiddlewareType {
    // 使用类型擦除将具体的 Middleware 转换为 AnyMiddleware
    func asAny() -> AnyMiddleware<State> {
        return AnyMiddleware(self)
    }
}

public final class MiddlewareContext<State: ServiceStateType> {
    private let getState: () -> State
    private let dispatchClosure: (State.Action) async -> Void

    init(getState: @escaping () -> State, dispatch: @escaping (State.Action) async -> Void) {
        self.getState = getState
        self.dispatchClosure = dispatch
    }

    public var state: State {
        getState()  // 🔥 始终返回最新 `State`
    }

    public func dispatch(_ action: State.Action) async {
        await dispatchClosure(action)  // 🔥 允许 Middleware 触发新 `Action`
    }
}
