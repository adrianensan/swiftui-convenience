import Foundation
import SwiftUI

#if os(macOS)

public struct Blur: NSViewRepresentable {
  
  public var material: NSVisualEffectView.Material
  public var blendingMode: NSVisualEffectView.BlendingMode
  
  public init(material: NSVisualEffectView.Material = .popover,
              blendingMode: NSVisualEffectView.BlendingMode = .withinWindow) {
    self.material = material
    self.blendingMode = blendingMode
  }
  
  public func makeNSView(context: Context) -> NSVisualEffectView
  {
    let visualEffectView = NSVisualEffectView()
    visualEffectView.material = material
    visualEffectView.blendingMode = blendingMode
    visualEffectView.state = NSVisualEffectView.State.active
    return visualEffectView
  }
  
  public func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
  {
    visualEffectView.material = material
    visualEffectView.blendingMode = blendingMode
  }
}

#else

public struct Blur: UIViewRepresentable {
  
  public var style: UIBlurEffect.Style

  #if os(iOS)
  public init(style: UIBlurEffect.Style = .systemUltraThinMaterialDark) {
    self.style = style
  }
  #else
  public init(style: UIBlurEffect.Style = .dark) {
    self.style = style
  }
  #endif
  
  public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
    UIVisualEffectView()
  }
  
  public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
    uiView.effect = UIBlurEffect(style: style)
  }
}

#endif
