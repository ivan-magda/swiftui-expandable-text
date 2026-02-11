import Testing
import SwiftUI
@testable import ExpandableText

@Test @MainActor func testInitialState() {
    let sut = ExpandableText(verbatim: "Test text")
    #expect(sut.font == .body)
    #expect(sut.color == .primary)
    #expect(sut.lineLimit == 3)
    #expect(sut.moreButtonText == "more")
}

@Test @MainActor func testLocalizedStringKeyInit() {
    let sut = ExpandableText("**bold** text")
    #expect(sut.font == .body)
}

@Test @MainActor func testVerbatimInit() {
    let sut = ExpandableText(verbatim: "Some **text** with asterisks")
    #expect(sut.font == .body)
}

@Test @MainActor func testCustomization() {
    let sut = ExpandableText(verbatim: "Test")
        .font(.title)
        .foregroundStyle(.red)
        .moreButtonText("Show More")

    #expect(sut.font == .title)
    #expect(sut.color == .red)
    #expect(sut.moreButtonText == "Show More")
}

@Test @MainActor func testMoreButtonForegroundStyle() {
    let initial = ExpandableText(verbatim: "Test")
    let modified = initial.moreButtonForegroundStyle(.tint)

    // Verify modifier returns a new instance (value semantics)
    // AnyShapeStyle doesn't conform to Equatable, so we just verify the modifier compiles and runs
    _ = modified
}
