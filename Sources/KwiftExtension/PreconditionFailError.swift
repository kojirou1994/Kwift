@_transparent
public func preconditionOrThrow(_ condition: Bool, _ message: @autoclosure () -> String = String(), location: CodeLocation = .init()) throws {
  try preconditionOrThrow(condition, ErrorInCode(header: "Precondition failed", message: message(), location: location))
}

@_transparent
public func preconditionOrThrow<E: Error>(_ condition: Bool, _ error: @autoclosure () -> E) throws {
  if !condition {
    throw error()
  }
}
