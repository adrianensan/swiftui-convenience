// swift-tools-version:5.5
import PackageDescription
import Foundation

var helloPackagesPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("/Developer/Hello/packages/", isDirectory: true).absoluteString
if helloPackagesPath.hasPrefix("file://") {
  helloPackagesPath.removeFirst(7)
}

let swiftConveniencePackage: Package.Dependency
if FileManager.default.fileExists(atPath: "\(helloPackagesPath)swift-convenience") {
  swiftConveniencePackage = .package(name: "SwiftConvenience",
                                     path: "\(helloPackagesPath)swift-convenience")
} else {
  swiftConveniencePackage = .package(url: "https://github.com/hello-apps/swift-convenience",
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
          dependencies: ["SwiftConvenience"],
          swiftSettings: [.define("APPLICATION_EXTENSION_API_ONLY")]),
        .testTarget(
            name: "SwiftUIConvenienceTests",
            dependencies: ["SwiftUIConvenience"]),
    ]
)
