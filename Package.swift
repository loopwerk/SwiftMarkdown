// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SwiftMarkdown",
  products: [
    .library(
      name: "SwiftMarkdown",
      targets: ["SwiftMarkdown"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pvieito/PythonKit.git", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "SwiftMarkdown",
      dependencies: ["PythonKit"]),
    .testTarget(
      name: "SwiftMarkdownTests",
      dependencies: ["SwiftMarkdown"]),
  ]
)
