// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftRetry",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftRetry",
            targets: ["SwiftRetry"]
        )
    ],
    targets: [
        .target(
            name: "SwiftRetry"
        ),
        .testTarget(
            name: "SwiftRetryTests",
            dependencies: ["SwiftRetry"]
        )
    ],
    swiftLanguageModes: [.v6]
)
