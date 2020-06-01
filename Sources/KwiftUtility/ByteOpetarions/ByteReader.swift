import Foundation

public protocol ByteRegionReaderProtocol {
  associatedtype ByteRegion: DataProtocol

  var readerIndex: Int {get}
  func read(_ count: Int) -> ByteRegion
  func skip(_ count: Int)
}

extension FileHandle: ByteRegionReaderProtocol {
  public var readerIndex: Int {
    numericCast(offsetInFile)
  }

  public func read(_ count: Int) -> Data {
    if #available(OSX 10.15, *) {
      return try! read(upToCount: count) ?? Data()
    } else {
      return readData(ofLength: count)
    }
  }

  public func skip(_ count: Int) {
    let toOffset = offsetInFile + numericCast(count)
    if #available(OSX 10.15, *) {
      try! seek(toOffset: toOffset)
    } else {
      seek(toFileOffset: toOffset)
    }
  }
}

public class ByteReader<C: DataProtocol>: ByteRegionReaderProtocol where C.Index == Int {

  @usableFromInline
  internal var currentIndex: Int

  @inlinable
  public var readerIndex: Int { currentIndex }

  @inlinable
  public func seek(to offset: Int) {
    precondition((data.startIndex + offset)<=data.endIndex)
    currentIndex = offset
  }

  public let data: C

  @inlinable
  public init(data: C) {
    self.data = data
    currentIndex = data.startIndex
  }

  @inlinable
  public func read(_ count: Int) -> C.SubSequence {
    precondition((currentIndex + count)<=data.endIndex)
    defer {
      currentIndex += count
    }
    return data[currentIndex..<(currentIndex + count)]
  }

  @inlinable
  public func readByte() -> UInt8 {
    precondition((currentIndex + 1)<=data.endIndex)
    defer {
      currentIndex += 1
    }
    return data[currentIndex]
  }

  @inlinable
  public func readInteger<T: FixedWidthInteger>(endian: Endianness = .big, as: T.Type = T.self) -> T {
    var value: T = 0
    withUnsafeBytes(of: &value) { ptr in
      _ = read(MemoryLayout<T>.size).copyBytes(to: .init(mutating: ptr))
    }
    return endian.convert(value)
  }

  @inlinable
  public var currentByte: UInt8 {
    data[currentIndex]
  }

  @inlinable
  public func skip(_ count: Int) {
    precondition((currentIndex + count)<=data.endIndex)
    currentIndex += count
  }

  @inlinable
  public func readToEnd() -> C.SubSequence {
    if isAtEnd {
      return data[data.endIndex..<data.endIndex]
    } else {
      defer { currentIndex = data.endIndex }
      return data[currentIndex..<data.endIndex]
    }
  }

  @inlinable
  public var isAtEnd: Bool {
    currentIndex == (data.endIndex)
  }

  @inlinable
  public var restBytesCount: Int {
    data.endIndex - currentIndex
  }

}
