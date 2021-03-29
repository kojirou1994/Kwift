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

    XCTAssertEqual(number.bytes, number.toBytes(endian: .big))
    XCTAssertEqual(number.toBytes(endian: .big), bigEndianBytes)
    XCTAssertEqual(number.toBytes(endian: .little), littleEndianBytes)

    var slowBytes = [UInt8]()
    number.forEachByte(endian: .big) { slowBytes.append($0) }
    XCTAssertEqual(slowBytes, bigEndianBytes)

    slowBytes.removeAll(keepingCapacity: true)
    number.forEachByte(endian: .little) { slowBytes.append($0) }
    XCTAssertEqual(slowBytes, littleEndianBytes)

    XCTAssertEqual(bigEndianBytes.joined(endian: .big, UInt64.self), number)
    XCTAssertEqual(littleEndianBytes.joined(endian: .little, UInt64.self), number)
    XCTAssertEqual(bigEndianBytes.joined(endian: .big, UInt64.self), bigEndianBytes.joined(endian: .little, UInt64.self).byteSwapped)

    measure {
      _ = bigEndianBytes.joined(UInt64.self)
    }

    // not enough byte sequence
    let byteSequence: [UInt8] = [0x12, 0x34]
    XCTAssertEqual(byteSequence.joined(endian: .little, UInt8.self), 0x12)
    XCTAssertEqual(byteSequence.joined(endian: .little, UInt8.self), byteSequence.joined(endian: .big, UInt8.self))
    XCTAssertEqual(byteSequence.joined(endian: .little, UInt16.self), 0x3412)
    XCTAssertEqual(byteSequence.joined(endian: .big, UInt16.self), 0x1234)
    XCTAssertEqual(byteSequence.joined(endian: .little, UInt64.self), 0x3412)
    XCTAssertEqual(byteSequence.joined(endian: .big, UInt64.self), 0x1234)
  }

  func testBytesToString() {
    let uint8: UInt8 = 0b11110000
    XCTAssertEqual(uint8.binaryString(prefix: "0b"), "0b11110000")
    XCTAssertEqual(uint8.binaryString(prefix: ""), "11110000")

    let uint64: UInt64 = 0b11110000
    XCTAssertEqual(uint64.binaryString(prefix: "0b"), "0b11110000")

    let bytes: [UInt8] = [0x12, 0x34, 0x56]
    XCTAssertEqual(bytes.hexString(uppercase: false, prefix: "0x"), "0x123456")
    XCTAssertEqual(bytes.hexString(uppercase: false, prefix: ""), "123456")
    XCTAssertEqual(bytes.joined(UInt.self).hexString(), "0x123456")
  }

  func testBitReader() {
    let number = UInt.random(in: 0..<UInt.max)
    let bigEndianBytes = number.toBytes(endian: .big)
    var reader = BitReader(number)

    XCTAssertEqual(reader.offset, 0)

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

    let uint64 = 0x01020304_05060708 as UInt64
    var uint64Reader = BitReader(uint64)
    var expectedResult: UInt8 = 0x01
    while let byte = uint64Reader.readByte() {
      XCTAssertEqual(byte, expectedResult)
      expectedResult += 1
    }

    uint64Reader.offset = 0
    XCTAssertEqual(uint64Reader.readAll(), uint64)

    var boolReader = BitReader(0b11111111 as UInt8)
    while !boolReader.isAtEnd {
      XCTAssertEqual(boolReader.readBool(zeroValue: true), false)
    }
    boolReader.offset = 0
    while !boolReader.isAtEnd {
      XCTAssertEqual(boolReader.readBool(zeroValue: false), true)
    }
  }

}
