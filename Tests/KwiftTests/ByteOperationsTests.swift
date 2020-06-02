import XCTest
@testable import KwiftUtility

class ByteOperationsTests: XCTestCase {

  func testByteAndIntegerConvertion() {
    let number: UInt64 = 0x12345678_87654321
    let bigEndianBytes: [UInt8] = [
      0x12, 0x34, 0x56, 0x78,
      0x87, 0x65, 0x43, 0x21
    ]
    let littleEndianBytes: [UInt8] = bigEndianBytes.reversed()

    XCTAssertEqual(number.toBytes(endian: .big), bigEndianBytes)
    XCTAssertEqual(number.toBytes(endian: .little), littleEndianBytes)

    var slowBytes = [UInt8]()
    number.forEachByte(endian: .big) { slowBytes.append($0) }
    XCTAssertEqual(slowBytes, bigEndianBytes)

    slowBytes.removeAll(keepingCapacity: true)
    number.forEachByte(endian: .little) { slowBytes.append($0) }
    XCTAssertEqual(slowBytes, littleEndianBytes)

    XCTAssertEqual(bigEndianBytes.joined(UInt64.self), number)
    XCTAssertEqual(littleEndianBytes.joined(UInt64.self).byteSwapped, number)

    measure {
      _ = bigEndianBytes.joined(UInt64.self)
    }

  }

  func testBitReader() {
    let number = UInt.random(in: 0..<UInt.max)
    let bigEndianBytes = number.toBytes(endian: .big)
    var reader = BitReader(number)
    XCTAssertNil(reader.read(UInt8(UInt.bitWidth + 1)))
    bigEndianBytes.forEach { byte in
      let readByte = reader.read(8)
      XCTAssertNotNil(readByte)
      XCTAssertEqual(UInt(byte), readByte!)
    }

    XCTAssertTrue(reader.isAtEnd)

    let uint8Number = UInt8.random(in: 0...UInt8.max)
    var joinedByte: UInt8 = 0
    var byteReader = BitReader(uint8Number)
    while !byteReader.isAtEnd {
      joinedByte = (joinedByte << 1) | byteReader.readBit()!
    }

    XCTAssertEqual(joinedByte, uint8Number)

    var zeroReader = BitReader<UInt8>(0)
    while !zeroReader.isAtEnd {
      XCTAssertTrue(zeroReader.readBool(zeroValue: true)!)
    }
    zeroReader.offset = 0
    while !zeroReader.isAtEnd {
      XCTAssertTrue(!zeroReader.readBool(zeroValue: false)!)
    }
  }

}
