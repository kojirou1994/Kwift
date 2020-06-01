extension FixedWidthInteger {

  @available(*, deprecated)
  public var binaryString: String {
    var result: [String] = []
    let count = Self.bitWidth / 8
    for i in 1...count {
      let byte = UInt8(truncatingIfNeeded: self >> ((count - i) * 8))
      let byteString = String(byte, radix: 2)
      let padding = String(repeating: "0", count: 8 - byteString.count)
      result.append(padding + byteString)
    }
    return "0b" + result.joined(separator: "_")
  }

  @available(*, deprecated)
  public func hexString(uppercase: Bool = false, prefix: String = "0x") -> String {
    var result: [String] = []
    let count = Self.bitWidth / 8
    for i in 1...count {
      let byte = UInt8(truncatingIfNeeded: self >> ((count - i) * 8))
      let byteString = String(byte, radix: 16, uppercase: uppercase)
      let padding = String(repeating: "0", count: 2 - byteString.count)
      result.append(padding + byteString)
    }
    return prefix + result.joined(separator: "")
  }

  @inlinable
  public var bytes: [UInt8] {
    toBytes(endian: .big)
  }

  @inlinable
  public func toBytes(endian: Endianness = .big) -> [UInt8] {
    withUnsafeBytes(of: endian.convert(self)) { ptr in
      [UInt8](unsafeUninitializedCapacity: ptr.count) { (buffer, count) in
        UnsafeMutableRawBufferPointer(buffer).copyMemory(from: ptr)
        count = ptr.count
      }
    }
  }

  @inlinable
  public func forEachByte(endian: Endianness = .host, body: ((UInt8) throws -> Void)) rethrows {
    try withUnsafeBytes(of: self) { ptr in
      if endian.needConvert {
        try ptr.reversed().forEach(body)
      } else {
        try ptr.forEach(body)
      }
    }
  }

}

extension Sequence where Element == UInt8 {

  public func joined<T>(_ type: T.Type) -> T where T : FixedWidthInteger {
    let byteCount = T.bitWidth / 8
    var result = T.init()
    for element in enumerated() {
      if element.offset == byteCount {
        break
      }
      result = (result << 8) | T(truncatingIfNeeded: element.element)
    }
    return result
  }

  @inlinable
  public func joined<T>() -> T where T : FixedWidthInteger {
    joined(T.self)
  }

  @available(*, deprecated)
  public func hexString(uppercase: Bool = false, prefix: String = "0x") -> String {
    prefix + map {$0.hexString(uppercase: uppercase, prefix: "")}.joined()
  }

}
