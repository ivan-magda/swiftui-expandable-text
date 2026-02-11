import SwiftUI

// MARK: - ExpandableText Modifiers
extension ExpandableText {
  /// Sets the font for the text content.
  ///
  /// This modifier affects both the main text and the "more" button (unless
  /// ``moreButtonFont(_:)`` is explicitly set).
  ///
  /// ```swift
  /// ExpandableText("Article content here...")
  ///     .font(.system(size: 16, weight: .regular))
  ///
  /// ExpandableText("Quote text...")
  ///     .font(.custom("Georgia", size: 18))
  /// ```
  ///
  /// - Parameter font: The font to apply to the text.
  /// - Returns: An expandable text view with the specified font.
  /// - Note: The default font is `.body`.
  public func font(_ font: Font) -> Self {
    var copy = self
    copy.font = font
    return copy
  }

  /// Sets the foreground color for the text content.
  ///
  /// ```swift
  /// ExpandableText("Important notice...")
  ///     .foregroundStyle(.red)
  ///
  /// ExpandableText("Secondary content...")
  ///     .foregroundStyle(.secondary)
  /// ```
  ///
  /// - Parameter color: The color to apply to the text.
  /// - Returns: An expandable text view with the specified color.
  /// - Note: The default color is `.primary`.
  public func foregroundStyle(_ color: Color) -> Self {
    var copy = self
    copy.color = color
    return copy
  }

  @available(*, deprecated, renamed: "foregroundStyle(_:)")
  public func foregroundColor(_ color: Color) -> Self {
    foregroundStyle(color)
  }

  /// Sets the maximum number of lines when the text is collapsed.
  ///
  /// When the text content exceeds this limit, it will be truncated with a
  /// gradient fade effect and the "more" button will appear.
  ///
  /// ```swift
  /// // Show only 2 lines before truncation
  /// ExpandableText("Long article content...")
  ///     .lineLimit(2)
  ///
  /// // Show 5 lines for more context
  /// ExpandableText("Detailed description...")
  ///     .lineLimit(5)
  /// ```
  ///
  /// - Parameter limit: The maximum number of visible lines when collapsed.
  /// - Returns: An expandable text view with the specified line limit.
  /// - Note: The default line limit is `3`.
  public func lineLimit(_ limit: Int) -> Self {
    var copy = self
    copy.lineLimit = limit
    return copy
  }

  /// Sets the text displayed on the expand button.
  ///
  /// Customize this to match your app's language or tone.
  ///
  /// ```swift
  /// // English
  /// ExpandableText(verbatim: content)
  ///     .moreButtonText("Read more")
  ///
  /// // Localized
  /// ExpandableText(verbatim: content)
  ///     .moreButtonText(NSLocalizedString("show_more", comment: ""))
  /// ```
  ///
  /// - Parameter moreText: The text to display on the button.
  /// - Returns: An expandable text view with the specified button text.
  /// - Note: The default text is `"more"`.
  public func moreButtonText(_ moreText: String) -> Self {
    var copy = self
    copy.moreButtonText = moreText
    return copy
  }

  /// Sets the font for the "more" button.
  ///
  /// Use this to differentiate the button from the main text, such as
  /// making it smaller or bolder.
  ///
  /// ```swift
  /// ExpandableText(verbatim: content)
  ///     .font(.body)
  ///     .moreButtonFont(.caption.bold())
  ///
  /// ExpandableText(verbatim: content)
  ///     .moreButtonFont(.footnote.weight(.semibold))
  /// ```
  ///
  /// - Parameter font: The font to apply to the button.
  /// - Returns: An expandable text view with the specified button font.
  /// - Note: If not set, the button inherits the font from ``font(_:)``.
  public func moreButtonFont(_ font: Font) -> Self {
    var copy = self
    copy.moreButtonFont = font
    return copy
  }

  /// Sets the foreground style for the "more" button.
  ///
  /// This modifier accepts any `ShapeStyle`, allowing colors, gradients,
  /// or other styles to be applied to the button.
  ///
  /// ```swift
  /// // Solid color
  /// ExpandableText(verbatim: content)
  ///     .moreButtonForegroundStyle(.blue)
  ///
  /// // Gradient
  /// ExpandableText(verbatim: content)
  ///     .moreButtonForegroundStyle(
  ///         .linearGradient(
  ///             colors: [.purple, .pink],
  ///             startPoint: .leading,
  ///             endPoint: .trailing
  ///         )
  ///     )
  /// ```
  ///
  /// - Parameter style: The shape style to apply to the button.
  /// - Returns: An expandable text view with the specified button style.
  /// - Note: The default style is `.accentColor`.
  public func moreButtonForegroundStyle<S: ShapeStyle>(_ style: S) -> Self {
    var copy = self
    copy.moreButtonForegroundStyle = AnyShapeStyle(style)
    return copy
  }

  /// Sets the animation used when expanding the text.
  ///
  /// The animation is applied when the user taps the "more" button to
  /// reveal the full content.
  ///
  /// ```swift
  /// // Smooth ease-out
  /// ExpandableText(verbatim: content)
  ///     .expandAnimation(.easeOut)
  ///
  /// // Custom spring
  /// ExpandableText(verbatim: content)
  ///     .expandAnimation(.spring(response: 0.4, dampingFraction: 0.8))
  ///
  /// // Slow reveal
  /// ExpandableText(verbatim: content)
  ///     .expandAnimation(.easeInOut(duration: 0.5))
  /// ```
  ///
  /// - Parameter animation: The animation to use for the expansion.
  /// - Returns: An expandable text view with the specified animation.
  /// - Note: The default animation is `.default`.
  public func expandAnimation(_ animation: Animation) -> Self {
    var copy = self
    copy.expandAnimation = animation
    return copy
  }
}
