public struct CollectionEmptyError: Error, CustomStringConvertible {

  public let file: String

  public let line: Int

  public let message: String?

  public init(message: String? = nil, file: String, line: Int) {
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
  @inlinable @inline(__always)
  public func notEmpty(_ message: String? = nil, file: String = #file, line: Int = #line) throws -> Self {
    if isEmpty {
      throw CollectionEmptyError(message: message, file: file, line: line)
    }
    return self
  }

  @discardableResult
  @inlinable @inline(__always)
  public func unwrap<E: Error>(_ error: @autoclosure () -> E) throws -> Self {
    if isEmpty {
      throw error()
    }
    return self
  }

}
