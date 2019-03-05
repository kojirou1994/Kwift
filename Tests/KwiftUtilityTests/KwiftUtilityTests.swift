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
    
    @available(OSX 10.13, *)
    func testExe() {
        let p = try! Process.init(executableName: "curl", arguments: [])
        try! p.run()
        p.waitUntilExit()
    }
    
    func testRusage() {
        rusage.display()
    }
    
    func testSyncRequest() {
        let r = URLRequest.init(url: URL.init(string: "https://baidu.com")!)
        URLSession.shared.syncDataTask(request: r) { (data, r, e) in
            print("url done")
            sleep(2)
            dump(r!)
            print(Thread.current)
        }
        print("done")
    }
    
    func testByteOperation() {
        let number = Int.random(in: .min...Int.max)
        measure {
            XCTAssertEqual(number, number.splited.joined(Int.self))
        }
    }
    
    func testCollectionHexString() {
        print(Data.init([0x01, 0x02]).hexString())
        print(Data.init([0x00, 0x10, 0xd5]).joined(UInt32.self))
    }
    
    static var allTests : [(String, (KwiftTests) -> () throws -> Void)] {
        return [
            ("testStringSubscript", testStringSubscript),
            ("testDecodableExtension", testDecodableExtension)
        ]
    }
}
