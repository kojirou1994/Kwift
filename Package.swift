// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Kwift",
    products: [
        .library(
            name: "Kwift",
            targets: ["KwiftUtility", "KwiftExtension"]),
        .library(
            name: "Executable",
            targets: ["Executable"]),
        .library(
            name: "KwiftUtility",
            targets: ["KwiftUtility"]),
        .library(
            name: "KwiftExtension",
            targets: ["KwiftExtension"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Executable",
            dependencies: []),
        .target(
            name: "KwiftExtension",
            dependencies: []),
        .target(
            name: "KwiftUtility",
            dependencies: ["KwiftExtension"]),
        .testTarget(
            name: "ExecutableTests",
            dependencies: ["Executable"]),
        .testTarget(
            name: "KwiftExtensionTests",
            dependencies: ["KwiftExtension"]),
        .testTarget(
            name: "KwiftUtilityTests",
            dependencies: ["KwiftUtility"]),
    ],
    swiftLanguageVersions: [.v5]
)
