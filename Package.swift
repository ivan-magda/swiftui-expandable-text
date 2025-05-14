// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ExpandableText",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7)
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
