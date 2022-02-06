import XCTest
@testable import KwiftUtility

class KwiftUtilityTests: XCTestCase {

  func testSnakeCaseConvert() {
    let snakeCase = "scan_dirs"
    let camel = "scanDirs"
    XCTAssertEqual(SnakeCaseConvert.convertToSnakeCase(camel), snakeCase)
    XCTAssertEqual(SnakeCaseConvert.convertFromSnakeCase(snakeCase), camel)
  }

  func testAnyCodingKey() throws {
    struct Model: Codable, Equatable {
      let value: String
      let value2: String

      init(value: String, value2: String) {
        self.value = value
        self.value2 = value2
      }

      init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        value = try container.decode(String.self, forKey: .init(stringValue: "value"))
        value2 = try container.decode(String.self, forKey: "value2")
      }
    }
    let model = Model(value: "ABCD", value2: "1234")
    let jsonData = try JSONEncoder().encode(model)
    let decoder = JSONDecoder()

    XCTAssertNoThrow(try decoder.decode(Model.self, from: jsonData))
    XCTAssertEqual(model, try! decoder.decode(Model.self, from: jsonData))

    let intKey = AnyCodingKey(intValue: 0x1234)
    let intLiteralKey: AnyCodingKey = 0x1234
    XCTAssertNotNil(intKey.intValue)
    XCTAssertNotNil(intLiteralKey.intValue)
    XCTAssertEqual(intKey.intValue, 0x1234)
    XCTAssertEqual(intKey.intValue, intLiteralKey.intValue)
    XCTAssertEqual(intKey, intLiteralKey)
    XCTAssertEqual(intKey.stringValue, 0x1234.description)
  }

  func testRetry() {
    struct SomeError: Error {}
    func notThrowError() throws {}
    func throwError() throws { throw SomeError() }

    // not throw
    XCTAssertEqual(retry(body: 1), 1)
    XCTAssertNoThrow(try retry(body: try notThrowError()))

    // throw error, no handler
    XCTAssertThrowsError(try retry(body: try throwError(), maxFailureCount: 3)) { error in
      XCTAssertTrue(error is SomeError)
    }

    // throw error, count 0
    XCTAssertThrowsError(try retry(body: try throwError(), maxFailureCount: 0, onError: { count, error in
      XCTFail("Should never call")
    })) { error in
      XCTAssertTrue(error is SomeError)
    }

    // throw error, count 3
    var failureCount: UInt = 0
    let expectedFailureCount: UInt = 3
    XCTAssertThrowsError(try retry(body: try throwError(), maxFailureCount: expectedFailureCount, onError: { count, error in
      failureCount += 1
      XCTAssertEqual(count, failureCount)
    })) { error in
      XCTAssertTrue(error is SomeError)
    }
    XCTAssertEqual(failureCount, expectedFailureCount)

  }
}
