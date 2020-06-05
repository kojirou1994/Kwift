extension FixedWidthInteger {

  public func binaryString(prefix: String = "0b") -> String {
    prefix + String(self, radix: 2)
  }

  public func hexString(uppercase: Bool = false, prefix: String = "0x") -> String {
    prefix + String(self, radix: 16, uppercase: uppercase)
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
  public func forEachByte(endian: Endianness = .big, body: ((UInt8) throws -> Void)) rethrows {
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

  /// use sequence's elements to join a FixedWidthInteger
  /// - Parameters:
  ///   - endian: Endianness, default is big
  ///   - type: FixedWidthInteger type
  /// - Returns: FixedWidthInteger
  public func joined<T>(endian: Endianness = .big, _ type: T.Type = T.self) -> T where T : FixedWidthInteger {
    let byteCount = T.bitWidth / 8
    var result: T = 0
    for element in enumerated() {
      if element.offset == byteCount {
        break
      }
      if endian.isLittleEndian {
        result = result | (T(truncatingIfNeeded: element.element) << (element.offset * 8))
      } else {
        result = (result << 8) | T(truncatingIfNeeded: element.element)
      }
    }
    return result
  }

  public func hexString(uppercase: Bool = false, prefix: String = "0x") -> String {
    reduce(into: prefix) { (result, byte) in
      result.append(String(byte, radix: 16, uppercase: uppercase))
    }
  }

}
