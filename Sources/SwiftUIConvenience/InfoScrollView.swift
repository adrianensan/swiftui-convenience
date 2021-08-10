import SwiftUI

class InfoScrollViewStorage {
  var readyForDismiss: Bool = true
  var isDismissing: Bool = true
  var timeReachedtop: TimeInterval = 0
}

public struct InfoScrollView<Content: View>: View {
  
  public let showsIndicators: Bool
  @Binding public var scrollOffset: CGFloat
  @Binding public var dismissProgress: CGFloat
  public var stopUpdatingAfterDismiss: Bool = false
  public var onDismiss: () -> Void
  @ViewBuilder public var content: () -> Content
  
  @State var nonObservedStorage = InfoScrollViewStorage()
  @State private var coordinateSpaceName: String = UUID().uuidString
  
  var isFrozen: Bool {
    stopUpdatingAfterDismiss && dismissProgress == 1
  }
  
  func update(offset: CGFloat) {
    guard scrollOffset != offset && !isFrozen else { return }
    DispatchQueue.main.async {
      if offset < 0 {
        nonObservedStorage.timeReachedtop = Date().timeIntervalSince1970
      }
      
      if nonObservedStorage.readyForDismiss
          && !nonObservedStorage.isDismissing
          && offset > scrollOffset {
        nonObservedStorage.isDismissing = true
      }
      
      if !nonObservedStorage.readyForDismiss
          && offset >= 0 && offset < 24
          && Date().timeIntervalSince1970 - nonObservedStorage.timeReachedtop > 0.1 {
        nonObservedStorage.readyForDismiss = true
      } else if nonObservedStorage.readyForDismiss && offset < 0 {
        nonObservedStorage.readyForDismiss = false
        nonObservedStorage.isDismissing = false
      }
      
      scrollOffset = offset
      
      if nonObservedStorage.isDismissing {
        let newDismissProgress = min(1, max(0, offset / 100))
        guard dismissProgress != newDismissProgress else { return }
        dismissProgress = newDismissProgress
        if dismissProgress == 1 {
          onDismiss()
        }
      } else if dismissProgress != 0 {
        dismissProgress = 0
      }
    }
  }
  
  public var body: some View {
    ZStack(alignment: .top) {
      ScrollView(.vertical, showsIndicators: showsIndicators) {
        VStack(spacing: 0) {
          Color.clear.frame(height: 0)
            .background(GeometryReader { geometry -> Color in
              update(offset: geometry.frame(in: .named(coordinateSpaceName)).minY)
              return .clear
            })
          if !isFrozen {
            content()
          }
        }
      }.coordinateSpace(name: coordinateSpaceName)
      if isFrozen {
        content().offset(y: isFrozen ? scrollOffset : 0)
      }
    }
  }
}

