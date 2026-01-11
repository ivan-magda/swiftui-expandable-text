import Testing
import SwiftUI
@testable import ExpandableText

@Test @MainActor func testInitialState() {
    let sut = ExpandableText(verbatim: "Test text")
    #expect(sut.isExpanded == false)
    #expect(sut.isTruncated == false)
}

@Test @MainActor func testLocalizedStringKeyInit() {
    let sut = ExpandableText("**bold** text")
    #expect(sut.isExpanded == false)
    #expect(sut.isTruncated == false)
}

@Test @MainActor func testVerbatimInit() {
    let text = "Some **text** with asterisks"
    let sut = ExpandableText(verbatim: text)
    #expect(sut.isExpanded == false)
    #expect(sut.isTruncated == false)
}

@Test @MainActor func testCustomization() {
    let sut = ExpandableText(verbatim: "Test")
        .font(.title)
        .foregroundColor(.red)
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
