extension Collection where Element == UInt8 {
  @inlinable
  public var utf8String: String {
    .init(decoding: self, as: UTF8.self)
  }
}
