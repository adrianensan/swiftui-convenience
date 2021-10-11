import SwiftUI

public extension View {
  func frame(_ size: CGSize, alignment: Alignment = .center) -> some View {
    frame(width: size.width, height: size.height, alignment: alignment)
  }
}
