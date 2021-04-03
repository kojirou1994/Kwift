import XCTest
@testable import KwiftExtension

class DictionaryExtensionTests: XCTestCase {

  func testInitFromOptionalValueDictionary() {
    let dic: [String : Int] = .init(
      [
        "a": 1,
        "b": nil,
      ]
    )

    XCTAssertNotNil(dic["a"])
    XCTAssertNil(dic["b"])
  }
}
