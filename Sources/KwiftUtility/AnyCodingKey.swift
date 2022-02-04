public struct AnyCodingKey: CodingKey, Equatable {


  public init(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = .init(stringValue)
  }

  public init(intValue: Int) {
    self.intValue = intValue
    self.stringValue = intValue.description
  }

  public let stringValue: String

  public let intValue: Int?

}

extension AnyCodingKey: ExpressibleByStringLiteral {

  public init(stringLiteral value: String) {
    self.init(stringValue: value)
  }

}

extension AnyCodingKey: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: Int) {
    self.init(intValue: value)
  }

}
