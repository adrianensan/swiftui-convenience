import SwiftUI

#if canImport(UIKit)
public typealias NativeImage = UIImage
#elseif canImport(AppKit)
public typealias NativeImage = NSImage
#else
public struct FakeImage {
  init()
}
public typealias NativeImage = FakeImage
#endif

public extension Image {
  init(_ image: NativeImage) {
    #if canImport(UIKit)
    self.init(uiImage: image)
    #elseif canImport(AppKit)
    self.init(nsImage: image)
    #else
    self.init("")
    #endif
  }
}

public extension NativeImage {
  static func create(from cgImage: CGImage, size: CGSize) -> NativeImage {
    #if canImport(UIKit)
    NativeImage(cgImage: cgImage)
    #elseif canImport(AppKit)
    NativeImage(cgImage: cgImage, size: size)
    #else
    NativeImage.init("")
    #endif
  }
}
