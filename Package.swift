// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "DataSources",
  platforms: [.iOS(.v12)],
  products: [
    .library(name: "DataSources", targets: ["DataSources"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ra1028/DifferenceKit.git", from: "1.2.0")
  ],
  targets: [
    .target(
      name: "DataSources",
      dependencies: ["DifferenceKit"],
      exclude: ["Info.plist"]
    ),
  ]
)
