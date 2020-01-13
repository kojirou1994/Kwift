import XCTest
@testable import KwiftExtension

class KwiftExtensionTests: XCTestCase {
    
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
    
    func testUnwrapOptional() {
        let nilValue: Int? = nil
        XCTAssertThrowsError(try nilValue.unwrap())
        let value: Int? = 5
        XCTAssertNoThrow(try value.unwrap())
    }

    func testLongPrefix() {
        let prefix = "FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD"
        let samples = (1...1_000_000_0).map { "\(prefix)\($0)" }
        measure {
            XCTAssertEqual("FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD", samples.longestCommonPrefix)
        }
    }

    func testSortKeyPath() {
        struct Wrapper {
            let value: Int
        }
        let data = (1...100).reversed()
        let wrappers = data.map(Wrapper.init(value:))
        XCTAssertEqual(data.sorted(), wrappers.sorted(by: \.value).map{$0.value})
    }

//    func testLongPrefix2() {
//        let prefix = "FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD"
//        let samples = (1...1_000).map { "\(prefix)\($0)" }
//        measure {
//            XCTAssertEqual("FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD", samples.longestCommonPrefix2)
//        }
//    }

    func testLongestSuffix() {
        let result = "FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD"
        let samples = (1...1_000_000_0).map { "\($0)\(result)" }
        measure {
            XCTAssertEqual("FUTVVBHASDVUKASDHBDASILSDABJKLASDBJKASD", samples.longestCommonSuffix)
        }
    }
    
    static var allTests : [(String, (KwiftExtensionTests) -> () throws -> Void)] {
        return [
            ("testStringSubscript", testStringSubscript),
            
        ]
    }
}
