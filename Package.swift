// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "DataSources",
  platforms: [.iOS(.v12)],
  products: [
    .library(name: "DataSources", targets: ["DataSources"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "DataSources",
      exclude: ["Info.plist"]
    ),
  ]
)
