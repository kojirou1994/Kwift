import XCTest
@testable import KwiftExtension

class KwiftExtensionTests: XCTestCase {

  func testAutoreleasepool() {
    autoreleasepool {
      XCTAssertTrue(true)
    }
  }
    
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



  func testSortKeyPath() {
    struct Wrapper {
      let value: Int
    }
    let data = (1...100).reversed()
    let wrappers = data.map(Wrapper.init(value:))
    XCTAssertEqual(data.sorted(), wrappers.sorted(by: \.value).map{$0.value})
  }



}
