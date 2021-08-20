#if os(iOS)
import SwiftUI
import DeviceInfo

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
  
  static var isSupported: Bool {
    var deviceModel = Device.current
    if case .simulator(let simulatedDevice) = deviceModel {
      deviceModel = simulatedDevice
    }
    
    switch deviceModel {
    case .iPhone(let model): return [
      .x, .xs, .xsMax,
      ._11Pro, ._11ProMax, ._11,
      ._12mini, ._12, ._12Pro, ._12ProMax
    ].contains(model)
    default: return false
    }
  }
  
  var homeBarWidth: CGFloat {
    var deviceModel = Device.current
    if case .simulator(let simulatedDevice) = deviceModel {
      deviceModel = simulatedDevice
    }
    
    switch deviceModel {
    case .iPhone(let model):
      switch model {
      case .x, .xs: return 134
      case .xsMax: return 148
      case .xr: return 132
      case ._11, ._11Pro: return 134
      case ._11ProMax: return 148
      case ._12mini: return 132
      case ._12, ._12Pro: return 134
      case ._12ProMax: return 152
      default: return 0
      }
    default: return 0
    }
  }
  
  var body: some View {
    ZStack {
      Capsule()
        .fill(homebarBackgroundColor)
        .padding(.horizontal, 4)
      
      Capsule()
        .fill(homebarBackgroundColor)
        .padding(.vertical, 1)
    }.frame(width: homeBarWidth, height: 5)
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
    Group {
      if HomeBarTintView.isSupported {
        self.overlay(HomeBarTintView(homeBatTint: tint))
      } else {
        self
      }
    }
  }
}
#endif
