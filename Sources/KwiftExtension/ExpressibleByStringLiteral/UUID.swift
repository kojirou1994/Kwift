import Foundation

extension UUID: ExpressibleByStringLiteral {

  @inlinable
  public init(stringLiteral value: String) {
    self.init(uuidString: value)!
  }

}
