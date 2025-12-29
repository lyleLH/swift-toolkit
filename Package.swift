// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftToolkit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Core library containing non-UI utilities
        .library(
            name: "SwiftToolkit",
            targets: ["SwiftToolkit"]),
        // UI library containing UI components and extensions
        .library(
            name: "SwiftToolkitUI",
            targets: ["SwiftToolkitUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/relatedcode/ProgressHUD.git", from: "14.1.3"),
        .package(url: "https://github.com/lyleLH/VisualEffectView.git", exact: "1.0.1"),
        .package(url: "https://github.com/lyleLH/TwemojiKit.git", exact: "1.0.1")
    ],
    targets: [
        // Core Target
        .target(
            name: "SwiftToolkit",
            dependencies: [],
            path: "Sources/SwiftToolkit"
        ),
        // UI Target
        .target(
            name: "SwiftToolkitUI",
            dependencies: [
                "SwiftToolkit",
                .product(name: "ProgressHUD", package: "ProgressHUD"),
                .product(name: "VisualEffectView", package: "VisualEffectView"),
                .product(name: "TwemojiKit", package: "TwemojiKit")
            ],
            path: "Sources/SwiftToolkitUI"
        ),
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
