import XCTest
@testable import KwiftUtility

class NSLockAtomicTests: XCTestCase {

  func testNSLockAtomic() {
    var value = NSLockAtomic(value: 0)
    let count = 1_0000_000
    DispatchQueue.concurrentPerform(iterations: count) { _ in
      value.withLock { $0 += 1 }
    }

    XCTAssertEqual(value.value, count)
    XCTAssertTrue(isKnownUniquelyReferenced(&value))
  }

}
