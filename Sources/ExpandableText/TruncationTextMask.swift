import SwiftUI

private struct TruncationTextMask: ViewModifier {
    let size: CGSize

    let isEnabled: Bool

    @Environment(\.layoutDirection) private var layoutDirection

    func body(content: Content) -> some View {
        if isEnabled {
            content
                .mask(
                    VStack(spacing: 0) {
                        Rectangle()
                        HStack(spacing: 0) {
                            Rectangle()
                            HStack(spacing: 0) {
                                LinearGradient(
                                    gradient: Gradient(
                                        stops: [
                                            Gradient.Stop(color: .black, location: 0),
                                            Gradient.Stop(color: .clear, location: 0.9)
                                        ]
                                    ),
                                    startPoint: layoutDirection == .rightToLeft ? .trailing : .leading,
                                    endPoint: layoutDirection == .rightToLeft ? .leading : .trailing
                                )
                                .frame(width: size.width, height: size.height)

                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .frame(width: size.width)
                            }
                        }
                        .frame(height: size.height)
                    } else {
                        Rectangle()
                            .frame(height: size.height)
                    }
                }
            )
    }
}

internal extension View {
    func applyingTruncationMask(size: CGSize, isEnabled: Bool) -> some View {
        modifier(TruncationTextMask(size: size, isEnabled: isEnabled))
    }
}
