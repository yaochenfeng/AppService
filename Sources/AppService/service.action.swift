import Foundation

public struct ServiceAction {
    let event: String
    let argument: Any
    
    init(event: String, argument: Any) {
        self.event = event
        self.argument = argument
    }
}
