import Foundation
import SwiftUI

public struct ExpandableText: View {
    @State private var isExpanded: Bool = false
    @State private var isTruncated: Bool = false

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
    internal var expandAnimation: Animation = .default
    internal var trimMultipleNewlinesWhenTruncated: Bool = true

    private var shouldShowMoreButton: Bool { !isExpanded && isTruncated }

    private var textTrimmingDoubleNewlines: String {
        text.replacingOccurrences(of: #"\n\s*\n"#, with: "\n", options: .regularExpression)
    }

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
            .overlayCompatibility(alignment: .trailingLastTextBaseline) {
                if shouldShowMoreButton {
                    Button(
                        action: {
                            withAnimation(expandAnimation) {
                                isExpanded.toggle()
                            }
                        },
                        label: {
                            Text(moreButtonText)
                                .font(moreButtonFont ?? font)
                                .foregroundColor(moreButtonColor)
                        }
                    )
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
}
