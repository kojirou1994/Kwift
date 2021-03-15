import Precondition

public enum BCDCoding {

  // 99 -> 0b10011001
  public static func encode(_ value: UInt8) throws -> UInt8 {
    try preconditionOrThrow((0...99).contains(value), "BCD value \(value) overflows.")

    if _slowPath(value < 10) {
      return value
    }
    return ((value / 10) << 4) ^ (value % 10)
  }

  public static func decode(_ value: UInt8) throws -> UInt8 {
    let left = value >> 4
    let right = value & 0x0F

    try preconditionOrThrow((0...9).contains(left), "Encoded BCD value left part \(left) overflows.")
    try preconditionOrThrow((0...9).contains(right), "Encoded BCD value right part \(right) overflows.")

    return (left * 10) + right
  }
}
