import XCTest
@testable import KwiftExtension

class FoundationExtensionTests: XCTestCase {

  struct Model: Codable, Equatable {
    let value: Int
  }

  let jsonDecoder = JSONDecoder()
  let jsonEncoder = JSONEncoder()

  let model = Model(value: Int.random(in: Int.min...Int.max))
  let modelArray = [Model].init(repeating: Model(value: 0), count: 1_000_00)

  func testJSONDecoder() {
    let json = ["value": model.value]

    // MARK: Decode from json dictionary
    XCTAssertNoThrow(try jsonDecoder.kwiftDecode(from: json) as Model)
    XCTAssertEqual(try! jsonDecoder.kwiftDecode(from: json) as Model, model)

    // MARK: Decode from generic ContiguousBytes
    let encodedData = try! jsonEncoder.encode(model)
    let bytesArray = Array(encodedData)
    XCTAssertNoThrow(try jsonDecoder.kwiftDecode(from: bytesArray) as Model)
    XCTAssertEqual(try! jsonDecoder.kwiftDecode(from: bytesArray) as Model, model)
  }

  func testDecodeContiguousBytesPerformance() {
    let encodedData = try! jsonEncoder.encode(modelArray)
    let bytesArray = ContiguousArray(encodedData)

    measure {
      _ = try! jsonDecoder.kwiftDecode(from: bytesArray) as [Model]
    }
  }

  func testDecodeCopyBytesPerformance() {
    let encodedData = try! jsonEncoder.encode(modelArray)
    let bytesArray = ContiguousArray(encodedData)

    measure {
      _ = try! jsonDecoder.decode([Model].self, from: .init(bytesArray))
    }
  }

  func testDirectDecodePerformance() {
    let encodedData = try! jsonEncoder.encode(modelArray)

    measure {
      _ = try! jsonDecoder.decode([Model].self, from: encodedData)
    }
  }

  func testDirectAutoreleasepoolDecodePerformance() {
    let encodedData = try! jsonEncoder.encode(modelArray)

    measure {
      autoreleasepool {
        _ = try! jsonDecoder.decode([Model].self, from: encodedData)
      }
    }
  }

  func testJSONEncoder() {
    XCTAssertNoThrow(try jsonEncoder.kwiftEncode(model))

    XCTAssertEqual(try! jsonEncoder.kwiftEncode(model),
                   try! jsonEncoder.encode(model))
  }
}
