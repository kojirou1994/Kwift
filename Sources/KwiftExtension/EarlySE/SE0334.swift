/*
 Pointer API Usability Improvements
 https://github.com/apple/swift-evolution/blob/main/proposals/0334-pointer-usability-improvements.md
 */

#if compiler(<5.7)
extension UnsafePointer {
  @inlinable
  @_alwaysEmitIntoClient
  public func pointer<Property>(to property: KeyPath<Pointee, Property>) -> UnsafePointer<Property>? {
    guard let offset = MemoryLayout.offset(of: property) else { return nil }
    return UnsafeRawPointer(self).advanced(by: offset).assumingMemoryBound(to: Property.self)
  }
}

extension UnsafeMutablePointer {
  @inlinable
  @_alwaysEmitIntoClient
  public func pointer<Property>(to property: KeyPath<Pointee, Property>) -> UnsafePointer<Property>? {
    guard let offset = MemoryLayout.offset(of: property) else { return nil }
    return UnsafeRawPointer(self).advanced(by: offset).assumingMemoryBound(to: Property.self)
  }

  @inlinable
  @_alwaysEmitIntoClient
  public func pointer<Property>(to property: WritableKeyPath<Pointee, Property>) -> UnsafeMutablePointer<Property>? {
    guard let offset = MemoryLayout.offset(of: property) else { return nil }
    return UnsafeMutableRawPointer(self).advanced(by: offset).assumingMemoryBound(to: Property.self)
  }
}
#endif
