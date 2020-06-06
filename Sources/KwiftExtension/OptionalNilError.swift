public struct OptionalNilError: Error, CustomStringConvertible {

  public let file: StaticString
  public let line: UInt
  public let message: String?

  public init(message: String? = nil, file: StaticString, line: UInt) {
    self.file = file
    self.line = line
    self.message = message
  }

  public var description: String {
    "Nil value returned at \(file):\(line)"
      + (message.map {", message: " + $0} ?? "")
  }

}

extension Optional {

  @discardableResult
  @_transparent
  public func unwrap(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
    guard let value = self else {
      throw OptionalNilError(message: message, file: file, line: line)
    }
    return value
  }

  @discardableResult
  @_transparent
  public func unwrap<E: Error>(_ error: @autoclosure () -> E) throws -> Wrapped {
    guard let value = self else {
      throw error()
    }
    return value
  }

}
