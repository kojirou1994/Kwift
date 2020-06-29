import Foundation

public enum ImageFormat: String, CaseIterable {

  case jpeg
  case png
//  case gif

  public init<D: DataProtocol>(_ data: D) throws {
    var reader = ByteReader(data)
    try self.init(reader: &reader)
  }

  init<T: ByteRegionReaderProtocol>(reader: inout T) throws {
    self = try ImageFormat.allCases.first(
      where: { format in
        try format.match(&reader)
      }).unwrap("No matched ImageFormat.")
  }

  @inlinable
  internal var headerLength: Int {
    switch self {
//    case .gif: return 6
    case .jpeg: return 2
    case .png: return 8
    }
  }

  private func match<D: ByteRegionReaderProtocol>(_ reader: inout D) throws -> Bool {
    try reader.seek(to: 0)
    if reader.count < headerLength {
      return false
    }
    switch self {
    case .jpeg:
      let header = try reader.readInteger(endian: .big, as: UInt16.self)
      return header == 0xffd8
    case .png:
      let header = try reader.readInteger(endian: .big, as: UInt64.self)
      return header == 0x89504e470d0a1a0a
    }
  }

  public var mimeType: String {
    "image/\(rawValue)"
  }

}
