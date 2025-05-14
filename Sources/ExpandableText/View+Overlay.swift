import SwiftUI

internal extension View {
    @ViewBuilder
    func overlayCompatibility<Content: View>(
        alignment: Alignment,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, *) {
            overlay(alignment: alignment, content: content)
        } else {
            overlay(content(), alignment: alignment)
        }
    }
}
