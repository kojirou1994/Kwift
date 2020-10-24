public struct LazySplitSequence<Base: Collection>: LazySequenceProtocol, IteratorProtocol where Base.Element: Equatable {
  public init(base: Base, separator: Base.Element, omittingEmptySubsequences: Bool) {
    self.currentIndex = base.startIndex
    self.base = base
    self.separator = separator
    self.omittingEmptySubsequences = omittingEmptySubsequences
  }

  public var currentIndex: Base.Index
  public let base: Base
  public let separator: Base.Element
  public let omittingEmptySubsequences: Bool

  @inlinable
  public mutating func next() -> Base.SubSequence? {
    func isValid(end: Base.Index) -> Bool {
      if currentIndex == end, omittingEmptySubsequences {
        return false
      }
      return true
    }
    while currentIndex != base.endIndex {
      if let delimiterIndex = base[currentIndex...].firstIndex(of: separator) {
        defer { currentIndex = base.index(after: delimiterIndex) }
        if isValid(end: delimiterIndex) {
          return base[currentIndex..<delimiterIndex]
        }
      } else {
        defer { currentIndex = base.endIndex }
        if isValid(end: base.endIndex) {
          return base[currentIndex...]
        }
      }
    }
    return nil
  }
}

extension Collection where Element: Equatable, SubSequence: Collection {
  public func lazySplit(separator: Element, omittingEmptySubsequences: Bool = true) -> LazySplitSequence<Self> {
    .init(base: self, separator: separator, omittingEmptySubsequences: omittingEmptySubsequences)
  }
}
