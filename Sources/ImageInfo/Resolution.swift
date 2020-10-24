import KwiftExtension

public struct Resolution: Hashable, Equatable, CustomStringConvertible {

  public var width: UInt32

  public var height: UInt32

  public var size: UInt {
    UInt(width) * UInt(height)
  }

  public init(width: UInt32, height: UInt32) {
    self.width = width
    self.height = height
  }

  public init?<S: StringProtocol>(_ text: S, separator: Character = "x") {
    guard let xIndex = text.firstIndex(of: separator),
      let width = UInt32(text[..<xIndex].trim({$0.isWhitespace})),
      let height = UInt32(text[text.index(after: xIndex)...].trim({$0.isWhitespace})) else {
        return nil
    }
    self.width = width
    self.height = height
  }

  public var description: String {
    "\(width)x\(height)"
  }

  public var ratio: Double {
    precondition(height != 0)
    return Double(width) / Double(height)
  }

}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGSize {
  @inlinable
  public init(_ resolution: Resolution) {
    self.init(width: CGFloat(resolution.width), height: CGFloat(resolution.height))
  }
}

extension Resolution {
  @inlinable
  public init(_ size: CGSize) {
    self.init(width: UInt32(size.width), height: UInt32(size.height))
  }
}

extension CGImage {
  @inlinable
  public var resolution: Resolution {
    .init(width: numericCast(width), height: numericCast(height))
  }
}
#endif
