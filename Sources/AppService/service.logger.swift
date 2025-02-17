import Foundation

public struct LogService: ServiceKey {
    public static let main = LogService("main").app
    public static let name: String = "app.log"
    let category: String
    
    public init(_ category: String) {
        self.category = category
    }
    
    static let logger = LogService("AppService").app
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
    
    public struct Argument {
        public let name: String
        public let level: Level
        public let message: String
        public let file: String
        public let function: String
        public let line: UInt
    }
}


public extension Service where Base == LogService {
    func debug(
            _ message: @autoclosure () -> String,
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line
        ) {
            self.log(level: .debug, message: message(), file: file, function: function, line: line)
        }
    func info(
            _ message: @autoclosure () -> String,
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line
        ) {
            self.log(level: .info, message: message(), file: file, function: function, line: line)
        }
    
    func log(
            level: LogService.Level,
            message: String,
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line
        ) {
            do {
                let argument = LogService.Argument(name: base.category, level: level, message: message, file: file, function: function, line: line)
                try self.callAsFunction(method: "log", arg: argument)
            } catch {
                debugPrint(level, message,function,line)
            }
        }
}
