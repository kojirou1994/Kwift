import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<T> {

  public let key: String

  public let defaultValue: T

  internal let userDefaults: UserDefaults

  public init(_ key: String, defaultValue: T, userDefaults: UserDefaults? = nil) {
    self.key = key
    self.defaultValue = defaultValue
    self.userDefaults = userDefaults ?? UserDefaults.standard
  }

  public init<Key>(_ key: Key, defaultValue: T, userDefaults: UserDefaults? = nil)
  where Key: RawRepresentable, Key.RawValue == String {
    self.init(key.rawValue, defaultValue: defaultValue, userDefaults: userDefaults)
  }

  public var wrappedValue: T {
    get {
      userDefaults.object(forKey: key) as? T ?? defaultValue
    }
    nonmutating set {
      userDefaults.set(newValue, forKey: key)
    }
  }

  public var projectValue: Self {
    self
  }
}

@propertyWrapper
public struct UserDefaultsRawValueWrapper<T: RawRepresentable> {

  public let key: String

  public let defaultValue: T

  internal let userDefaults: UserDefaults

  public init(_ key: String, defaultValue: T, userDefaults: UserDefaults? = nil) {
    self.key = key
    self.defaultValue = defaultValue
    self.userDefaults = userDefaults ?? UserDefaults.standard
  }

  public init<Key>(_ key: Key, defaultValue: T, userDefaults: UserDefaults? = nil)
  where Key: RawRepresentable, Key.RawValue == String {
    self.init(key.rawValue, defaultValue: defaultValue, userDefaults: userDefaults)
  }

  public var wrappedValue: T {
    get {
      guard let value = userDefaults.object(forKey: key) as? T.RawValue else {
        return defaultValue
      }

      guard let t = T(rawValue: value) else {
        assertionFailure("Invalid raw value! \(value)")
        return defaultValue
      }

      return t
    }
    nonmutating set {
      userDefaults.set(newValue.rawValue, forKey: key)
    }
  }

  public var projectValue: Self {
    self
  }
}

@propertyWrapper
public struct OptionalUserDefaultsWrapper<T> {
  internal let key: String

  internal let userDefaults: UserDefaults

  public init(_ key: String, userDefaults: UserDefaults? = nil) {
    self.key = key
    self.userDefaults = userDefaults ?? UserDefaults.standard
  }

  public init<Key>(_ key: Key, userDefaults: UserDefaults? = nil)
  where Key: RawRepresentable, Key.RawValue == String {
    self.init(key.rawValue, userDefaults: userDefaults)
  }

  public var wrappedValue: T? {
    get {
      userDefaults.object(forKey: key) as? T
    }
    nonmutating set {
      userDefaults.set(newValue, forKey: key)
    }
  }
}
