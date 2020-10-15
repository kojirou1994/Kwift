extension Collection {

  @discardableResult
  @_transparent
  public func notEmpty(_ message: @autoclosure () -> String = String(),
                       fileID: StaticString = #fileID, line: UInt = #line, column: UInt = #column) throws -> Self {
    try notEmpty(ErrorInCode(header: "Collection is empty", message: message(), location: CodeLocation(fileID: fileID, line: line, column: column)))
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
