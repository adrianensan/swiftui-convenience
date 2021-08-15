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
    dependencies: [.package(name: "SwiftConvenience",
                            url: "https://github.com/adrianensan/swift-convenience",
                            branch: "main"),
                   .package(name: "DeviceInfo",
                            url: "https://github.com/adrianensan/device-info",
                            branch: "main")],
    targets: [
        .target(
            name: "SwiftUIConvenience",
            dependencies: [.byNameItem(name: "SwiftConvenience", condition: nil),
                           .byNameItem(name: "DeviceInfo", condition: nil)]),
        .testTarget(
            name: "SwiftUIConvenienceTests",
            dependencies: ["SwiftUIConvenience"]),
    ]
)
