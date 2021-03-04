import Foundation

@propertyWrapper
public struct Modified<Value> {
  internal var value: Value

  internal let modification: (Value) -> Value

  public init(value: Value, modification: @escaping (Value) -> Value) {
    self.value = value
    self.modification = modification
  }

  public var wrappedValue: Value {
    get { value }
    set { value = modification(newValue) }
  }
}
