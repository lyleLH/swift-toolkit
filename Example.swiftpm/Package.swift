// swift-tools-version: 5.8
import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Example",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Example",
            targets: ["AppModule"],
            bundleIdentifier: "com.swifttoolkit.example",
            teamIdentifier: "TeamID",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .star),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown
            ]
        )
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "SwiftToolkit", package: "swift-toolkit"),
                .product(name: "SwiftToolkitUI", package: "swift-toolkit")
            ],
            path: "Sources"
        )
    ]
)
