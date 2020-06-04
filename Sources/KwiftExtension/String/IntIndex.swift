// MARK: Int based Subscript
extension StringProtocol {

  @inlinable
  func calculateIndex(_ lowerBound: Int, _ upperBound: Int) -> (Index, Index) {
    let lowerIndex = index(startIndex, offsetBy: lowerBound)
    let upperIndex = index(lowerIndex, offsetBy: upperBound - lowerBound)
    return (lowerIndex, upperIndex)
  }

  @inlinable
  public subscript(bounds: Range<Int>) -> SubSequence {
    let (lowerIndex, upperIndex) = calculateIndex(bounds.lowerBound, bounds.upperBound)
    return self[lowerIndex..<upperIndex]
  }

  @inlinable
  public subscript(bounds: ClosedRange<Int>) -> SubSequence {
    let (lowerIndex, upperIndex) = calculateIndex(bounds.lowerBound, bounds.upperBound)
    return self[lowerIndex...upperIndex]
  }

  @inlinable
  public subscript(bounds: PartialRangeFrom<Int>) -> SubSequence {
    self[index(startIndex, offsetBy: bounds.lowerBound)...]
  }

  @inlinable
  public subscript(bounds: PartialRangeUpTo<Int>) -> SubSequence {
    self[..<index(startIndex, offsetBy: bounds.upperBound)]
  }

  @inlinable
  public subscript(bounds: PartialRangeThrough<Int>) -> SubSequence {
    self[...index(startIndex, offsetBy: bounds.upperBound)]
  }

  @inlinable
  public subscript(i: Int) -> Character {
    self[index(startIndex, offsetBy: i)]
  }

}
