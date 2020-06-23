import Foundation

extension JSONDecoder {

  @inline(__always) @inlinable @_transparent
  public func kwiftDecode<T>(from json: [String: Any], as: T.Type = T.self) throws -> T where T : Decodable {
    try autoreleasepool {
      try decode(T.self, from: JSONSerialization.data(withJSONObject: json, options: []))
    }
  }

  @inline(__always) @inlinable @_transparent
  public func kwiftDecode<D, T>(from bytes: D, as: T.Type = T.self) throws -> T where D: ContiguousBytes, T: Decodable {
    try bytes.withUnsafeBytes { (ptr) -> T in
      try autoreleasepool {
        try decode(T.self, from: (bytes as? Data) ?? Data(bytesNoCopy: UnsafeMutableRawPointer(mutating: ptr.baseAddress!), count: ptr.count, deallocator: .none))
      }
    }
  }

}
