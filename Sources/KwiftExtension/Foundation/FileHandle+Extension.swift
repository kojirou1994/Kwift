import Foundation

extension FileHandle {

  #if canImport(Darwin) && swift(<5.2)
  @inlinable
  public func write<T: DataProtocol>(contentsOf data: T) throws {
    try kwiftWrite(contentsOf: data)
  }
  #endif

  @inlinable
  public func kwiftWrite<T: DataProtocol>(contentsOf data: T) throws {
    #if canImport(Darwin)
    if #available(macOS 10.15.4, iOS 13.4, tvOS 13.4, watchOS 6.2, *) {
      try write(contentsOf: data)
    } else {
      for region in data.regions {
        region.withUnsafeBytes { (bytes) in
          if let baseAddress = bytes.baseAddress, bytes.count > 0 {
            self.write(Data(bytesNoCopy: .init(mutating: baseAddress), count: bytes.count, deallocator: .none))
          }
        }
      }
    }
    #else
    try write(contentsOf: data)
    #endif
  }

}
