import XCTest
@testable import KwiftExtension

class OptionalExtensionTests: XCTestCase {
  func testUnwrap() {
    let nilValue: Int? = nil

    // custom message
    let errorMessage = "Error message"
    XCTAssertThrowsError(try nilValue.unwrap(errorMessage)) { error in
      XCTAssertTrue(error is OptionalNilError)
      XCTAssertEqual((error as! OptionalNilError).message, errorMessage)
      _ = String(describing: error)
    }
    // no message
    XCTAssertThrowsError(try nilValue.unwrap()) { error in
      XCTAssertTrue(error is OptionalNilError)
      _ = String(describing: error)
    }
    // custom error
    struct CustomError: Error {}

    XCTAssertThrowsError(try nilValue.unwrap(CustomError())) { error in
      XCTAssertTrue(error is CustomError)
    }

    let nonNilValue: Int? = 5
    XCTAssertNoThrow(try nonNilValue.unwrap())

    XCTAssertEqual(nonNilValue, try! nonNilValue.unwrap())
    XCTAssertEqual(nonNilValue, try! nonNilValue.unwrap(CustomError()))
  }
}
