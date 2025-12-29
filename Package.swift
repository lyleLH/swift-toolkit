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
        .package(url: "https://github.com/lyleLH/VisualEffectView.git", revision: "3cc067c6fd75e805f83f8b17ccb572dffffa2384"),
        .package(url: "https://github.com/lyleLH/TwemojiKit.git", revision: "ccb794c6888a373474075d58035a4382116bec8a"),
        .package(url: "https://github.com/SVGKit/SVGKit.git", revision: "6137e27e6a0b24587967d97aeb25a6706f8eb036"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.18.10")
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
                .product(name: "TwemojiKit", package: "TwemojiKit"),
                .product(name: "SVGKit", package: "SVGKit"),
                .product(name: "SDWebImage", package: "SDWebImage")
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
