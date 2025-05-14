import Testing
import SwiftUI
@testable import ExpandableText

@Test @MainActor func testInitialState() {
    let text = "Test text"
    let sut = ExpandableText(text)
    #expect(sut.isExpanded == false)
    #expect(sut.isTruncated == false)
}

@Test @MainActor func testCustomization() {
    let sut = ExpandableText("Test")
        .font(.title)
        .foregroundColor(.red)
        .moreButtonText("Show More")

    #expect(sut.font == .title)
    #expect(sut.color == .red)
    #expect(sut.moreButtonText == "Show More")
}
