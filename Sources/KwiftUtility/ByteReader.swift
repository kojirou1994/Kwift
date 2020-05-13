import Foundation

public typealias DataHandle = ByteReader<Data>

public class ByteReader<C> where C: Collection, C.Element == UInt8, C.Index == Int {

  public var currentIndex: Int

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
