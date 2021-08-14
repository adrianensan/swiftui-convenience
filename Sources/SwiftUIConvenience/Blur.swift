import Foundation
import SwiftUI

#if os(macOS)

public struct Blur: NSViewRepresentable {
  
  public var material: NSVisualEffectView.Material = .popover
  var blendingMode: NSVisualEffectView.BlendingMode = .withinWindow
  
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
  
#if os(iOS)
  public var style: UIBlurEffect.Style = .systemUltraThinMaterialDark
#else
  public var style: UIBlurEffect.Style = .dark
#endif
  
  public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
    UIVisualEffectView()
  }
  
  public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
    uiView.effect = UIBlurEffect(style: style)
  }
}

#endif
