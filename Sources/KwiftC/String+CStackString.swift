extension String {
  @_alwaysEmitIntoClient
  public init<T>(cStackString: inout T) {
    self = withUnsafeBytes(of: &cStackString) { buffer in
      String(cStackBuffer: buffer)
    }
  }

  @_alwaysEmitIntoClient
  public init<T>(cStackString: T) {
    self = withUnsafeBytes(of: cStackString) { buffer in
      String(cStackBuffer: buffer)
    }
  }

  @_alwaysEmitIntoClient
  init(cStackBuffer: UnsafeRawBufferPointer) {
    self.init(decodingCString: cStackBuffer.baseAddress!.assumingMemoryBound(to: UInt8.self), as: UTF8.self)
  }

}
