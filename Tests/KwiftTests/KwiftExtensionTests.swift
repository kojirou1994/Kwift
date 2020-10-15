import XCTest
@testable import KwiftExtension

class KwiftExtensionTests: XCTestCase {

  func testAutoreleasepool() {
    autoreleasepool {
      XCTAssertTrue(true)
    }
  }

  func testUnsafeCast() {

    let uint = UInt.random(in: 0...UInt.max)

    XCTAssertEqual(unsafeBitCast(uint), Int(bitPattern: uint))

    class Subclass: NSObject {}

    let object = Subclass()

    XCTAssertTrue(unsafeDowncast(object) === (object as NSObject))
  }

  func testV3V5UUID() {
    #if canImport(CryptoKit)
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
      let namespace = UUID(uuidString: "f826f08b-6bd2-4625-a5a7-9140518bda08")!
      let name = "Kwift"

      XCTAssertEqual(UUID.v3(namespace: namespace, name: name), "ea74b004-4b9a-3b58-9a39-fd5237d94956")
      XCTAssertEqual(UUID.v5(namespace: namespace, name: name), "2091aa40-04ae-502e-9546-ec5117558eb4")
    }
    #endif
  }

}
