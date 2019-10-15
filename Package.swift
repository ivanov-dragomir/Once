// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Once",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Once",
            targets: ["Once"]),
    ],
    targets: [
        .target(
            name: "Once",
            dependencies: []),
        .testTarget(
            name: "OnceTests",
            dependencies: ["Once"]),
    ]
)
