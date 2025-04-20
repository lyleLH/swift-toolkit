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
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftToolkit",
            targets: ["SwiftToolkit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/relatedcode/ProgressHUD.git", from: "14.1.3"),
        .package(url: "https://github.com/lyleLH/VisualEffectView.git", branch: "master"),
        .package(url: "https://github.com/lyleLH/TwemojiKit.git", branch: "master"),
        .package(url: "https://github.com/SVGKit/SVGKit.git", branch: "3.x"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.18.10")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftToolkit",
            dependencies: [
                .product(name: "ProgressHUD", package: "ProgressHUD"),
                .product(name: "VisualEffectView", package: "VisualEffectView"),
                .product(name: "TwemojiKit", package: "TwemojiKit"),
                .product(name: "SVGKit", package: "SVGKit"),
                .product(name: "SDWebImage", package: "SDWebImage")
            ],
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
