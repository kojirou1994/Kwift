// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Kwift",
    products: [
        .library(
            name: "Kwift",
            targets: ["Kwift"]),
        .library(
            name: "Executable",
            targets: ["Executable"]),
        .library(
            name: "KwiftUtility",
            targets: ["KwiftUtility"]),
        .library(
            name: "SwiftEnhancement",
            targets: ["SwiftEnhancement"]),
        .library(
            name: "FoundationEnhancement",
            targets: ["FoundationEnhancement"]),
        .library(
            name: "Compatibility",
            targets: ["Compatibility"])
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
        .target(
            name: "Kwift",
            dependencies: [
                "KwiftUtility",
                "Compatibility",
                "SwiftEnhancement",
                "FoundationEnhancement"]),
        .testTarget(
            name: "ExecutableTests",
            dependencies: ["Executable"]),
        .testTarget(
            name: "SwiftEnhancementTests",
            dependencies: ["SwiftEnhancement"]),
        .testTarget(
            name: "KwiftUtilityTests",
            dependencies: ["KwiftUtility"]),
    ],
    swiftLanguageVersions: [.v5]
)
