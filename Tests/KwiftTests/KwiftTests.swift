import XCTest
@testable import Kwift

class KwiftTests: XCTestCase {
    func testStringSubscript() {
        let str = "0123456789"
        XCTAssertEqual(str[0...5], "012345")
        XCTAssertEqual(str[0..<5], "01234")
        XCTAssertEqual(str[..<5], str[0..<5])
        XCTAssertEqual(str[5...], str[5...9])
        XCTAssertEqual(str[2...7], "234567")
        XCTAssertEqual(str[2..<7], "23456")
        for i in 0..<str.count {
            XCTAssertEqual(str[i], Character.init(i.description))
        }
    }
    
    func testDecodableExtension() {
        struct TT: Decodable, Equatable {
            var key: String
        }
        let dic = ["key": "value"]
        let decoded = try! JSONDecoder().decode(TT.self, from: dic)
        XCTAssertEqual(decoded, TT.init(key: "value"))
    }
    
    static var allTests : [(String, (KwiftTests) -> () throws -> Void)] {
        return [
            ("testStringSubscript", testStringSubscript),
            ("testDecodableExtension", testDecodableExtension)
        ]
    }
}
