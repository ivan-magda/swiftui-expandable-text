import SwiftUI

/// A SwiftUI view that displays text with automatic truncation and an expandable "show more" button.
///
/// `ExpandableText` provides a convenient way to display long text content that can be
/// collapsed to a specified number of lines with a smooth gradient fade effect. When the
/// text is truncated, a customizable "more" button appears allowing users to expand the
/// full content.
///
/// Use `ExpandableText` when you need to display potentially long text content in a
/// compact space, such as article previews, comments, or product descriptions.
///
/// The view exposes read-only `isExpanded` and `isTruncated` state properties
/// that you can observe to react to state changes.
///
/// ```swift
/// struct ArticlePreview: View {
///     let article: Article
///
///     var body: some View {
///         VStack(alignment: .leading) {
///             Text(article.title)
///                 .font(.headline)
///
///             ExpandableText(verbatim: article.body)
///                 .font(.body)
///                 .lineLimit(3)
///                 .moreButtonText("Read more")
///                 .moreButtonForegroundStyle(.blue)
///         }
///     }
/// }
/// ```
public struct ExpandableText: View {
    /// A Boolean value indicating whether the text is currently expanded.
    ///
    /// This property is `true` when the user has tapped the "more" button to
    /// reveal the full text content, and `false` when the text is collapsed.
    ///
    /// - Note: This is a read-only state managed internally by the view.
    @State private(set) var isExpanded: Bool = false

    /// A Boolean value indicating whether the text content exceeds the line limit.
    ///
    /// This property is `true` when the full text content requires more lines
    /// than specified by ``lineLimit(_:)``, causing truncation. The "more" button
    /// only appears when this value is `true`.
    ///
    /// - Note: This is a read-only state managed internally by the view.
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
    /// Use this initializer with string literals to render markdown formatting.
    /// Supported markdown syntax includes:
    /// - **Bold**: `**text**` or `__text__`
    /// - *Italic*: `*text*` or `_text_`
    /// - ~~Strikethrough~~: `~~text~~`
    /// - Code: surround with backticks
    /// - [Links](url): `[text](url)`
    ///
    /// ```swift
    /// // Markdown formatting is automatically rendered
    /// ExpandableText("This is **bold** and *italic* text with a [link](https://example.com).")
    ///     .lineLimit(2)
    ///
    /// // Using localized strings
    /// ExpandableText("welcome_message")  // Loads from Localizable.strings
    /// ```
    ///
    /// - Parameter key: A localized string key that may contain markdown.
    ///
    /// - Note: When using string variables instead of literals, use ``init(verbatim:)``
    ///   to avoid unexpected markdown parsing.
    public init(_ key: LocalizedStringKey) {
        self.makeText = { Text(key) }
    }

    /// Creates expandable text with a raw string without markdown parsing.
    ///
    /// Use this initializer when you have a `String` variable or when you want
    /// to display text exactly as provided without any markdown interpretation.
    /// Leading and trailing whitespace is automatically trimmed.
    ///
    /// ```swift
    /// // Display user-generated content without markdown parsing
    /// let userComment = fetchUserComment()
    /// ExpandableText(verbatim: userComment)
    ///     .lineLimit(3)
    ///     .moreButtonText("Show more")
    ///
    /// // Text with asterisks displayed literally, not as markdown
    /// ExpandableText(verbatim: "Use **double asterisks** for emphasis")
    /// // Displays: Use **double asterisks** for emphasis
    /// ```
    ///
    /// - Parameter content: The string to display verbatim.
    ///
    /// - Note: Use ``init(_:)`` instead if you want markdown formatting to be rendered.
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
                        if intrinsicSize != size {
                            intrinsicSize = size
                        }
                    }
            )
            .background(
                Text(moreButtonText)
                    .font(moreButtonFont ?? font)
                    .hidden()
                    .readSize { size in
                        if moreTextSize != size {
                            moreTextSize = size
                        }
                    }
            )
            .allowsHitTesting(!shouldShowMoreButton)
            .overlay(alignment: .trailingLastTextBaseline) {
                if shouldShowMoreButton {
                    moreButton
                        .transition(.opacity)
                }
            }
    }

    private var content: some View {
        textContent.text
            .font(font)
            .foregroundStyle(color)
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
        .foregroundStyle(.primary)
        .lineLimit(3)
        .moreButtonText("Show more")
        .moreButtonFont(.caption.bold())
        .moreButtonForegroundStyle(.blue)
        .expandAnimation(.easeOut)
        .padding()
}
#endif
