// MARK: Blank String
extension StringProtocol {

  @inlinable
  public var isBlank: Bool {
    allSatisfy {$0.isWhitespace}
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

// MARK: Utilities
extension StringProtocol {

  // MARK: Native trim function
  @inlinable
  public func trim(_ predicate: (Character) -> Bool) -> SubSequence {
    guard let start = firstIndex(where: { !predicate($0) }),
      let end = lastIndex(where: { !predicate($0) }),
      start <= end else {
        return self[startIndex..<startIndex]
    }
    return self[start...end]
  }

  @inlinable
  public func firstUppercased() -> String {
    guard let firstLetter = first?.uppercased() else {
      return ""
    }
    return firstLetter + dropFirst()
  }

}
