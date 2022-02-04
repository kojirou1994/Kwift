// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Kwift",
  products: [
    .library(
      name: "KwiftUtility",
      targets: ["KwiftUtility"]),
    .library(
      name: "KwiftExtension",
      targets: ["KwiftExtension"]),
    .library(
      name: "PropertyWrappers",
      targets: ["PropertyWrappers"]),
  ],
  dependencies: [
    .package(url: "https://github.com/kojirou1994/Precondition.git", from: "1.0.0"),
  ],
  targets: [
    .target(name: "PropertyWrappers"),
    .target(
      name: "KwiftExtension",
      dependencies: [
        "Precondition",
      ]),
    .target(
      name: "KwiftUtility",
      dependencies: [
        "KwiftExtension",
        "PropertyWrappers",
      ]),
    .testTarget(
      name: "KwiftTests",
      dependencies: ["KwiftUtility"])
  ]
)
