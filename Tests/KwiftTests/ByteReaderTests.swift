import XCTest
import ByteOpetarions

class ByteReaderTests: XCTestCase {

  func testReadIntergerWithBytesCount() throws {
    let bytes = [0x01, 0x02, 0x03, 0x04] as [UInt8]

    var reader = ByteReader(bytes)

    let bigEndianInt32 = try reader.readInteger(bytesCount: 3, endian: .big, as: Int32.self)
    print(bigEndianInt32.hexString())
    XCTAssertEqual(bigEndianInt32, 0x01020300)

    try reader.seek(to: 0)

    let littleEndianInt32 = try reader.readInteger(bytesCount: 3, endian: .little, as: Int32.self)
    XCTAssertEqual(littleEndianInt32, 0x030201)
  }
}
