import SwiftUI
#if os(iOS)

public enum HomeBarTint {
  case none
  case dark
  case light
  case black
  case white
}

struct HomeBarTintView: View {
  
  @ObservedObject var uiConstants: UIConstantsObservable = .main
  @State var isInForeground: Bool = true
  
  var homeBatTint: HomeBarTint
  
  var homebarBackgroundColor: Color {
    let isFullScreen = uiConstants.screenSize == UIScreen.main.bounds.size
    guard isFullScreen && isInForeground else { return .clear }
    switch homeBatTint {
    case .none: return .clear
    case .dark: return Color(red: 0.75, green: 0.75, blue: 0.75)
    case .light: return Color(red: 0.35, green: 0.35, blue: 0.35)
    case .black: return Color(red: 1, green: 1, blue: 1)
    case .white: return Color(red: 0, green: 0, blue: 0)
    }
  }
  
  var body: some View {
    ZStack {
      Capsule()
        .fill(homebarBackgroundColor)
        .frame(width: 148, height: 5)
      
      Capsule()
        .fill(homebarBackgroundColor)
        .frame(width: 152, height: 3)
    }.frame(width: 152, height: 5)
      .padding(.bottom, 8)
    .frame(width: uiConstants.screenSize.width, height: uiConstants.screenSize.height, alignment: .bottom)
    .ignoresSafeArea()
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
      isInForeground = false
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
      isInForeground = true
    }
  }
}

public extension View {
  func homeBar(tint: HomeBarTint) -> some View {
    overlay(HomeBarTintView(homeBatTint: tint))
  }
}
#endif
