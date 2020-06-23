#if canImport(CryptoKit)
import Foundation
import CryptoKit

// MARK: - v3/v5 UUID
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension UUID {

  public static func v5(namespace: UUID, name: String) -> Self {
    calculate(namespace: namespace, name: name, version: 5 << 4, hash: Insecure.SHA1.self)
  }

  public static func v3(namespace: UUID, name: String) -> Self {
    calculate(namespace: namespace, name: name, version: 3 << 4, hash: Insecure.MD5.self)
  }

  @inlinable @inline(__always)
  internal static func calculate<H: HashFunction>(namespace: UUID, name: String, version: UInt8, hash: H.Type) -> Self {
    assert(!name.isEmpty)
    assert(H.Digest.byteCount >= 16)

    var hasher = H()

    withUnsafeBytes(of: namespace.uuid) { ptr in
      hasher.update(bufferPointer: ptr)
    }

    var copy = name
    copy.withUTF8 { ptr in
      hasher.update(bufferPointer: UnsafeRawBufferPointer(ptr))
    }
    let digest = hasher.finalize()

    return digest.withUnsafeBytes { buffer in
      .init(uuid: (buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5],
                   (buffer[6] & 0x0F) | version,// set UUID version
                   buffer[7],
                   (buffer[8] & 0x3F) | 0x80,// set variant accordingly to RFC4122 (reserved)
                   buffer[9], buffer[10], buffer[11], buffer[12], buffer[13], buffer[14], buffer[15]))
    }
  }

}
#endif
