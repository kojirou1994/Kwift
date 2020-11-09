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

extension UnknownRawValue: Encodable where RawValue: Encodable {
  public func encode(to encoder: Encoder) throws {
    try rawValue.encode(to: encoder)
  }
}

extension UnknownRawValue: Decodable where RawValue: Decodable {
  public init(from decoder: Decoder) throws {
    self.init(rawValue: try .init(from: decoder))
  }
}

extension UnknownRawValue: Equatable where T.RawValue: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension UnknownRawValue: Hashable where RawValue: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue)
  }
}
