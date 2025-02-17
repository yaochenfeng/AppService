import Foundation

public final class ServiceStore<State: ServiceStateType>: ObservableObject {
    
    @Published
    public private(set) var state: State
    private var reducer: State.Reducer
    private let middlewares: [AnyMiddleware<State>]
    
    public init(_ state: State,
                reducer: @escaping State.Reducer = State.reducer,
                middlewares: [AnyMiddleware<State>] = []) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }
}

extension ServiceStore {
    
    /// 触发 `Action` 并更新 `State`
    @MainActor
    public func dispatch(_ action: State.Action) {
        Task {
            await dispatchInner(action)
        }
    }
    
    public func dispatch(_ action: State.Action) async {
        await dispatchInner(action)
    }

    /// `Middleware` 处理逻辑
    private func dispatchInner(_ action: State.Action) async {
        var middlewareIndex = 0

        weak var weakSelf = self
        let context = MiddlewareContext(
            getState: { self.state },   // 让 Middleware 获取最新 `state`
            dispatch: { action in  // 使用 weak self 避免强引用
                await weakSelf?.dispatch(action)
            }
        )

        // 使用 weak self 防止强引用循环
        func next(_ newAction: State.Action) async {
            guard let self = weakSelf else { return }  // 如果 self 已释放，退出
            if middlewareIndex < self.middlewares.count {
                let middleware = self.middlewares[middlewareIndex]
                middlewareIndex += 1
                await middleware.process(
                    action: newAction,
                    context: context,
                    next: next
                )
            } else {
                await MainActor.run {
                    self.state = self.reducer(self.state, newAction)
                }
            }
        }

        await next(action)
    }

    /// 设置新的 `Reducer`
    public func setReducer(_ reducer: @escaping State.Reducer) {
        self.reducer = reducer
    }
}
