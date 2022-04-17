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
  dependencies: [
    .package(
      url: "https://github.com/johnxnguyen/Down.git",
      from: "0.10.0"
    ),
    .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0")),

  ],
  targets: [
    .target(
      name: "SwiftDown",
      dependencies: ["Down"],
      exclude: ["SwiftDownDemo"],
      resources: [.copy("Resources/Themes")]
    ),
    .testTarget(
      name: "SwiftDownTests",
      dependencies: ["SwiftDown", "Nimble"]
    )
  ]
)
