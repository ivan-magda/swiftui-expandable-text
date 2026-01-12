// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ExpandableText",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "ExpandableText",
            targets: ["ExpandableText"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "ExpandableText"
        ),
        .testTarget(
            name: "ExpandableTextTests",
            dependencies: ["ExpandableText"]
        )
    ]
)
