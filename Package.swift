// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Kwift",
    products: [
        .library(
            name: "Kwift",
            targets: ["KwiftUtility",
                      "Executable",
                      "Compatibility",
                      "SwiftEnhancement",
                      "FoundationEnhancement"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Executable",
            dependencies: []),
        .target(
            name: "Compatibility",
            dependencies: []),
        .target(
            name: "SwiftEnhancement",
            dependencies: []),
        .target(
            name: "FoundationEnhancement",
            dependencies: []),
        .target(
            name: "KwiftUtility",
            dependencies: ["Compatibility"]),
        .testTarget(
            name: "KwiftUtilityTests",
            dependencies: ["KwiftUtility"]),
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
