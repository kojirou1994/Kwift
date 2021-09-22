extension Sequence {

  @_alwaysEmitIntoClient
  public func withContiguousStorage<Result>(_ body: (UnsafeBufferPointer<Element>) throws -> Result) rethrows -> Result {
    if let result = try withContiguousStorageIfAvailable({ buffer in
      try body(buffer)
    }) {
      return result
    }

    return try ContiguousArray(self).withUnsafeBufferPointer(body)
  }

}
