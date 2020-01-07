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
    
    func testSamePrefix() {
        let sample = """
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/01.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/02.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/03.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/04.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/05.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/06.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/07.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/08.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/09.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/10.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/11.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/12.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/13.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/14.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/15.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/16.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/17.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/18.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/19.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/20.heic
/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/21.heic
""".components(separatedBy: .newlines)
        measure {
            XCTAssertEqual("/Volumes/TOSHIBA_3T_9/MAKE_MANGA/Chapter Extra - Trunks the Story -A Lone Warrior/", sample.samePrefix)
        }
        
    }

    func testSameSuffix() {
        let suffix = "HJVGASDAS"
        let sample = (0...1_000).map {"\($0)\(suffix)"}
        measure {
            XCTAssertEqual(suffix, sample.sameSuffix.map {String($0)})
        }
    }
    
    static var allTests : [(String, (KwiftExtensionTests) -> () throws -> Void)] {
        return [
            ("testStringSubscript", testStringSubscript),
            
        ]
    }
}
