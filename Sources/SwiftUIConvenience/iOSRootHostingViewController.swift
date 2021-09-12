#if os(iOS)
import Foundation
import SwiftUI
import UIKit

struct StatusBarStyleKey: PreferenceKey {
  static var defaultValue: UIStatusBarStyle = .default
  
  static func reduce(value: inout UIStatusBarStyle, nextValue: () -> UIStatusBarStyle) {
    value = nextValue()
  }
}

public extension View {
  func statusBar(style: UIStatusBarStyle) -> some View {
    preference(key: StatusBarStyleKey.self, value: style)
  }
}

struct HomeIndicatorHiddenKey: PreferenceKey {
  static var defaultValue: Bool = false
  
  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

public extension View {
  func homeIndicator(hidden: Bool) -> some View {
    preference(key: HomeIndicatorHiddenKey.self, value: hidden)
  }
}

public class HostingController: UIHostingController<AnyView> {
  
  var statusBarStyle: UIStatusBarStyle = .default
  var hideHomeIndicator: Bool = false
  public var onBrightnessChange: (() -> Void)?
  
  public init<T: View>(wrappedView: T) {
    let observedView = AnyView(wrappedView.onPreferenceChange(StatusBarStyleKey.self) { style in
      guard let viewController = Self.main,
            viewController.statusBarStyle != style else { return }
      viewController.statusBarStyle = style
      viewController.setNeedsStatusBarAppearanceUpdate()
    }.onPreferenceChange(HomeIndicatorHiddenKey.self) { hideHomeIndicator in
      guard let viewController = Self.main,
            viewController.hideHomeIndicator != hideHomeIndicator else { return }
      viewController.hideHomeIndicator = hideHomeIndicator
      viewController.setNeedsUpdateOfHomeIndicatorAutoHidden()
      viewController.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }.ignoresSafeArea())
    
    super.init(rootView: observedView)
    Self.main = self
    view.backgroundColor = .black
    disableKeyboardOffset()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(brightnessDidChange),
                                           name: UIScreen.brightnessDidChangeNotification,
                                           object: nil)
  }
  
  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    // We aren't using storyboards, so this is unnecessary
    fatalError("Unavailable")
  }
  
  func disableKeyboardOffset() {
    guard let viewClass = object_getClass(view) else { return }
    
    let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoresKeyboard")
    if let viewSubclass = NSClassFromString(viewSubclassName) {
      object_setClass(view, viewSubclass)
    }
    else {
      guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
      guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
      
      if let method = class_getInstanceMethod(viewClass, NSSelectorFromString("keyboardWillShowWithNotification:")) {
        let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
        class_addMethod(viewSubclass, NSSelectorFromString("keyboardWillShowWithNotification:"),
                        imp_implementationWithBlock(keyboardWillShow), method_getTypeEncoding(method))
      }
      
      objc_registerClassPair(viewSubclass)
      object_setClass(view, viewSubclass)
    }
  }
  
  override public var preferredStatusBarStyle: UIStatusBarStyle {
    statusBarStyle
  }
  
  //  override var prefersHomeIndicatorAutoHidden: Bool {
  //    hideHomeIndicator
  //  }
  
  override public func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateSize()
  }
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateSize()
  }
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateSize()
  }
  
  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateSize()
  }
  
  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateSize()
  }
  
  override public func viewWillTransition(to size: CGSize,
                                          with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    updateSize()
  }
  
  override public func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    updateSize()
  }
  
  override public func updateViewConstraints() {
    super.updateViewConstraints()
    updateSize()
  }
  
  override public var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
    return hideHomeIndicator ? [.bottom] : []
  }
  
  @objc func brightnessDidChange() {
    onBrightnessChange?()
  }
}

#endif
