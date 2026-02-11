import Testing
import SwiftUI
@testable import ExpandableText

@MainActor
@Suite("ExpandableText")
struct ExpandableTextTests {

    @MainActor
    @Suite("Initialization")
    struct Initialization {

        @Test("Default property values")
        func defaults() {
            let sut = ExpandableText(verbatim: "Test text")
            #expect(sut.font == .body)
            #expect(sut.color == .primary)
            #expect(sut.lineLimit == 3)
            #expect(sut.moreButtonText == "more")
            #expect(sut.moreButtonFont == nil)
        }

        @Test("LocalizedStringKey initializer constructs without error")
        func localizedStringKey() {
            let sut = ExpandableText("**bold** text")
            #expect(sut.font == .body)
        }

        @Test("Verbatim initializer constructs without error")
        func verbatim() {
            let sut = ExpandableText(verbatim: "Some **text** with asterisks")
            #expect(sut.font == .body)
        }

        @Test("Empty and whitespace-only strings construct without error")
        func emptyStrings() {
            _ = ExpandableText(verbatim: "")
            _ = ExpandableText(verbatim: "   \n  ")
        }
    }

    @MainActor
    @Suite("Modifiers")
    struct Modifiers {

        @Test("lineLimit sets the maximum collapsed lines")
        func lineLimit() {
            let sut = ExpandableText(verbatim: "Test")
                .lineLimit(5)
            #expect(sut.lineLimit == 5)
        }

        @Test("moreButtonFont defaults to nil and can be set")
        func moreButtonFont() {
            let sut = ExpandableText(verbatim: "Test")
            #expect(sut.moreButtonFont == nil)

            let modified = sut.moreButtonFont(.caption)
            #expect(modified.moreButtonFont == .caption)
        }

        // Animation is not Equatable — smoke test only to verify the modifier
        // accepts a value and returns without error.
        @Test("expandAnimation accepts custom animation")
        func expandAnimation() {
            _ = ExpandableText(verbatim: "Test")
                .expandAnimation(.easeInOut(duration: 0.5))
        }

        // AnyShapeStyle is not Equatable — smoke test only to verify the modifier
        // accepts a value and returns without error.
        @Test("moreButtonForegroundStyle accepts a ShapeStyle")
        func moreButtonForegroundStyle() {
            _ = ExpandableText(verbatim: "Test")
                .moreButtonForegroundStyle(.tint)
        }

        @Test("Deprecated foregroundColor forwards to foregroundStyle")
        func deprecatedForegroundColor() {
            let sut = ExpandableText(verbatim: "Test")
                .foregroundColor(.red)
            #expect(sut.color == .red)
        }

        @Test("Modifiers use value semantics — original is unchanged")
        func valueSemantics() {
            let original = ExpandableText(verbatim: "Test")
            let modified = original.font(.title).foregroundStyle(.red).lineLimit(5)

            #expect(original.font == .body)
            #expect(original.color == .primary)
            #expect(original.lineLimit == 3)

            #expect(modified.font == .title)
            #expect(modified.color == .red)
            #expect(modified.lineLimit == 5)
        }

        @Test("Modifier chaining order does not affect final values")
        func chainingOrder() {
            let a = ExpandableText(verbatim: "Test")
                .font(.title)
                .lineLimit(5)
                .moreButtonText("Read more")

            let b = ExpandableText(verbatim: "Test")
                .moreButtonText("Read more")
                .lineLimit(5)
                .font(.title)

            #expect(a.font == b.font)
            #expect(a.lineLimit == b.lineLimit)
            #expect(a.moreButtonText == b.moreButtonText)
        }
    }
}
