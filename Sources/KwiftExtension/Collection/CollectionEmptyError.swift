public struct CollectionEmptyError: Error, CustomStringConvertible {

  public let file: StaticString
  public let line: UInt
  public let message: String?

  public init(message: String? = nil, file: StaticString, line: UInt) {
    self.file = file
    self.line = line
    self.message = message
  }

  public var description: String {
    "Empty collection at \(file):\(line)"
      + (message.map {", message: " + $0} ?? "")
  }

}

extension Collection {

  @discardableResult
  @_transparent
  public func notEmpty(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) throws -> Self {
    if isEmpty {
      throw CollectionEmptyError(message: message, file: file, line: line)
    }
    return self
  }

  @discardableResult
  @_transparent
  public func notEmpty<E: Error>(_ error: @autoclosure () -> E) throws -> Self {
    if isEmpty {
      throw error()
    }
    return self
  }

}
