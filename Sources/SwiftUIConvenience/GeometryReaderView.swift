import SwiftUI

public struct PositionReaderView: View {
  
  var onPositionChange: (CGPoint) -> Void
  var coordinateSpace: CoordinateSpace = .global
 
  public var body: some View {
    Color.clear
      .frame(height: 0)
      .readGeometry { onPositionChange($0.frame(in: coordinateSpace).origin) }
  }
}
