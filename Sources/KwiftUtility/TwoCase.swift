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
    switch self {
    case .first(let v): try v.encode(to: encoder)
    case .second(let v): try v.encode(to: encoder)
    }
  }
}

extension TwoCase: Decodable where First: Decodable, Second: Decodable {
  public init(from decoder: Decoder) throws {
    do {
      self = .first(try .init(from: decoder))
    } catch {
      self = .second(try .init(from: decoder))
    }
  }
}

extension TwoCase: CustomStringConvertible where First: CustomStringConvertible, Second: CustomStringConvertible {
  public var description: String {
    switch self {
    case .first(let v): return v.description
    case .second(let v): return v.description
    }
  }
}
