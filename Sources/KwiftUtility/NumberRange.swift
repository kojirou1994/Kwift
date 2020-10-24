/// 1,2-5,6
public struct NumberRange: LosslessStringConvertible, Hashable, Codable, Comparable {

  public var range: ClosedRange<Int>

  public init(range: ClosedRange<Int>) {
    self.range = range
  }

  public init?<S>(_ str: S) where S: StringProtocol {
    let trimmed = str.trim {$0.isWhitespace}
    if let v = Int(trimmed) {
      range = v...v
    } else if let sepIndex = trimmed.firstIndex(of: "-"),
              let l = Int(trimmed[..<sepIndex]),
              case let uStartIndex = trimmed.index(after: sepIndex),
              let u = Int(trimmed[uStartIndex...]) {
      if l <= u {
        range = l...u
      } else {
        #if DEBUG
        print("Range's lowerBound is bigger than upperBound")
        #endif
        return nil
      }
    } else {
      return nil
    }
  }

  public init(from decoder: Decoder) throws {
    let str = try String(from: decoder)
    self = try Self(str).unwrap(DecodingError.typeMismatch(Self.self, .init(codingPath: decoder.codingPath, debugDescription: "Not a valid range: \(str)")))
  }

  public func encode(to encoder: Encoder) throws {
    try description.encode(to: encoder)
  }

  public var description: String {
    if range.lowerBound == range.upperBound {
      return range.lowerBound.description
    }
    return "\(range.lowerBound)-\(range.upperBound)"
  }

  public static func < (lhs: NumberRange, rhs: NumberRange) -> Bool {
    if lhs.range.lowerBound == rhs.range.lowerBound {
      return lhs.range.upperBound < rhs.range.upperBound
    }
    return lhs.range.lowerBound < rhs.range.lowerBound
  }
}
