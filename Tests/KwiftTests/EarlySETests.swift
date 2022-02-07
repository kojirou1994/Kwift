import XCTest
@testable import KwiftExtension

class EarlySETests: XCTestCase {
  func testSE0334() {
    struct E {
      let value: Int
      var offsetValue: Int
      var computedProperty: Int { offsetValue }
      var computedSetProperty: Int {
        get {
          offsetValue
        }
        set {
          offsetValue = newValue
        }
      }
    }

    var model = E(value: 0, offsetValue: 100)
    withUnsafeMutablePointer(to: &model) { ptr in
      XCTAssertEqual(ptr.pointer(to: \.value)?.pointee, 0)
      XCTAssertEqual(ptr.pointer(to: \.offsetValue)?.pointee, 100)
      ptr.pointer(to: \.offsetValue)?.pointee += 1
      XCTAssertEqual(ptr.pointer(to: \.computedProperty), nil)
      XCTAssertEqual(ptr.pointer(to: \.computedSetProperty), nil)
    }

    XCTAssertEqual(model.offsetValue, 101)

    withUnsafePointer(to: &model) { ptr in
      XCTAssertEqual(ptr.pointer(to: \.offsetValue)?.pointee, 101)
      XCTAssertEqual(ptr.pointer(to: \.computedProperty), nil)
    }
  }
}
