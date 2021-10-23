import SwiftUI

#if canImport(UIKit)
public typealias NativeImage = UIImage
#elseif canImport(AppKit)
public typealias NativeImage = NSImage
#endif

public extension Image {
  init(_ image: NativeImage) {
    #if canImport(UIKit)
    self.init(uiImage: image)
    #elseif canImport(AppKit)
    self.init(nsImage: image)
    #endif
  }
}
