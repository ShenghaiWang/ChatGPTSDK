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
        .package(url: "git@github.com:ShenghaiWang/ServerSideEvent.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "ChatGPTSDK",
            dependencies: ["ServerSideEvent"]),
        .testTarget(
            name: "ChatGPTSDKTests",
            dependencies: ["ChatGPTSDK"]),
    ]
)
