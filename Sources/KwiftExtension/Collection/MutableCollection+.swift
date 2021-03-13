extension MutableCollection {
  @inlinable
  public mutating func mutateEach(_ body: (inout Element) throws -> Void) rethrows {
    for index in self.indices {
      try body(&self[index])
    }
  }
}
