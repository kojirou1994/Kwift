import Foundation

public struct StdError: Error, CustomStringConvertible, Equatable, Hashable, RawRepresentable {

  public let rawValue: Int32

  @_transparent
  public static var current: Self {
    .init(rawValue: errno)
  }

  @_transparent
  public init(rawValue: Int32) {
    self.rawValue = rawValue
  }

  @_transparent
  public var description: String {
    String(cString: strerror(rawValue))
  }
  
}
