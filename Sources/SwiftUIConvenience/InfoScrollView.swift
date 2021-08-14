import SwiftUI
import SwiftConvenience

class InfoScrollViewStorage {
  var coordinateSpaceName: String = UUID().uuidString
  var readyForDismiss: Bool = true
  var isDismissing: Bool = true
  var timeReachedtop: TimeInterval = 0
}

public struct InfoScrollView<Content: View>: View {
  
  let showsIndicators: Bool
  @Binding var scrollOffset: CGFloat
  @Binding var dismissProgress: CGFloat
  let stopUpdatingAfterDismiss: Bool
  var onDismiss: () -> Void
  var content: () -> Content
  
  @State private var nonObservedStorage = InfoScrollViewStorage()
  
  public init(showsIndicators: Bool = true,
              scrollOffset: Binding<CGFloat>,
              dismissProgress: Binding<CGFloat>,
              stopUpdatingAfterDismiss: Bool = false,
              onDismiss: @escaping () -> Void,
              content: @escaping () -> Content) {
    self.showsIndicators = showsIndicators
    _scrollOffset = scrollOffset
    _dismissProgress = dismissProgress
    self.stopUpdatingAfterDismiss = stopUpdatingAfterDismiss
    self.onDismiss = onDismiss
    self.content = content
  }
  
  var isFrozen: Bool {
    stopUpdatingAfterDismiss && dismissProgress == 1
  }
  
  func update(offset: CGFloat) {
    guard scrollOffset != offset && !isFrozen else { return }
    dispatchMainAsync {
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
    ScrollView(.vertical, showsIndicators: showsIndicators) {
      VStack(spacing: 0) {
        Color.clear.frame(height: 0)
          .background(GeometryReader { geometry -> Color in
            update(offset: geometry.frame(in: .named(nonObservedStorage.coordinateSpaceName)).minY)
            return .clear
          })
        content()
          .offset(y: isFrozen ? scrollOffset : 0)
      }
    }.coordinateSpace(name: nonObservedStorage.coordinateSpaceName)
  }
}

