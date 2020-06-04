// MARK: Character Partial Range Subscript
extension StringProtocol {

  @inlinable
  public subscript(bounds: PartialRangeFrom<Character>) -> SubSequence? {
    guard let tempIndex = firstIndex(of: bounds.lowerBound) else {
      return nil
    }
    return self[tempIndex...]
  }

  @inlinable
  public subscript(bounds: PartialRangeUpTo<Character>) -> SubSequence? {
    guard let tempIndex = firstIndex(of: bounds.upperBound) else {
      return nil
    }
    return self[..<tempIndex]
  }

  /// "ABCD"[..."B"]
  @inlinable
  public subscript(bounds: PartialRangeThrough<Character>) -> SubSequence? {
    guard let tempIndex = firstIndex(of: bounds.upperBound) else {
      return nil
    }
    return self[...tempIndex]
  }

}
