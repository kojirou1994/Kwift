import XCTest
@testable import KwiftExtension

class BoolExtensionTests: XCTestCase {

  func testCValueConvertion() {
    let cFalse = 0
    XCTAssertFalse(Bool(cValue: cFalse))
    XCTAssertFalse(cFalse.cBool)

    let cTrue = 1
    XCTAssertTrue(Bool(cValue: cTrue))
    XCTAssertTrue(cTrue.cBool)
  }

  func testPreconditionFailError() {
    let message = "Message"
    XCTAssertNoThrow(try preconditionOrThrow(true, message))
    XCTAssertThrowsError(try preconditionOrThrow(false, message)) { error in
      XCTAssertTrue(error is ErrorInCode)
    }
    XCTAssertThrowsError(try preconditionOrThrow(false)) { error in
      XCTAssertTrue(error is ErrorInCode)
    }
  }
}
