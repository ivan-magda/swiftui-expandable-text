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

@Test @MainActor func testMoreButtonForegroundStyle() {
    if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
        let sut = ExpandableText("Test")
            .moreButtonForegroundStyle(.tint)

        #expect(sut.moreButtonForegroundStyle != nil)
    }
}
