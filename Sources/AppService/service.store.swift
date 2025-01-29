import Foundation

public final class ServiceStore<State: ServiceState>: ObservableObject {
    
    @Published
    public private(set) var state: State
    private var reducers: [Reducer] = []
    init(_ state: State, reducers: [Reducer] = []) {
        self.state = state
        self.reducers = reducers
    }
    
    
    
    struct Reducer {
        var reduce: (State, State.Action) -> State
        init(_ handler: @escaping (State, State.Action) -> State) {
            self.reduce = handler
        }

        func callAsFunction(_ state: State, _ action: State.Action) -> State {
            return self.reduce(state, action)
        }
    }
}


public extension ServiceStore {
    
    @MainActor
    func dispatch(_ action: State.Action, forceUpdate: Bool = false) {
        let newState = reducers.reduce(state, { partialResult, reducer in
            return reducer(partialResult, action)
        })
        if forceUpdate || newState != state {
            self.state = newState
        }
    }
    
    func add(_ reducer: @escaping State.Reducer) {
        self.reducers.append(.init(reducer))
    }
}
