
public class ApplicationContext {
    public init() {
        
    }
    public var modules: [ServiceModule] = []
    #if canImport(Combine)
    @Published
    public var state: [String: Any] = [:]
    #else
    public var state: [String: Any] = [:]
    #endif
}
#if canImport(Combine)
import Combine
extension ApplicationContext: ObservableObject {}
#endif

