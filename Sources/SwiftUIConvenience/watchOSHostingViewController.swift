#if os(watchOS)
import SwiftUI

public struct HostingController<Content: View>: View {
  
  let content: Content
  
  public init(content: Content) {
    self.content = content
  }
  
  public var body: some View {
    content
  }
}
#endif
