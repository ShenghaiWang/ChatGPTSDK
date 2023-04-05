// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "ChatGPTSDK",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        .library(
            name: "ChatGPTSDK",
            targets: ["ChatGPTSDK"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ChatGPTSDK",
            dependencies: []),
        .testTarget(
            name: "ChatGPTSDKTests",
            dependencies: ["ChatGPTSDK"]),
    ]
)
