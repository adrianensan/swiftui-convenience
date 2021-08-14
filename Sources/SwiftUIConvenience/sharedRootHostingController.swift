import SwiftUI
import SwiftConvenience

extension HostingController {
  
  #if os(watchOS)
  func updateSize() {}
  #else
  static var main: HostingController?
  
  func updateSize() {
    let size = view.bounds.size
    let safeArea = view.safeAreaInsets
    guard size.minSide > 0 else { return }
    UIConstantsObservable.main.update(size: size,
                                        safeArea: EdgeInsets(top: safeArea.top,
                                                             leading: safeArea.left,
                                                             bottom: safeArea.bottom,
                                                             trailing: safeArea.right))
  }
  #endif
}
