import Foundation

public enum ImageFormat: String, CaseIterable {

  case jpeg
  case png
//  case gif

  public init<D: DataProtocol>(_ data: D) throws {
    self = try ImageFormat.allCases.first(where: {$0.match(data)}).unwrap("No matched ImageFormat.")
  }

  @inlinable
  internal var headerLength: Int {
    switch self {
//    case .gif: return 6
    case .jpeg: return 2
    case .png: return 8
    }
  }

  private func match<D: DataProtocol>(_ data: D) -> Bool {
    if data.count < headerLength {
      return false
    }
    switch self {
    case .jpeg:
      var reader = ByteReader(data)
      let header = try! reader.readInteger(endian: .big, as: UInt16.self)
      return header == 0xffd8
    case .png:
      var reader = ByteReader(data)
      let header = try! reader.readInteger(endian: .big, as: UInt64.self)
      return header == 0x89504e470d0a1a0a
    }
  }

  public var mimeType: String {
    "image/\(rawValue)"
  }

}
