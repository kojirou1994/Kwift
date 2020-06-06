public struct PreconditionFailError: Error, CustomStringConvertible {

  public let file: StaticString
  public let line: UInt
  public let message: String?

  public init(file: StaticString, line: UInt, message: String?) {
    self.file = file
    self.line = line
    self.message = message
  }

  public var description: String {
    "Precondition failed at \(file):\(line)"
      + (message.map {", message: " + $0} ?? "")
  }
}

@_transparent
public func preconditionOrThrow(_ condition: @autoclosure () -> Bool, _ message: String? = nil, file: StaticString = #file, line: UInt = #line) throws {
  try preconditionOrThrow(condition(), PreconditionFailError(file: file, line: line, message: message))
}

@_transparent
public func preconditionOrThrow<E: Error>(_ condition: @autoclosure () -> Bool, _ error: @autoclosure () -> E) throws {
  if !condition() {
    throw error()
  }
}
