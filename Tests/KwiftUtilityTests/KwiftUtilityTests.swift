import XCTest
@testable import KwiftUtility

class KwiftUtilityTests: XCTestCase {
    
    func testByteOperation() {
        func testInteger<I>(_ type: I.Type) where I: FixedWidthInteger {
            let number = I.random(in: .min...I.max)
            XCTAssertEqual(number, number.bytes.joined(I.self))
        }
        testInteger(UInt8.self)
        testInteger(UInt16.self)
        testInteger(UInt32.self)
        testInteger(UInt64.self)
        testInteger(Int8.self)
        testInteger(Int16.self)
        testInteger(Int32.self)
        testInteger(Int64.self)
    }

    func testResolutionParse() {
        let str = "1920x1080"
        let parsed = Resolution(str)
        XCTAssertNotNil(parsed)
        XCTAssertEqual(parsed?.width, 1920)
        XCTAssertEqual(parsed?.height, 1080)

        measure {
            _ = Resolution(str)
        }

        let invalidStrs = [
            "1920",
            "1920x",
            "1920xabc",
            "",
            "x"
        ]
        for v in invalidStrs {
            XCTAssertNil(Resolution(v))
        }
    }
    
    static var allTests : [(String, (KwiftUtilityTests) -> () throws -> Void)] {
        return [
            ("testByteOperation", testByteOperation)
        ]
    }
}
