import XCTest
@testable import KwiftUtility

class KwiftUtilityTests: XCTestCase {

  func testResolutionParse() {
    let str = "1920x1080"
    let parsed = Resolution(str)
    XCTAssertNotNil(parsed)
    XCTAssertEqual(parsed?.width, 1920)
    XCTAssertEqual(parsed?.height, 1080)

    measure {
      _ = Resolution(str)
    }

    let invalidStrs = [
      "1920",
      "1920x",
      "1920xabc",
      "",
      "x"
    ]
    for v in invalidStrs {
      XCTAssertNil(Resolution(v))
    }
  }

  func testQueue() {
    var queue = Queue<Int>()
    XCTAssertTrue(queue.elementsEqual([Int]()))
    XCTAssertEqual(queue.count, 0)
    queue.append(contentsOf: 0...9)
    XCTAssertEqual(queue.count, 10)
    XCTAssertTrue(queue.elementsEqual(0...9))
    XCTAssertEqual(queue.removeFirst(), 0)
    XCTAssertEqual(queue.count, 9)
    XCTAssertEqual(queue.removeFirst(), 1)
    XCTAssertEqual(queue.count, 8)
    XCTAssertTrue(queue.elementsEqual(2...9))
    queue.append(contentsOf: 10...15)
    XCTAssertTrue(queue.elementsEqual(2...15))
    XCTAssertEqual(queue.count, 14)
  }
}
