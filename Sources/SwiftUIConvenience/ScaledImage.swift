import SwiftUI

public struct ScaledImage: View {
  
  var name: String
  
  public init(_ name: String) {
    self.name = name
  }
  
  public var body: some View {
    Image(name)
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}

public struct ScaledSystemImage: View {
  
  private var name: String
  
  public init(_ name: String) {
    self.name = name
  }
  
  public var body: some View {
    Image(systemName: name)
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}
