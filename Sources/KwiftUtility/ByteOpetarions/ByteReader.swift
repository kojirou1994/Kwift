import Foundation

public enum ByteRegionReaderError: Error {
  case noEnoughBytes
  case outRange
}

public protocol ByteRegionReaderProtocol {
  associatedtype ByteRegion: DataProtocol

  var readerIndex: ByteRegion.Index {get}
  mutating func read(_ count: Int) throws -> ByteRegion
  mutating func skip(_ count: Int) throws
}

extension FileHandle: ByteRegionReaderProtocol {
  public var readerIndex: Int {
    if #available(OSX 10.15.4, *) {
      return numericCast(try! offset())
    } else {
      return numericCast(offsetInFile)
    }
  }

  public func read(_ count: Int) throws -> Data {
    let d: Data
    if #available(OSX 10.15.4, *) {
      d = try read(upToCount: count) ?? Data()
    } else {
      d = readData(ofLength: count)
    }
    if d.count != count {
      throw ByteRegionReaderError.noEnoughBytes
    }
    return d
  }

  public func skip(_ count: Int) throws {
    if #available(OSX 10.15.4, *) {
      let oldOffset = try offset()
      let toOffset = oldOffset + numericCast(count)
      try seek(toOffset: toOffset)
    } else {
      let oldOffset = offsetInFile
      let toOffset = oldOffset + numericCast(count)
      seek(toFileOffset: toOffset)
    }
  }
}

public struct ByteReader<C: DataProtocol>: ByteRegionReaderProtocol {

  @usableFromInline
  internal var currentIndex: C.Index

  @inlinable
  public var readerIndex: C.Index { currentIndex }

  @inlinable
  public mutating func seek(to offset: Int) {
    precondition(offset >= 0)
    let newIndex = data.index(data.startIndex, offsetBy: offset)
    precondition(newIndex<=data.endIndex)
    currentIndex = newIndex
  }

  public let data: C

  @inlinable
  public init(_ data: C) {
    self.data = data
    currentIndex = data.startIndex
  }

  @inlinable
  public mutating func read(_ count: Int) throws -> C.SubSequence {
    precondition(count >= 0)
    let newIndex = data.index(currentIndex, offsetBy: count)
    if newIndex > data.endIndex {
      throw ByteRegionReaderError.noEnoughBytes
    }
    defer {
      currentIndex = newIndex
    }
    return data[currentIndex..<newIndex]
  }

  @inlinable
  public mutating func readString(_ count: Int) throws -> String {
    try .init(decoding: read(count), as: UTF8.self)
  }

  @inlinable
  public mutating func readByte() throws -> UInt8 {
    let newIndex = data.index(currentIndex, offsetBy: 1)
    if newIndex > data.endIndex {
      throw ByteRegionReaderError.noEnoughBytes
    }
    defer {
      currentIndex = newIndex
    }
    return data[currentIndex]
  }

  @inlinable
  public mutating func readInteger<T: FixedWidthInteger>(endian: Endianness = .big, as: T.Type = T.self) throws -> T {
    var value: T = 0
    try withUnsafeBytes(of: &value) { ptr in
      _ = try read(MemoryLayout<T>.size).copyBytes(to: .init(mutating: ptr))
    }
    return endian.convert(value)
  }

  @inlinable
  public var currentByte: UInt8 {
    data[currentIndex]
  }

  @inlinable
  public mutating func skip(_ count: Int) throws {
    let newIndex = data.index(currentIndex, offsetBy: count)
    if !(data.startIndex...data.endIndex).contains(newIndex) {
      throw ByteRegionReaderError.outRange
    }
    currentIndex = newIndex
  }

  @inlinable
  public mutating func readToEnd() -> C.SubSequence {
    defer { currentIndex = data.endIndex }
    return data[currentIndex..<data.endIndex]
  }

  @inlinable
  public var isAtEnd: Bool {
    currentIndex == data.endIndex
  }

  @inlinable
  public var restBytesCount: Int {
    data.distance(from: currentIndex, to: data.endIndex)
  }

}
