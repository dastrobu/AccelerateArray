// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccelerateArray",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AccelerateArray",
            targets: ["AccelerateArray"]),
    ],
    dependencies: [
        // https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/
        .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends
        // on.
        .target(
            name: "AccelerateArray",
            dependencies: []),
        .testTarget(
            name: "AccelerateArrayTests",
            dependencies: ["AccelerateArray"]),
    ]
)
