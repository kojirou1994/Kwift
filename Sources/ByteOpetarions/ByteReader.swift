import Foundation

public struct ByteReader<C: DataProtocol> {

  @usableFromInline
  internal var currentIndex: C.Index

  public let data: C

  @inlinable
  public init(_ data: C) {
    self.data = data
    currentIndex = data.startIndex
  }

  @inlinable
  public var currentByte: UInt8 {
    data[currentIndex]
  }
}

extension ByteReader: ByteRegionReaderProtocol {

  @inlinable
  public var readerOffset: Int {
    data.distance(from: data.startIndex, to: currentIndex)
  }

  @inlinable
  public var count: Int {
    data.count
  }

  @inlinable
  public var unreadBytesCount: Int {
    data.distance(from: currentIndex, to: data.endIndex)
  }

  @inlinable
  public mutating func seek(to offset: Int) throws {
    try checkCanSeek(to: offset)
    currentIndex = data.index(data.startIndex, offsetBy: offset)
  }

  @inlinable
  public mutating func read(_ count: Int) throws -> C.SubSequence {
    try checkCanRead(count: count)
    let oldIndex = currentIndex
    currentIndex = data.index(currentIndex, offsetBy: count)
    return data[oldIndex..<currentIndex]
  }

  @inlinable
  public mutating func readByte() throws -> UInt8 {
    if currentIndex == data.endIndex {
      throw ByteRegionReaderError.noEnoughBytes
    }
    defer {
      currentIndex = data.index(after: currentIndex)
    }
    return data[currentIndex]
  }

  @inlinable
  public mutating func readAll() throws -> C.SubSequence? {
    if currentIndex == data.endIndex {
      return nil
    } else {
      defer { currentIndex = data.endIndex }
      return data[currentIndex..<data.endIndex]
    }
  }

  @inlinable
  public var isAtEnd: Bool {
    currentIndex == data.endIndex
  }

  @inlinable
  @available(*, unavailable, renamed: "unreadBytesCount")
  public var restBytesCount: Int {
    unreadBytesCount
  }

}
