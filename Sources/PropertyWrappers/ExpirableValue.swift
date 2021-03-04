import Foundation

@propertyWrapper
public struct Expirable<Value> {
  
  internal let duration: TimeInterval

  internal var storage: (value: Value, expirationDate: Date)?

  public init(duration: TimeInterval) {
    self.duration = duration
    storage = nil
  }

  //    public init(wrappedValue: Value, expirationDate: Date, duration: TimeInterval) {
  //        self.duration = duration
  //        storage = (wrappedValue, expirationDate)
  //    }

  public var wrappedValue: Value? {
    get {
      isValid ? storage?.value : nil
    }
    set {
      storage = newValue.map { ($0, Date().addingTimeInterval(duration)) }
    }
  }

  public var isValid: Bool {
    storage.map { $0.expirationDate >= Date() } ?? false
  }

  public mutating func set(_ newValue: Value, expirationDate: Date) {
    storage = (newValue, expirationDate)
  }
}
