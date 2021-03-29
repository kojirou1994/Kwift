import Foundation
import Precondition

public enum ByteRegionReaderError: Error {
  case noEnoughBytes
  /// The operation will make readerOffset out of available range
  case outRange
}

public protocol ByteRegionReaderProtocol {
  associatedtype ByteRegion: DataProtocol

  var readerOffset: Int { get }
  /// Total bytes count, including read bytes
  var count: Int { get }
  var unreadBytesCount: Int { get }
  var isAtEnd: Bool { get }
  mutating func read(_ count: Int) throws -> ByteRegion
  mutating func readByte() throws -> UInt8
  mutating func skip(_ count: Int) throws
  mutating func seek(to offset: Int) throws
  mutating func readAll() throws -> ByteRegion?
}

public extension ByteRegionReaderProtocol {

  @inlinable
  mutating func readInteger<T: FixedWidthInteger>(bytesCount: Int, endian: Endianness = .big, as: T.Type = T.self) throws -> T {
    precondition(0...MemoryLayout<T>.size ~= bytesCount)
    if _slowPath(bytesCount == 0) {
      return 0
    }
    var value: T = 0
    try withUnsafeMutableBytes(of: &value) { ptr in
      _ = try read(bytesCount).copyBytes(to: ptr)
    }
    return endian.convert(value)
  }

  @inlinable
  mutating func readInteger<T: FixedWidthInteger>(endian: Endianness = .big, as: T.Type = T.self) throws -> T {
    var value: T = 0
    try withUnsafeMutableBytes(of: &value) { ptr in
      _ = try read(MemoryLayout<T>.size).copyBytes(to:  ptr)
    }
    return endian.convert(value)
  }

  /// Read UTF-8 String
  /// - Parameter count: utf8 unit count
  /// - Throws: read error
  /// - Returns: String
  @inlinable
  mutating func readString(_ count: Int) throws -> String {
    String(decoding: try read(count), as: UTF8.self)
  }

  @inlinable
  mutating func readAsByteReader(_ count: Int) throws -> ByteReader<ByteRegion> {
    try .init(read(count))
  }

  @inlinable
  mutating func readAsBitReader<T: FixedWidthInteger>(_ type: T.Type, endian: Endianness = .big) throws -> BitReader<T> {
    try .init(readInteger(endian: endian))
  }

  @inlinable
  mutating func readByte() throws -> UInt8 {
    let b = try read(1)
    return b[b.startIndex]
  }

  @inlinable
  var unreadBytesCount: Int {
    count - numericCast(readerOffset)
  }

  @inlinable
  var isAtEnd: Bool {
    unreadBytesCount == 0
  }

  @inlinable
  mutating func skip(_ count: Int) throws {
    try seek(to: readerOffset + count)
  }
}

// MARK: Help Utilities
extension ByteRegionReaderProtocol {
  @inlinable
  func checkCanRead(count: Int) throws {
    precondition(count >= 0)
    try preconditionOrThrow(count <= unreadBytesCount, ByteRegionReaderError.noEnoughBytes)
  }

  @inlinable
  func checkCanSeek(to offset: Int) throws {
    try preconditionOrThrow((0...count).contains(offset), ByteRegionReaderError.outRange)
  }
}
