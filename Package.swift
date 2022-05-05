// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "swiftui-theme",
  platforms: [
    .iOS(.v14),
    .macOS(.v11),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "SwiftUITheme",
      targets: ["SwiftUITheme"]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "SwiftUITheme",
      dependencies: []
    ),
    .testTarget(
      name: "SwiftUIThemeTests",
      dependencies: ["SwiftUITheme"]
    )
  ]
)
