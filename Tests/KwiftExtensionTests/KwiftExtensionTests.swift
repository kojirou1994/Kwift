import XCTest
@testable import KwiftExtension

class KwiftExtensionTests: XCTestCase {
    
  func testStringSubscript() {
    let str = "0123456789"
    XCTAssertEqual(str[0...5], "012345")
    XCTAssertEqual(str[0..<5], "01234")
    XCTAssertEqual(str[..<5], str[0..<5])
    XCTAssertEqual(str[5...], str[5..<str.count])
    XCTAssertEqual(str[2...7], "234567")
    XCTAssertEqual(str[2..<7], "23456")
    for i in 0..<str.count {
      XCTAssertEqual(str[i], Character.init(i.description))
    }
  }

  func testStringCharacterPartialSubscript() {
    let str = "ABCD"
    XCTAssertEqual(str[..<"B"], "A")
    XCTAssertEqual(str[..."B"], "AB")
    XCTAssertEqual(str["B"...], "BCD")

    let subStr = str.dropFirst()
    XCTAssertEqual(subStr[..<"B"], "")
    XCTAssertEqual(subStr[..."B"], "B")
    XCTAssertEqual(subStr["B"...], "BCD")
  }

  func testSafeFilename() {
    let unsafeFilename = String(repeating: "/1", count: 100)
    XCTAssertEqual(unsafeFilename.safeFilename(), String(repeating: "_1", count: 100))
    measure {
      _ = unsafeFilename.safeFilename()
    }
  }
    
  func testUnwrapOptional() {
    let nilValue: Int? = nil
    XCTAssertThrowsError(try nilValue.unwrap())
    let value: Int? = 5
    XCTAssertNoThrow(try value.unwrap())
  }

  func testCheckEmptyCollection() {
    XCTAssertThrowsError(try EmptyCollection<Int>().notEmpty())
  }

  func testLongestCommonPrefix() {
    let prefix = "FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD"
    let samples = (1...1_000).map { "\(prefix)\($0)" }
    XCTAssertEqual("FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD", samples.longestCommonPrefix)
    measure {
      _ = samples.longestCommonPrefix
    }
  }

  func testSortKeyPath() {
    struct Wrapper {
      let value: Int
    }
    let data = (1...100).reversed()
    let wrappers = data.map(Wrapper.init(value:))
    XCTAssertEqual(data.sorted(), wrappers.sorted(by: \.value).map{$0.value})
  }

  func testLongestCommonSuffix() {
    let result = "FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD"
    let samples = (1...1_000).map { "\($0)\(result)" }
    measure {
      XCTAssertEqual("FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD", samples.longestCommonSuffix)
    }
  }
    
  static var allTests : [(String, (KwiftExtensionTests) -> () throws -> Void)] {
    return [
      ("testStringSubscript", testStringSubscript),
      ("testStringCharacterPartialSubscript", testStringCharacterPartialSubscript),
      ("testSafeFilename", testSafeFilename),
      ("testUnwrapOptional", testUnwrapOptional),
      ("testCheckEmptyCollection", testCheckEmptyCollection),
      ("testLongestCommonPrefix", testLongestCommonPrefix),
      ("testSortKeyPath", testSortKeyPath),
      ("testLongestCommonSuffix", testLongestCommonSuffix)
    ]
  }
}
