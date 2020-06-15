import Foundation

extension CharacterSet: ExpressibleByStringLiteral {

  @_transparent
  public init(stringLiteral value: String) {
    self.init(charactersIn: value)
  }

}
