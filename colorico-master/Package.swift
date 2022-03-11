// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "colorico",
    platforms: [
            .macOS(.v12)
        ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.3"),
        .package(url: "https://github.com/vapor/console-kit", from: "4.1.0")
    ],
    targets: [
        .executableTarget(
            name: "colorico",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ConsoleKit", package: "console-kit")
            ]),
        .testTarget(
            name: "coloricoTests",
            dependencies: ["colorico"]),
    ]
)
