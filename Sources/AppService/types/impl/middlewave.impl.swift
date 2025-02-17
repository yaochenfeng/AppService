public struct LoggingMiddleware<State: ServiceStateType>: ServiceMiddlewareType {
    public init() {}

    public func process(
        action: State.Action,
        context: MiddlewareContext<State>,
        next: @escaping (State.Action) async -> Void
    ) async {
        print("[Middleware] Before Action: \(action), State: \(context.state)")
        await next(action) // 继续下一个 Middleware
        print("[Middleware] After Action: \(action), State: \(context.state)")
    }
}

public struct AnyMiddleware<State: ServiceStateType>: ServiceMiddlewareType {
    private let _process: (State.Action, MiddlewareContext<State>, @escaping (State.Action) async -> Void) async -> Void

    public init<M: ServiceMiddlewareType>(_ middleware: M) where M.State == State {
        // 通过 `middleware.process` 生成统一的处理闭包
        self._process = { action, context, next in
            await middleware.process(action: action, context: context, next: next)
        }
    }

    public func process(action: State.Action,
                        context: MiddlewareContext<State>,
                        next: @escaping (State.Action) async -> Void) async {
        // 调用封装的处理逻辑
        await _process(action, context, next)
    }
}
