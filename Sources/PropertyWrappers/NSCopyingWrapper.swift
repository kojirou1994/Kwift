import Foundation

@propertyWrapper
public struct NSCopyingWrapper<Value: NSCopying> {

  internal var storage: Value

  public init(wrappedValue: Value) {
    storage = wrappedValue.copy() as! Value
  }

  public init(withoutCopying value: Value) {
    storage = value
  }

  public var wrappedValue: Value {
    get { return storage }
    set { storage = newValue.copy() as! Value }
  }
}
