extension Collection {

  @discardableResult
  @_transparent
  public func notEmpty(_ message: @autoclosure () -> String = String(),
                       location: CodeLocation = .init()) throws -> Self {
    try notEmpty(ErrorInCode(header: "Collection is empty", message: message(), location: location))
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
