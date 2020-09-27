extension Optional {

  @discardableResult
  @_transparent
  public func unwrap(_ message: @autoclosure () -> String = String(),
                     location: CodeLocation = .init()) throws -> Wrapped {
    try unwrap(ErrorInCode(header: "Unwrap failed", message: message(), location: location))
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
