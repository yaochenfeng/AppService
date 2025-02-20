import SwiftUI

struct AppSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let builder: () -> SheetContent
    func body(content: Content) -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            content
                .sheet(isPresented: $isPresented, content: builder)
                .presentationDetents([.medium, .large])
        } else {
            // Fallback on earlier versions
            content
                .sheet(isPresented: $isPresented, content: builder)
        }
    }
}

public extension View {
    func appSheet<Content: View>(isPresented: Binding<Bool>, height: CGFloat = 400, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(AppSheetModifier(isPresented: isPresented, builder: content))
    }
}
