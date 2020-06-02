import XCTest
@testable import KwiftExtension

class OptionalExtensionTests: XCTestCase {
  func testUnwrap() {
    let nilValue: Int? = nil
    XCTAssertThrowsError(try nilValue.unwrap())
    let value: Int? = 5
    XCTAssertNoThrow(try value.unwrap())

    // custom error
    struct CustomError: Error {}

    do {
      try nilValue.unwrap(CustomError())
    } catch {
      XCTAssertTrue(error is CustomError)
    }
  }
}
