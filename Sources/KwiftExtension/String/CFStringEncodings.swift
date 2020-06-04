#if canImport(Darwin)
import CoreFoundation

extension String.Encoding {

  @inlinable
  public init(_ cfEncoding: CFStringEncodings) {
    self.init(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue)))
  }

}
#endif
