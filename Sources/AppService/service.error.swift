import Foundation

public enum ServiceError: Error {
    case unimplemented(String = #function)
}
