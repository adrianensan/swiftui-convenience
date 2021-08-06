// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SwiftUIConvenience",
    platforms: [.iOS(.v14), .macOS(.v11), .tvOS(.v14), .watchOS(.v7), .macCatalyst(.v14)],
    products: [
        .library(
            name: "SwiftUIConvenience",
            targets: ["SwiftUIConvenience"]),
    ],
    targets: [
        .target(
            name: "SwiftUIConvenience",
            dependencies: []),
        .testTarget(
            name: "SwiftUIConvenienceTests",
            dependencies: ["SwiftUIConvenience"]),
    ]
)
