import XCTest
@testable import KwiftExtension
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class FoundationExtensionTests: XCTestCase {

  struct Model: Codable, Equatable {
    let value: Int
  }

  let jsonDecoder = JSONDecoder()
  let jsonEncoder = JSONEncoder()

  let model = Model(value: Int.random(in: Int.min...Int.max))
  let modelArray = [Model].init(repeating: Model(value: 0), count: 5_000_00)

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

  func testJSONEncoder() {
    XCTAssertNoThrow(try jsonEncoder.kwiftEncode(model))

    XCTAssertEqual(try! jsonEncoder.kwiftEncode(model),
                   try! jsonEncoder.encode(model))
  }



  func testURLSessionSync() {
    let session = URLSession(configuration: .ephemeral)
    let url = URL(string: "http://bing.com")!
    XCTAssertNoThrow(try session.syncResultTask(with: url).get())

    let invalidUrl = URL(string: "http://127.0.0.1:20")!
    XCTAssertThrowsError(try session.syncResultTask(with: invalidUrl).get())
  }
}
