import XCTest
@testable import KwiftExtension

class BCDCodingTests: XCTestCase {

  func test8421Coding() {

    var validEncodedBCDs = Set<UInt8>()

    for value in UInt8.min...99 {
      // encode
      XCTAssertNoThrow(try BCDCoding.encode(value))
      let encoded = try! BCDCoding.encode(value)
      validEncodedBCDs.insert(encoded)
      XCTAssertEqual(encoded, ((value / 10) << 4) ^ (value % 10))

      // decode
      XCTAssertNoThrow(try BCDCoding.decode(encoded))
      XCTAssertEqual(try! BCDCoding.decode(encoded), value)
    }

    // invalid numbers for encoding
    for invalidNumber in 100...UInt8.max {
      XCTAssertThrowsError(try BCDCoding.encode(invalidNumber))
    }

    // invalid numbers for decoding
    for number in UInt8.min...UInt8.max {
      if !validEncodedBCDs.contains(number) {
        XCTAssertThrowsError(try BCDCoding.decode(number))
      }
    }
  }

}
