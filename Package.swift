// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftToolkit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftToolkit",
            targets: ["SwiftToolkit"]),
    ],
    dependencies: [
        // 这里可以添加依赖
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftToolkit",
            dependencies: [],
            path: "Sources/swift-toolkit"),
        .testTarget(
            name: "SwiftToolkitTests",
            dependencies: ["SwiftToolkit"],
            path: "Tests/swift-toolkitTests"),
        .executableTarget(
            name: "ExampleApp",
            dependencies: ["SwiftToolkit"],
            path: "Tests/ExampleApp")
    ]
)
