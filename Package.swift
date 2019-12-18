// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Kwift",
    products: [
        .library(
            name: "Kwift",
            targets: ["KwiftUtility", "KwiftExtension"]),
        .library(
            name: "KwiftUtility",
            targets: ["KwiftUtility"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KwiftExtension",
            dependencies: []),
        .target(
            name: "KwiftUtility",
            dependencies: ["KwiftExtension"]),
        .testTarget(
            name: "KwiftExtensionTests",
            dependencies: ["KwiftExtension"]),
        .testTarget(
            name: "KwiftUtilityTests",
            dependencies: ["KwiftUtility"]),
    ]
)
