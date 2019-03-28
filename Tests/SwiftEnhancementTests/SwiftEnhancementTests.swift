import XCTest
@testable import SwiftEnhancement

class SwiftEnhancementTests: XCTestCase {
    
    func testStringSubscript() {
        let str = "0123456789"
        XCTAssertEqual(str[0...5], "012345")
        XCTAssertEqual(str[0..<5], "01234")
        XCTAssertEqual(str[..<5], str[0..<5])
        XCTAssertEqual(str[5...], str[5..<str.count])
        XCTAssertEqual(str[2...7], "234567")
        XCTAssertEqual(str[2..<7], "23456")
        for i in 0..<str.count {
            XCTAssertEqual(str[i], Character.init(i.description))
        }
    }
    
    static var allTests : [(String, (SwiftEnhancementTests) -> () throws -> Void)] {
        return [
            ("testStringSubscript", testStringSubscript),
            
        ]
    }
}
