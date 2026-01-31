// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ModernButtonKit2",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(name: "ModernButtonKit2", targets: ["ModernButtonKit2"])
    ],
    dependencies: [
        .package(path: "../MBGWorldStandardKit")
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
