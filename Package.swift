// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ConcaveHull",
    platforms: [
        .iOS(.v10), // Adjust according to your needs or remove if not platform-specific
    ],
    products: [
        .library(
            name: "ConcaveHull",
            targets: ["ConcaveHull"]),
    ],
    dependencies: [
        // List any dependencies here
    ],
    targets: [
        .target(
            name: "ConcaveHull",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "ConcaveHullTests",
            dependencies: ["ConcaveHull"]),
    ]
)
