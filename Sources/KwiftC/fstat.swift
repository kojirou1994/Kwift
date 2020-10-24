import Foundation

@inlinable
public func fStat(fileDescriptor: CInt) throws -> stat {
  var v = stat()
  if fstat(fileDescriptor, &v) != 0 {
    throw StdError.current
  }
  return v
}

public extension FileHandle {
  @inlinable
  func fstat() throws -> stat {
    try fStat(fileDescriptor: fileDescriptor)
  }
}
