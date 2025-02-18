import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func appBackground<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
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
    func appOverlay<T: View>(alignment: Alignment = .center, builder: () -> T) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            return self.overlay(alignment: alignment) {
                builder()
            }
        } else {
            return ZStack {
                self
                ZStack(alignment: alignment){
                    builder()
                }
            }
        }
    }
    func appAny() -> AnyView {
        if let newValue = self as? AnyView {
            return newValue
        }
        return AnyView(self)
    }
}
