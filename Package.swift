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
      name: "Precondition",
      targets: ["Precondition"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Precondition",
      dependencies: []),
    .target(
      name: "KwiftExtension",
      dependencies: ["Precondition"]),
    .target(
      name: "KwiftUtility",
      dependencies: ["KwiftExtension"]),
    .testTarget(
      name: "KwiftTests",
      dependencies: ["KwiftUtility"])
  ]
)
