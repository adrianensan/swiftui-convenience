import SwiftUI
import SwiftConvenience

class UIConstantsObservable: ObservableObject {
  
  static var main: UIConstantsObservable = UIConstantsObservable()
 
  #if os(macOS)
  @Published var screenSize: CGSize = NSApplication.shared.mainWindow?.frame.size ?? CGSize(width: 200, height: 400)
  @Published var safeAreaInsets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
  #else
  @Published var screenSize: CGSize = UIScreen.main.bounds.size
  @Published var safeAreaInsets: EdgeInsets = (UIApplication.shared.windows.first?.safeAreaInsets ?? .zero) =& {
    EdgeInsets(top: $0.top, leading: $0.left, bottom: $0.bottom, trailing: $0.right)
  }
  #endif
  
  var horizontalMargin: CGFloat { 6 + max(0, min(24, (screenSize.width - 320) / 3)) }
  
  func update(size: CGSize, safeArea: EdgeInsets) {
    //    if Device.current.screenCornerRadius == 0 {
    //      safeArea.top += 8
    //    }
    
    if screenSize != size {
      screenSize = size
    }
    
    if safeAreaInsets != safeArea {
      safeAreaInsets = safeArea
    }
  }
}
