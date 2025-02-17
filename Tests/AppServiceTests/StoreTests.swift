//
//  StoreTests.swift
//  
//
//  Created by yaochenfeng on 2025/1/26.
//

import XCTest
import Combine
@testable import AppService

struct TestState: ServiceStateType {
    static func reducer(state: TestState, action: Action) -> TestState {
        switch action {
            
        case .load(let newState):
            return newState
        case .mock(let newState):
            return newState
        case .agreePrvacy(let value):
            var newState = state
            newState.isAgreePravicy = value
            return newState
        }
    }
    
    
    var isLogin: Bool
    var isAgreePravicy: Bool
    
    enum Action {
        case load(TestState)
        case mock(TestState)
        case agreePrvacy(Bool)
    }
}


final class StoreTests: XCTestCase {
    let store = ServiceStore<TestState>(TestState(isLogin: false, isAgreePravicy: false), middlewares: [LoggingMiddleware().asAny()])
    let cacheState = TestState(isLogin: true, isAgreePravicy: true)
    let mockState = TestState(isLogin: false, isAgreePravicy: true)
    var cacelSet = [AnyCancellable]()
    
    @MainActor
    override func setUp() {
        super.setUp()
        
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testLoad() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        await store.dispatch(.load(cacheState))
        assert(store.state.isLogin)
    }
    
    @MainActor
    func testPrivacyAgree() async throws {
        var count = 0
        store.$state.map(\.isAgreePravicy)
            .sink { value in
                count += 1
                print("isAgreePravicy",value)
            }.store(in: &cacelSet)
        await store.dispatch(.agreePrvacy(false))
        assert(!store.state.isAgreePravicy)
        await store.dispatch(.agreePrvacy(true))
        assert(store.state.isAgreePravicy)
        assert(count == 3)
        await store.dispatch(.agreePrvacy(true))
        assert(store.state.isAgreePravicy)
        assert(count == 4)
//        store.dispatch(.agreePrvacy(true), forceUpdate: true)
//        assert(count == 5)
    }
    
    @MainActor
    func testMock() throws {
        store.dispatch(.mock(mockState))
//        assert(store.state == mockState)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
