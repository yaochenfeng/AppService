import Foundation

public enum ServiceError: Error {
    case unimplemented(String = #function)
    case invalidApi(String)
    case notFound(String)
}
