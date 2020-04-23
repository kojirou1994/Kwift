public enum TwoCase<First, Second> {
  case first(First)
  case second(Second)
}

extension TwoCase {

  @inlinable
  public var isFirstCase: Bool {
    switch self {
    case .first: return true
    default: return false
    }
  }

  @inlinable
  public var firstValue: First? {
    switch self {
    case .first(let v): return v
    default: return nil
    }
  }

  @inlinable
  public var secondValue: Second? {
    switch self {
    case .second(let v): return v
    default: return nil
    }
  }
}

extension TwoCase: Equatable where First: Equatable, Second: Equatable {}

extension TwoCase: Encodable where First: Encodable, Second: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .first(let v): try container.encode(v)
    case .second(let v): try container.encode(v)
    }
  }
}

extension TwoCase: Decodable where First: Decodable, Second: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = .first(try container.decode(First.self))
    } catch {
      self = .second(try container.decode(Second.self))
    }
  }
}
