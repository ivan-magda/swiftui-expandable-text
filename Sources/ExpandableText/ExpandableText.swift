import Foundation
import SwiftUI

public struct ExpandableText: View {
    @State private(set) var isExpanded: Bool = false
    @State private(set) var isTruncated: Bool = false

    @State private var intrinsicSize: CGSize = .zero
    @State private var truncatedSize: CGSize = .zero
    @State private var moreTextSize: CGSize = .zero

    private let text: String
    internal var font: Font = .body
    internal var color: Color = .primary
    internal var lineLimit: Int = 3
    internal var moreButtonText: String = "more"
    internal var moreButtonFont: Font?
    internal var moreButtonColor: Color = .accentColor
    internal var moreButtonForegroundStyle: Any?
    internal var expandAnimation: Animation = .default
    internal var trimMultipleNewlinesWhenTruncated: Bool = true

    private var shouldShowMoreButton: Bool { !isExpanded && isTruncated }

    public init(_ text: String) {
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var body: some View {
        content
            .lineLimit(isExpanded ? nil : lineLimit)
            .applyingTruncationMask(size: moreTextSize, isEnabled: shouldShowMoreButton)
            .readSize { size in
                truncatedSize = size
                isTruncated = truncatedSize != intrinsicSize
            }
            .background(
                content
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .readSize { size in
                        intrinsicSize = size
                        isTruncated = truncatedSize != intrinsicSize
                    }
            )
            .background(
                Text(moreButtonText)
                    .font(moreButtonFont ?? font)
                    .hidden()
                    .readSize { moreTextSize = $0 }
            )
            .allowsHitTesting(false)
            .overlayCompatibility(alignment: .trailingLastTextBaseline) {
                if shouldShowMoreButton {
                    moreButton
                }
            }
    }

    private var content: some View {
        Text(
            trimMultipleNewlinesWhenTruncated
            ? (shouldShowMoreButton ? textTrimmingDoubleNewlines : text)
            : text
        )
        .font(font)
        .foregroundColor(color)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var moreButton: some View {
        Button(
            action: {
                withAnimation(expandAnimation) {
                    isExpanded.toggle()
                }
            },
            label: { moreButtonLabel }
        )
        .contentShape(Rectangle())
        .accessibilityLabel("Show more text")
        .accessibilityHint("Expands the text to show its full content")
    }

    @ViewBuilder
    private var moreButtonLabel: some View {
        let text = Text(moreButtonText)
            .font(moreButtonFont ?? font)

        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *),
           let foregroundStyle = moreButtonForegroundStyle as? AnyShapeStyle {
            text
                .foregroundStyle(foregroundStyle)
        } else {
            text
                .foregroundColor(moreButtonColor)
        }
    }
}

// MARK: Trimming newlines

extension ExpandableText {
    // swiftlint:disable:next force_try
    private static let newlinesRegex = try! NSRegularExpression(pattern: #"\n\s*\n"#)

    private var textTrimmingDoubleNewlines: String {
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        return Self.newlinesRegex.stringByReplacingMatches(
            in: text,
            range: range,
            withTemplate: "\n"
        )
    }
}

#if DEBUG
let loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing
elit, sed do eiusmod tempor incididunt ut labore et
dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip
ex ea commodo consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore
eu fugiat nulla pariatur.
"""

#Preview("Default") {
    ExpandableText(
        loremIpsum
    )
    .padding()
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview("Foreground Style") {
    ExpandableText(
        loremIpsum
    )
    .moreButtonForegroundStyle(
        .linearGradient(
            colors: [.red, .blue],
            startPoint: .top,
            endPoint: .bottom
        )
    )
    .padding()
}

#Preview("Customization") {
    ExpandableText(
        loremIpsum
    )
    .font(.body)
    .foregroundColor(.primary)
    .lineLimit(3)
    .moreButtonText("Show more")
    .moreButtonFont(.caption.bold())
    .moreButtonColor(.blue)
    .expandAnimation(.easeOut)
    .padding()
}
#endif
