// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ExpandableText",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "ExpandableText",
            targets: ["ExpandableText"]
        )
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
