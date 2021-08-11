#if os(macOS)
import Foundation
import SwiftUI

import AppKit

public class HostingController: NSHostingController<AnyView> {
  
  public init<T: View>(wrappedView: T) {
    let observedView = AnyView(wrappedView)
    
    super.init(rootView: observedView)
    Self.main = self
    view.layer?.backgroundColor = .black
  }
  
  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    fatalError("Unavailable")
  }
  
  override public func updateViewConstraints() {
    super.updateViewConstraints()
    updateSize()
  }
}
#endif
