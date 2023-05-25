// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "swiftui-theme",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(name: "SwiftUITheme", targets: ["SwiftUITheme"])
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "SwiftUITheme", dependencies: []),
    .testTarget(name: "SwiftUIThemeTests", dependencies: ["SwiftUITheme"])
  ]
)
