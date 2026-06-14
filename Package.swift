// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ComicInfo",
  platforms: [
    .macOS(.v26),
    .iOS(.v26),
    .tvOS(.v26),
    .watchOS(.v26)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "ComicInfo",
      targets: ["ComicInfo"]
    ),
    .executable(
      name: "comicinfo",
      targets: ["ComicInfoCLI"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/jpsim/Yams.git", from: "6.2.2")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "ComicInfo",
      dependencies: [
        .product(name: "Yams", package: "Yams")
      ]
    ),
    .executableTarget(
      name: "ComicInfoCLI",
      dependencies: ["ComicInfo"]
    ),
    .testTarget(
      name: "ComicInfoTests",
      dependencies: [
        "ComicInfo",
        .product(name: "Yams", package: "Yams")
      ],
      resources: [.copy("Fixtures")]
    ),
  ]
)
