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
      targets: ["Precondition"]),
    .library(
      name: "KwiftC",
      targets: ["KwiftC"]),
    .library(
      name: "ByteOpetarions",
      targets: ["ByteOpetarions"]),
    .library(
      name: "ImageInfo",
      targets: ["ImageInfo"]),
    .library(
      name: "PropertyWrappers",
      targets: ["PropertyWrappers"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "Precondition"),
    .target(name: "PropertyWrappers"),
    .target(
      name: "KwiftC",
      dependencies: []),
    .target(
      name: "ProxyInfo",
      dependencies: []),
    .target(
      name: "KwiftExtension",
      dependencies: [
        "Precondition",
        "KwiftC",
        "ProxyInfo"
      ]),
    .target(
      name: "ByteOpetarions",
      dependencies: ["Precondition", "KwiftC"]),
    .target(
      name: "ImageInfo",
      dependencies: ["ByteOpetarions", "KwiftExtension"]),
    .target(
      name: "KwiftUtility",
      dependencies: [
        "KwiftExtension",
        "ByteOpetarions",
        "ImageInfo",
        "ProxyInfo"
      ]),
    .testTarget(
      name: "KwiftTests",
      dependencies: ["KwiftUtility"])
  ]
)
