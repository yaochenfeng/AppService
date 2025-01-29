import Foundation

public struct LogService: ServiceKey {
    public static var name: String = "app.log"
    let name: String
    
    public init(_ name: String) {
        self.name = name
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
                try self.callAsFunction(method: "log", args: base.name, level, message, file, function, line)
            } catch {
                debugPrint(level, message,function,line)
            }
        }
}
