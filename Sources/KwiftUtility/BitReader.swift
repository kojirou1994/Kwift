public struct BitReader<T: FixedWidthInteger> {

  public let value: T

  @usableFromInline
  internal var _offset: UInt8 = 0

  @usableFromInline
  internal let bitWidth: UInt8

  @inlinable
  public init(_ value: T) {
    self.value = value
    bitWidth = .init(T.bitWidth)
  }

  @inlinable
  public var offset: UInt8 {
    get {
      _offset
    }
    _modify {
      yield &_offset
      precondition((0...bitWidth).contains(_offset))
    }
  }

  @inlinable
  public var availableBitCount: UInt8 {
    bitWidth - _offset
  }

  @inlinable
  public var isAtEnd: Bool {
    _offset == T.bitWidth
  }

  @inlinable
  public mutating func readBit() -> T? {
    read(1)
  }

  @inlinable
  public mutating func readByte() -> UInt8? {
    read(8).map { UInt8(truncatingIfNeeded: $0) }
  }

  @inlinable
  public mutating func readBool() -> Bool? {
    read(1).map {$0 != 0}
  }

  @inlinable
  public mutating func readAll() -> T? {
    read(availableBitCount)
  }

  @inlinable
  public mutating func read(_ count: UInt8) -> T? {
    guard availableBitCount >= count, count > 1 else {
      return nil
    }
    defer {
      _offset += count
    }

    return (value << _offset) >> (bitWidth-count)
  }
}
