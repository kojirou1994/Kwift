extension Bool {

  /// c bool convertion
  /// - Parameter cValue: 0 is false
  @inlinable
  public init<T: FixedWidthInteger>(cValue: T) {
    self = cValue != 0
  }

}

extension FixedWidthInteger {
  @inlinable
  /// 0 is false
  public var cBool: Bool {
    self != 0
  }
}
