// MARK: Int based Subscript
extension StringProtocol where SubSequence == Substring {
    
    @usableFromInline
    func calculateIndex(_ lowerBound: Int, _ upperBound: Int) -> (Index, Index) {
        let lowerIndex = index(startIndex, offsetBy: lowerBound)
        let upperIndex = index(lowerIndex, offsetBy: upperBound - lowerBound)
        return (lowerIndex, upperIndex)
    }
    
    @inlinable
    public subscript(bounds: Range<Int>) -> Substring {
        let (lowerIndex, upperIndex) = calculateIndex(bounds.lowerBound, bounds.upperBound)
        return self[lowerIndex..<upperIndex]
    }
    
    @inlinable
    public subscript(bounds: ClosedRange<Int>) -> Substring {
        let (lowerIndex, upperIndex) = calculateIndex(bounds.lowerBound, bounds.upperBound)
        return self[lowerIndex...upperIndex]
    }
    
    @inlinable
    public subscript(bounds: PartialRangeFrom<Int>) -> Substring {
        self[index(startIndex, offsetBy: bounds.lowerBound)...]
    }
    
    @inlinable
    public subscript(bounds: PartialRangeUpTo<Int>) -> Substring {
        self[..<index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    @inlinable
    public subscript(bounds: PartialRangeThrough<Int>) -> Substring {
        self[...index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    @inlinable
    public subscript(i: Int) -> Character {
        self[index(startIndex, offsetBy: i)]
    }
    
}

// MARK: Character Partial Range Subscript
extension StringProtocol where SubSequence == Substring {

  @inlinable
  public subscript(bounds: PartialRangeFrom<Character>) -> Substring? {
    guard let tempIndex = firstIndex(of: bounds.lowerBound) else {
      return nil
    }
    return self[tempIndex...]
  }

  @inlinable
  public subscript(bounds: PartialRangeUpTo<Character>) -> Substring? {
    guard let tempIndex = firstIndex(of: bounds.upperBound) else {
      return nil
    }
    return self[..<tempIndex]
  }

  /// "ABCD"[..."B"]
  @inlinable
  public subscript(bounds: PartialRangeThrough<Character>) -> Substring? {
    guard let tempIndex = firstIndex(of: bounds.upperBound) else {
      return nil
    }
    return self[...tempIndex]
  }

}
// MARK: Utility

// characterSet contains all illegal characters on OS X and Windows
@usableFromInline let illegalFilenameCharacterSet: Set<Character> = .init("\"\\/?<>:*|\n\r")

extension StringProtocol {

  @inlinable
  public func safeFilename(_ replacingString: String = "_") -> String {
    // TODO: use reserveCapacity method
    reduce(into: "") { result, char in
      if illegalFilenameCharacterSet.contains(char) {
        result.append(replacingString)
      } else {
        result.append(char)
      }
    }
  }
}

#if canImport(Foundation)
import Foundation

extension StringProtocol {
    public func ranges<T>(of aString: T, options mask: String.CompareOptions = [], locale: Locale? = nil) -> [Range<Self.Index>] where T : StringProtocol {
        var result = [Range<Self.Index>]()
        var start = startIndex
        while let range = range(of: aString, options: mask, range: start..<endIndex, locale: locale) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    //    public var firstUppercased: String {
    //        if isEmpty {
    //            return ""
    //        }
    //        let firstC = self[startIndex].uppercased()
    //        return replacingCharacters(in: ...startIndex, with: firstC)
    //    }
    
}

#endif

#if canImport(Darwin)

extension String.Encoding {
    
    @inlinable
    public init(_ cfEncoding: CFStringEncodings) {
        self.init(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue)))
    }
    
}

#endif

extension StringProtocol {
    
    @inlinable
    public var isBlank: Bool {
        allSatisfy {$0.isWhitespace}
    }

    @inlinable
    public func trim(_ predicate: (Character) -> Bool) -> SubSequence {
        guard let start = firstIndex(where: { !predicate($0) }),
            let end = lastIndex(where: { !predicate($0) }),
            start <= end else {
                return self[startIndex..<startIndex]
        }
        return self[start...end]
    }
    
}

extension Optional where Wrapped: StringProtocol {
    
    @inlinable
    public var isBlank: Bool {
        switch self {
        case .none:
            return true
        case .some(let v):
            return v.isBlank
        }
    }
    
}
