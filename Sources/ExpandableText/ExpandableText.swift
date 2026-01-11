import SwiftUI

public struct ExpandableText: View {
    @State private(set) var isExpanded: Bool = false
    @State private(set) var isTruncated: Bool = false

    @State private var intrinsicSize: CGSize = .zero
    @State private var truncatedSize: CGSize = .zero
    @State private var moreTextSize: CGSize = .zero

    private let makeText: () -> Text
    internal var font: Font = .body
    internal var color: Color = .primary
    internal var lineLimit: Int = 3
    internal var moreButtonText: String = "more"
    internal var moreButtonFont: Font?
    internal var moreButtonForegroundStyle: AnyShapeStyle = AnyShapeStyle(Color.accentColor)
    internal var expandAnimation: Animation = .default

    private var shouldShowMoreButton: Bool { !isExpanded && isTruncated }

    /// Creates expandable text with markdown support.
    ///
    /// Use this initializer with string literals to render markdown formatting
    /// like **bold**, *italic*, `code`, ~~strikethrough~~, and [links](url).
    ///
    /// - Parameter key: A localized string key that may contain markdown.
    public init(_ key: LocalizedStringKey) {
        self.makeText = { Text(key) }
    }

    /// Creates expandable text with a raw string (no markdown parsing).
    ///
    /// Use this initializer when you have a `String` variable or when you want
    /// to display text without markdown parsing.
    ///
    /// - Parameter content: The string to display verbatim.
    public init(verbatim content: String) {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        self.makeText = { Text(verbatim: trimmed) }
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
            .overlay(alignment: .trailingLastTextBaseline) {
                if shouldShowMoreButton {
                    moreButton
                }
            }
    }

    private var content: some View {
        makeText()
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

    private var moreButtonLabel: some View {
        Text(moreButtonText)
            .font(moreButtonFont ?? font)
            .foregroundStyle(moreButtonForegroundStyle)
    }
}

#if DEBUG
let loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing \
elit, sed do eiusmod tempor incididunt ut labore et \
dolore magna aliqua. Ut enim ad minim veniam, quis \
nostrud exercitation ullamco laboris nisi ut aliquip \
ex ea commodo consequat. Duis aute irure dolor in \
reprehenderit in voluptate velit esse cillum dolore \
eu fugiat nulla pariatur.
"""

#Preview("Default") {
    ExpandableText(verbatim: loremIpsum)
        .padding()
}

#Preview("Markdown") {
    ExpandableText("""
        This is **bold**, *italic*, and ~~strikethrough~~ text. \
        Visit [Apple](https://apple.com) for more. \
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, \
        sed do eiusmod tempor incididunt ut labore.
        """)
    .padding()
}

#Preview("Foreground Style") {
    ExpandableText(verbatim: loremIpsum)
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
    ExpandableText(verbatim: loremIpsum)
        .font(.body)
        .foregroundColor(.primary)
        .lineLimit(3)
        .moreButtonText("Show more")
        .moreButtonFont(.caption.bold())
        .moreButtonForegroundStyle(.blue)
        .expandAnimation(.easeOut)
        .padding()
}
#endif
