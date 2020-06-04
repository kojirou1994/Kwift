public struct AnyCodingKey: CodingKey, Equatable {

  public let value: TwoCase<String, Int>

  public init(stringValue: String) {
    value = .first(stringValue)
  }

  public init(intValue: Int) {
    value = .second(intValue)
  }

  public var stringValue: String {
    switch value {
    case .first(let s): return s
    case .second(let i): return i.description
    }
  }

  public var intValue: Int? { value.secondValue }

}

extension AnyCodingKey: ExpressibleByStringLiteral {

  public init(stringLiteral value: String) {
    self.value = .first(value)
  }
  
}

extension AnyCodingKey: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: Int) {
    self.value = .second(value)
  }

}
