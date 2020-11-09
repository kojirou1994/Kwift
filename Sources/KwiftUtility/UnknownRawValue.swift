public enum UnknownRawValue<T: RawRepresentable>: RawRepresentable, CustomStringConvertible {

  public typealias RawValue = T.RawValue

  case known(T)
  case unknwon(RawValue)

  public init(rawValue: RawValue) {
    if let v = T(rawValue: rawValue) {
      self = .known(v)
    } else {
      self = .unknwon(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
    case .known(let v):
      return v.rawValue
    case .unknwon(let v):
      return v
    }
  }

  public var description: String {
    switch self {
    case .known(let v):
      return "Known: \(v), rawValue: \(v.rawValue)"
    case .unknwon(let v):
      return "Unknown: \(v)"
    }
  }

}
