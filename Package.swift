// swift-tools-version:5.5
import PackageDescription
import Foundation

let swiftConveniencePackage: Package.Dependency
if FileManager.default.fileExists(atPath: "Users/adrianensan/Repos/swift-packages/swift-convenience") {
  swiftConveniencePackage = .package(name: "SwiftConvenience",
                                       path: "~/Repos/swift-packages/swift-convenience")
} else {
  swiftConveniencePackage = .package(name: "SwiftConvenience",
                                       url: "https://github.com/hello-apps/swift-convenience",
                                       branch: "main")
}

let dependencies: [Package.Dependency] = [
  swiftConveniencePackage
]

let package = Package(
    name: "SwiftUIConvenience",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8), .macCatalyst(.v15)],
    products: [
      .library(
        name: "SwiftUIConvenience",
        targets: ["SwiftUIConvenience"]),
    ],
    dependencies: dependencies,
    targets: [
        .target(
          name: "SwiftUIConvenience",
          dependencies: [
            .byNameItem(name: "SwiftConvenience", condition: nil)
          ],
          swiftSettings: [.define("APPLICATION_EXTENSION_API_ONLY")]),
        .testTarget(
            name: "SwiftUIConvenienceTests",
            dependencies: ["SwiftUIConvenience"]),
    ]
)
