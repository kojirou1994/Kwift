// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "Kwift",
  products: [
    .library(
      name: "Kwift",
      targets: ["KwiftUtility"]),
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
      name: "KwiftExtension",
      dependencies: []),
    .target(
      name: "KwiftUtility",
      dependencies: ["KwiftExtension"]),
    .testTarget(
      name: "KwiftTests",
      dependencies: ["KwiftUtility"])
  ]
)
