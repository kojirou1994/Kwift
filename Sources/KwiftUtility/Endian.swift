public struct Endianness: Equatable {

  public let isLittleEndian: Bool

  @usableFromInline
  internal init(isLittleEndian: Bool) {
    self.isLittleEndian = isLittleEndian
  }

  @inlinable
  public static var big: Self { .init(isLittleEndian: false) }
  
  @inlinable
  public static var little: Self { .init(isLittleEndian: true) }

  public static let host: Self = {
    let number: UInt16 = 0x0001
    return .init(isLittleEndian: number == number.littleEndian)
  }()
}

extension Endianness {

  @inlinable public var needConvert: Bool {
    self.isLittleEndian != Self.host.isLittleEndian
  }

  @inlinable public func convert<T: FixedWidthInteger>(_ value: T) -> T {
    if needConvert {
      return value.byteSwapped
    } else {
      return value
    }
  }

  @inlinable public static func convert<T: FixedWidthInteger>(_ value: T) -> T {
    host.convert(value)
  }
}
