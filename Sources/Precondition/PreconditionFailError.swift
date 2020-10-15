@_transparent
public func preconditionOrThrow(_ condition: Bool, _ message: @autoclosure () -> String = String(), fileID: StaticString = #fileID, line: UInt = #line, column: UInt = #column) throws {
  try preconditionOrThrow(condition, ErrorInCode(header: "Precondition failed", message: message(), location: CodeLocation(fileID: fileID, line: line, column: column)))
}

@_transparent
public func preconditionOrThrow<E: Error>(_ condition: Bool, _ error: @autoclosure () -> E) throws {
  if !condition {
    throw error()
  }
}
