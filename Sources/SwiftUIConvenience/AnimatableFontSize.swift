import SwiftUI

public struct AnimatableSystemFontModifier: AnimatableModifier {
  var size: CGFloat
  var weight: Font.Weight
  var design: Font.Design
  
  public var animatableData: CGFloat {
    get { size }
    set { size = newValue }
  }
  
  public func body(content: Content) -> some View {
    content
      .font(.system(size: size, weight: weight, design: design))
  }
}

public extension View {
  func animatableSystemFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
    self.modifier(AnimatableSystemFontModifier(size: size, weight: weight, design: design))
  }
}

public struct AnimatableCustomFontModifier: AnimatableModifier {
  var name: String
  var size: CGFloat
  
  public var animatableData: CGFloat {
    get { size }
    set { size = newValue }
  }
  
  public func body(content: Content) -> some View {
    content
      .font(.custom(name, size: size))
  }
}

// To make that easier to use, I recommend wrapping
// it in a `View` extension, like this:
public extension View {
  func animatableFont(name: String, size: CGFloat) -> some View {
    self.modifier(AnimatableCustomFontModifier(name: name, size: size))
  }
}
