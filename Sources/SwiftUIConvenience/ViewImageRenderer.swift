import SwiftUI
import SwiftConvenience

public enum ImageRenderer {
  #if os(iOS)
  public static func render<Content: View>(view: Content, size: CGSize) -> UIImage? {
    let controller = UIHostingController(rootView: view
                                          .frame(width: size.width, height: size.height)
                                          .drawingGroup()
                                          .ignoresSafeArea())
    guard let view = controller.view else { return nil }
    
    let targetSize = size
    view.frame.size = targetSize
    view.backgroundColor = .clear
    
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    
    var failed = false
    let image = renderer.image { _ in
      guard view.drawHierarchy(in: view.frame, afterScreenUpdates: true) else {
        return failed = true
      }
    }
    return failed ? nil : image
  }
  #elseif os(macOS)
  public static func renderData<Content: View>(view content: Content, size: CGSize) -> Data? {
    let screenSale = NSScreen.main!.backingScaleFactor
    
    let view = NSHostingView(rootView: content
                              .frame(width: size.width, height: size.height)
                              .drawingGroup()
                              .ignoresSafeArea())
    view.frame = CGRect(origin: .zero, size: size)
    
    let targetSize = NSSize(width: size.width, height: size.height)
    guard let imageRepresentation = view.bitmapImageRepForCachingDisplay(in: view.frame),
          let newImage = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size.width * screenSale), pixelsHigh: Int(size.height * screenSale), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)
    else { return nil }
    
    view.cacheDisplay(in: view.frame, to: imageRepresentation)
    newImage.size = targetSize
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: newImage)? +& {
      $0.shouldAntialias = true
      $0.imageInterpolation = .high
    }
    imageRepresentation.draw(in: NSRect(origin: .zero, size: targetSize))
    NSGraphicsContext.restoreGraphicsState()
    
    return newImage.representation(using: .png, properties: [.compressionFactor: 0.9])
  }
  
  public static func render<Content: View>(view content: Content, size: CGSize) -> NSImage? {
    guard let imageData = renderData(view: content, size: size) else { return nil }
    return NSImage(data: imageData)
  }
  #else
  public static func render<Content: View>(view content: Content, size: CGSize) -> NativeImage? {
   return nil
  }
  #endif
}
