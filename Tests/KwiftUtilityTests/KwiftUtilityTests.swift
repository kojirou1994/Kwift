import XCTest
@testable import KwiftUtility

class KwiftUtilityTests: XCTestCase {
    
    func testByteOperation() {
        func testInteger<I>(_ type: I.Type) where I: FixedWidthInteger {
            let number = I.random(in: .min...I.max)
            XCTAssertEqual(number, number.splited.joined(I.self))
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
    
    static var allTests : [(String, (KwiftUtilityTests) -> () throws -> Void)] {
        return [
            ("testByteOperation", testByteOperation)
        ]
    }
}
