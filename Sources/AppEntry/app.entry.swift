import SwiftUI
import AppService

@main
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct EntryApp: App {
    static let context = ApplicationContext()
    
    @StateObject var context = Self.context
    var body: some Scene {
        WindowGroup {
            Text("entry")
                .padding()
                .onAppear{
                    print("onAppear")
                }
        }
    }
}
