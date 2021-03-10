// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftDown",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "SwiftDown",
      targets: ["SwiftDown"])
  ],
  targets: [
    .target(
      name: "SwiftDown",
      dependencies: [],
      resources: [.copy("Resources/Themes")])
  ]
)
