extension Bool {

  /// c bool convertion
  /// - Parameter cValue: 0 is false
  @_transparent
  public init<T: FixedWidthInteger>(cValue: T) {
    self = cValue != 0
  }

}

extension FixedWidthInteger {
  /// 0 is false
  @_transparent
  public var cBool: Bool {
    self != 0
  }

  /// false is 0
  /// - Parameter cBool: swift Bool
  @_transparent
  public init(cBool: Bool) {
    self = cBool ? 1 : 0
  }
}
