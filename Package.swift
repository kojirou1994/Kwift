// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Kwift",
    products: [
        .library(
            name: "Kwift",
            targets: ["Kwift"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Kwift",
            dependencies: []),
        .testTarget(
            name: "KwiftTests",
            dependencies: ["Kwift"]),
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
