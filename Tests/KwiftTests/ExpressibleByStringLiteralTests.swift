import XCTest
@testable import KwiftExtension

class ExpressibleByStringLiteralTests: XCTestCase {

  func testUUID() {
    let id = UUID(uuidString: "148889F2-5356-41FC-9D7A-0754E000F1BE")!
    XCTAssertEqual(id, "148889F2-5356-41FC-9D7A-0754E000F1BE")
  }

  func testCharacterSet() {
    let str = "ABCD=.啊🐶"
    XCTAssertEqual(CharacterSet(charactersIn: str), "ABCD=.啊🐶")
  }
}
