// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ModernButtonKit2",
    platforms: [
        .macOS(.v13), .iOS(.v15)
    ],
    products: [
        .library(name: "ModernButtonKit2", targets: ["ModernButtonKit2"])
    ],
    targets: [
        .target(
            name: "ModernButtonKit2",
            path: "Sources",
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend",
                    "-disable-round-trip-debug-types"
                ], .when(platforms: [.macOS]))
            ]
        )
    ]
)
