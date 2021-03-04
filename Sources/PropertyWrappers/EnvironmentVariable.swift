import Foundation

@propertyWrapper
public struct EnvironmentVariable {
  
  internal let key: String

  internal let defaultValue: String?

  public init(_ key: String, defaultValue: String? = nil) {
    self.key = key
    self.defaultValue = defaultValue
  }

  public var wrappedValue: String? {
    get {
      guard let str = getenv(key) else { return defaultValue }
      return String(cString: str)
    }
    set {
      guard let value = newValue else {
        unsetenv(key)
        return
      }
      setenv(key, value, 1)
    }
  }
}
