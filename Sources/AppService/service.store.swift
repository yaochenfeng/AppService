import Foundation

public final class ServiceStore<State: ServiceState>: ObservableObject {
    
    @Published
    public private(set) var state: State
    private var reducer: Reducer
    public init(_ state: State, reducer: @escaping State.Reducer = {state,_ in state }) {
        self.state = state
        self.reducer = Reducer(reducer)
    }
    
    
    
}
extension ServiceStore {
    // `Reducer` 结构，支持单个或组合多个 Reducer
    struct Reducer {
        private let reduce: (State, State.Action) -> State
        
        public init(_ handler: @escaping (State, State.Action) -> State) {
            self.reduce = handler
        }
        
        /// 调用 `Reducer`
        func callAsFunction(_ state: State, _ action: State.Action) -> State {
            return self.reduce(state, action)
        }
        
        /// 组合多个 `Reducer`
        static func combine(_ reducers: [Reducer]) -> Reducer {
            Reducer { state, action in
                reducers.reduce(state) { $1.reduce($0, action) }
            }
        }
        
        /// 空 `Reducer`（默认值）
        public static var empty: Reducer {
            Reducer { state, _ in state }
        }
    }
}

public extension ServiceStore {
    /// 触发 `Action` 并更新 `State`
    @MainActor
    func dispatch(_ action: State.Action, forceUpdate: Bool = false) where State: Equatable {
        let newState = reducer(state, action)
        if forceUpdate || newState != state {
            state = newState
        }
    }
    /// 触发 `Action` 并更新 `State`
    @MainActor
    func dispatch(_ action: State.Action) {
        state = reducer(state, action)
    }
    
    
    
    /// 设置新的 `Reducer`
    func setReducer(_ reducer: @escaping State.Reducer) {
        self.reducer = Reducer(reducer)
    }
}
