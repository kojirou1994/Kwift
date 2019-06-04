// swift-tools-version:5.0

import PackageDescription

var products: [Product] = [
    .library(
        name: "Kwift",
        targets: ["Kwift"]),
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
]

var targets: [Target] = [

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
        name: "SwiftEnhancementTests",
        dependencies: ["SwiftEnhancement"]),
    .testTarget(
        name: "KwiftUtilityTests",
        dependencies: ["KwiftUtility"]),
]

var kwiftDependnecies: [Target.Dependency] = [
    "KwiftUtility",
    "Compatibility",
    "SwiftEnhancement",
    "FoundationEnhancement"
]

#if os(macOS) || os(Linux)
products.append(.library(name: "Executable", targets: ["Executable"]))

targets.append(.target(name: "Executable", dependencies: []))
targets.append(.testTarget(name: "ExecutableTests", dependencies: ["Executable"]))
kwiftDependnecies.append("Executable")
#endif

targets.append(.target(
    name: "Kwift",
    dependencies: kwiftDependnecies))

let package = Package(
    name: "Kwift",
    products: products,
    dependencies: [],
    targets: targets,
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
