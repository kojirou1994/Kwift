extension Collection where Element: Equatable {

  public func commonPrefix<T: Sequence>(with another: T) -> SubSequence where T.Element == Element {
    if self.isEmpty {
      return self[endIndex...]
    }
    var sliceEndIndex = startIndex

    for anotherElement in another {
      if sliceEndIndex == endIndex || self[sliceEndIndex] != anotherElement {
        break
      }
      self.formIndex(after: &sliceEndIndex)
    }

    return self[..<sliceEndIndex]
  }
}

extension BidirectionalCollection where Element: Equatable {

  public func commonSuffix<T: BidirectionalCollection>(with another: T) -> SubSequence where T.Element == Element {
    if self.isEmpty || another.isEmpty {
      return self[endIndex...]
    }
    var sliceStartIndex = endIndex
    var currentIndex = index(before: endIndex)

    for anotherElement in another.reversed() {
      if self[currentIndex] == anotherElement {
        sliceStartIndex = currentIndex
        if currentIndex == startIndex {
          break
        } else {
          formIndex(before: &currentIndex)
        }
      } else {
        break
      }
    }

    return self[sliceStartIndex...]
  }
}
extension Collection where Element: Collection, Element.Element: Equatable {

  /// Longest common prefix, O(m*n)
  public var commonPrefix: Element.SubSequence? {
    guard let firstValue = self.first, allSatisfy({!$0.isEmpty}) else {
      return nil
    }

    var commonPrefix = firstValue[...]
    var currentIndex = index(after: startIndex)
    if currentIndex == endIndex {
      return nil
    }
    while currentIndex != endIndex, !commonPrefix.isEmpty {
      commonPrefix = self[currentIndex].commonPrefix(with: commonPrefix)
      formIndex(after: &currentIndex)
    }
    if commonPrefix.isEmpty {
      return nil
    }
    return commonPrefix
  }
}

extension Collection where Element: BidirectionalCollection, Element.Element: Equatable {

  /// Longest common suffix, O(m*n)
  public var commonSuffix: Element.SubSequence? {
    guard let firstValue = self.first, allSatisfy({!$0.isEmpty}) else {
      return nil
    }

    var commonSuffix = firstValue[...]
    var currentIndex = index(after: startIndex)
    if currentIndex == endIndex {
      return nil
    }
    while currentIndex != endIndex, !commonSuffix.isEmpty {
      commonSuffix = self[currentIndex].commonSuffix(with: commonSuffix)
      formIndex(after: &currentIndex)
    }
    if commonSuffix.isEmpty {
      return nil
    }
    return commonSuffix
  }

}

public extension Collection {

  @inlinable
  func indexes(of element: Element) -> [Index] where Element: Equatable {
    indexes(where: {$0 == element})
  }

  @inlinable
  func indexes(where predicate: (Element) throws -> Bool) rethrows -> [Index] {
    try indices.filter { try predicate(self[$0]) }
  }

}

// MARK: UTF8 String
extension Collection where Element == UInt8 {
  @inlinable
  public var utf8String: String {
    .init(decoding: self, as: UTF8.self)
  }
}
