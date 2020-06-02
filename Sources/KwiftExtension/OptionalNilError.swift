public struct OptionalNilError: Error, CustomStringConvertible {

  public let file: String

  public let line: Int

  public let message: String?

  public init(message: String? = nil, file: String, line: Int) {
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
  @inlinable @inline(__always)
  public func unwrap(_ message: String? = nil, file: String = #file, line: Int = #line) throws -> Wrapped {
    guard let value = self else {
      throw OptionalNilError(message: message, file: file, line: line)
    }
    return value
  }

  @discardableResult
  @inlinable @inline(__always)
  public func unwrap<E: Error>(_ error: @autoclosure () -> E) throws -> Wrapped {
    guard let value = self else {
      throw error()
    }
    return value
  }

}