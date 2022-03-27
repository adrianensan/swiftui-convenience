import Foundation

@propertyWrapper
public class NonObservedState<Value> {
  private var value: Value
  
  public init(wrappedValue: Value) {
    value = wrappedValue
  }
  
  public var wrappedValue: Value {
    get { value }
    set { value = newValue }
  }
}
