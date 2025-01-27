import Foundation

public struct LogService: ServiceKey {
    
    let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    static let logger = LogService("AppService")
    public enum Level: String, Codable, CaseIterable, CustomStringConvertible {
        public var description: String {
            return rawValue
        }
        
            case trace
            case debug
            case info
            case warn
            case error
        }
}


public extension Service where Base == LogService {
    static func debug(
            _ message: @autoclosure () -> String,
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line
        ) {
            self.log(level: .debug, message: message(), file: file, function: function, line: line)
        }
    static func info(
            _ message: @autoclosure () -> String,
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line
        ) {
            self.log(level: .info, message: message(), file: file, function: function, line: line)
        }
    
    static func log(
            level: LogService.Level,
            message: String,
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line
        ) {
            _ = try? Base.logger.app.getContext(api: Base.name, args: message)
            debugPrint(level, message,file,function,line)
        }
}
