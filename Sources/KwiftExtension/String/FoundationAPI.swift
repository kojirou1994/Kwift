#if canImport(Foundation)
import Foundation

extension StringProtocol {
  public func ranges<T: StringProtocol>(of aString: T, options mask: String.CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
    var result = [Range<Self.Index>]()
    var start = startIndex
    while let range = range(of: aString, options: mask, range: start..<endIndex, locale: locale) {
      result.append(range)
      start = range.upperBound
    }
    return result
  }
}
#endif
