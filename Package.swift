// swift-tools-version:5.5
import PackageDescription
import Foundation

let swiftConveniencePackage: Package.Dependency
if FileManager.default.fileExists(atPath: "Users/adrian/Repos/swift-packages/swift-convenience") {
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
    platforms: [.iOS(.v14), .macOS(.v11), .tvOS(.v14), .watchOS(.v7), .macCatalyst(.v14)],
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
          ]),
        .testTarget(
            name: "SwiftUIConvenienceTests",
            dependencies: ["SwiftUIConvenience"]),
    ]
)
