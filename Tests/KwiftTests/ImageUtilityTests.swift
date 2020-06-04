import XCTest
@testable import KwiftUtility

class ImageUtilityTests: XCTestCase {

  func testResolution() {
    let str = "1920x1080"
    let parsed = Resolution(str)
    XCTAssertNotNil(parsed)
    XCTAssertEqual(parsed!.width, 1920)
    XCTAssertEqual(parsed!.height, 1080)
    XCTAssertEqual(parsed!.description, str)
    XCTAssertEqual(parsed!.size, 1920 * 1080)

    XCTAssertEqual(Resolution(width: 1, height: 1).ratio, 1)
    XCTAssertEqual(Resolution(width: 1, height: 1), Resolution(width: 1, height: 1))

    measure {
      _ = Resolution(str)
    }

    let invalidStrs = [
      "1920",
      "1920x",
      "x1080",
      "1920xabc",
      "",
      "x",
      "-1920x1080",
      "-1920x-1080"
    ]
    for v in invalidStrs {
      XCTAssertNil(Resolution(v))
    }
  }

}
