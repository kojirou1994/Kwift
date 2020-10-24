import Foundation
import KwiftC
import Precondition

extension FileHandle: ByteRegionReaderProtocol {

  public var readerOffset: Int {
    #if canImport(Darwin)
    if #available(macOS 10.15.4, iOS 13.4, tvOS 13.4, watchOS 6.2, *) {
      return numericCast(try! offset())
    } else {
      return numericCast(offsetInFile)
    }
    #else
    return numericCast(try! offset())
    #endif
  }

  public var count: Int {
    Int(try! fStat(fileDescriptor: fileDescriptor).st_size)
  }

  public func read(_ count: Int) throws -> Data {
    try checkCanRead(count: count)
    if count == 0 {
      return Data()
    }
    var data: Data?
    #if canImport(Darwin)
    try autoreleasepool {
      if #available(macOS 10.15.4, iOS 13.4, tvOS 13.4, watchOS 6.2, *) {
        data = try read(upToCount: count)
      } else {
        data = readData(ofLength: count)
      }
    }
    #else
    data = try read(upToCount: count)
    #endif
    try preconditionOrThrow(data?.count == count, ByteRegionReaderError.noEnoughBytes)
    return data.unsafelyUnwrapped
  }

  public func seek(to offset: Int) throws {
    try checkCanSeek(to: offset)
    #if canImport(Darwin)
    if #available(macOS 10.15.4, iOS 13.4, tvOS 13.4, watchOS 6.2, *) {
      try seek(toOffset: UInt64(offset))
    } else {
      seek(toFileOffset: UInt64(offset))
    }
    #else
    try seek(toOffset: UInt64(offset))
    #endif
  }

  public func readAll() throws -> Data? {
    #if canImport(Darwin)
    return try autoreleasepool {
      if #available(macOS 10.15.4, iOS 13.4, tvOS 13.4, watchOS 6.2, *) {
        return try readToEnd()
      } else {
        let data = readDataToEndOfFile()
        return data.isEmpty ? nil : data
      }
    }
    #else
    return try readToEnd()
    #endif
  }
}
