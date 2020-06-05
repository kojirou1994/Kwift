import XCTest
@testable import KwiftExtension

class StringExtensionTests: XCTestCase {
  func testSafeFilename() {
    let allInvalidCharString = String(illegalFilenameCharacterSet)
    let invalidFilename = "ABCD\(allInvalidCharString)1234"
    XCTAssertTrue(invalidFilename.safeFilename().allSatisfy({!illegalFilenameCharacterSet.contains($0)}))

    var longRandomInvalidFilename = ""
    (1...1_000).forEach { _ in
      longRandomInvalidFilename.append("A你好🐶\(illegalFilenameCharacterSet.randomElement()!)")
    }
    measure {
      _ = longRandomInvalidFilename.safeFilename()
    }
  }

  func testIntIndex() {
    let str = "0123456789"
    XCTAssertEqual(str[0...5], "012345")
    XCTAssertEqual(str[...5], "012345")
    XCTAssertEqual(str[0..<5], "01234")
    XCTAssertEqual(str[..<5], str[0..<5])
    XCTAssertEqual(str[5...], str[5..<str.count])
    XCTAssertEqual(str[2...7], "234567")
    XCTAssertEqual(str[2..<7], "23456")
    for i in 0..<str.count {
      XCTAssertEqual(str[i], Character.init(i.description))
    }
  }

  func testCharacterPartialRange() {
    let str = "ABCD"
    XCTAssertEqual(str[..<"B"], "A")
    XCTAssertEqual(str[..."B"], "AB")
    XCTAssertEqual(str["B"...], "BCD")
    XCTAssertEqual(str[..."E"], nil)
    XCTAssertEqual(str[..<"E"], nil)
    XCTAssertEqual(str["E"...], nil)

    let subStr = str.dropFirst()
    XCTAssertEqual(subStr[..<"B"], "")
    XCTAssertEqual(subStr[..."B"], "B")
    XCTAssertEqual(subStr["B"...], "BCD")
  }

  func testCFStringEncodings() {
    #if canImport(Darwin)
    XCTAssertEqual(String.Encoding(.big5).rawValue,
                  CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))
    #endif
  }

  func testBlankString() {
    let emptyString = ""
    XCTAssertTrue(emptyString.isBlank)
    let blankString = " \t"
    XCTAssertTrue(blankString.isBlank)
    XCTAssertFalse("A".isBlank)
    XCTAssertFalse(" \tA".isBlank)

    var optionalString: String?

    XCTAssertTrue(optionalString.isBlank)

    optionalString = emptyString
    XCTAssertTrue(optionalString.isBlank)

    optionalString = blankString
    XCTAssertTrue(optionalString.isBlank)
    
    optionalString = "A"
    XCTAssertFalse(optionalString.isBlank)
  }

  func testUtilities() {
    // trim
    XCTAssertTrue(" ABCD ".trim({$0.isWhitespace}) == "ABCD")
    XCTAssertTrue("      ".trim({$0.isWhitespace}) == "")

    // first uppercased
    XCTAssertTrue("abc".firstUppercased() == "Abc")
    XCTAssertTrue("".firstUppercased() == "")
    XCTAssertTrue("Abc".firstUppercased() == "Abc")
    XCTAssertTrue("ABC".firstUppercased() == "ABC")
  }

  func testFoundationAPI() {
    // search all ranges
    let string = "A A A"
    let ranges = string.ranges(of: "A")
    XCTAssertEqual(ranges.map{String(string[$0])}, [String].init(repeating: "A", count: 3))
  }
}
