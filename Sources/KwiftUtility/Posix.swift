import Foundation

@inlinable
public func fStat(fileDescriptor: CInt) throws -> stat {
  var v = stat()
  try preconditionOrThrow(fstat(fileDescriptor, &v) == 0, StdError.current)
  return v
}

public extension FileHandle {
  @inlinable
  func fstat() throws -> stat {
    try fStat(fileDescriptor: fileDescriptor)
  }
}
