import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func availableBackground<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            self.background(alignment: alignment, content: content)
        } else {
            // Fallback on earlier versions
            ZStack(alignment: alignment) {
                content()
                self
            }
        }
    }
}
