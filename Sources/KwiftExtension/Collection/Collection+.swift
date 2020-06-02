extension Collection where Element: Collection, Element.SubSequence: Equatable {

    public var longestCommonPrefix: Element.SubSequence? {
        guard let firstV = self.first, !contains(where: {$0.isEmpty}) else {
            return nil
        }
        var result = firstV[firstV.startIndex...]
        var resultLength = result.count
        var lastInvalidIndex = self.startIndex
        while let invalidIndex = self[lastInvalidIndex...]
            .firstIndex(where: { $0.prefix(resultLength) != result }) {
                result = result.dropLast()
                resultLength -= 1
                lastInvalidIndex = invalidIndex
        }
        if result.isEmpty {
            return nil
        }
        return result
    }

    public var longestCommonSuffix: Element.SubSequence? {
        guard let firstV = self.first else {
            return nil
        }
        var result = firstV[firstV.startIndex...]
        var resultLength = result.count
        var lastInvalidIndex = self.startIndex
        while let invalidIndex = self[lastInvalidIndex...]
            .firstIndex(where: { $0.suffix(resultLength) != result }) {
                result = result.dropFirst()
                resultLength = result.count
                lastInvalidIndex = invalidIndex
        }
        if result.isEmpty {
            return nil
        }
        return result
    }

}

extension Collection where Element: Equatable {

    @inlinable
    public func indexes(of element: Element) -> [Index] {
        indexes(where: {$0 == element})
    }

}

extension Collection {

    @inlinable
    public func indexes(where predicate: (Element) throws -> Bool) rethrows -> [Index] {
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
