import XCTest
@testable import Kwift

class KwiftTests: XCTestCase {
    func testStringSubscript() {
        let str = "0123456789"
        XCTAssertEqual(str[0...5], "012345")
        XCTAssertEqual(str[0..<5], "01234")
        XCTAssertEqual(str[2...7], "234567")
        XCTAssertEqual(str[2..<7], "23456")
        for i in 0..<str.count {
            XCTAssertEqual(str[i], Character.init(i.description))
        }
    }
    
    
    static var allTests : [(String, (KwiftTests) -> () throws -> Void)] {
        return [
            ("testStringSubscript", testStringSubscript)
        ]
    }
}
