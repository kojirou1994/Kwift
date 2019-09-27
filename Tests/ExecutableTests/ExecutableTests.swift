import XCTest
@testable import Executable

#if os(macOS) || os(Linux)
class ExecutableTests: XCTestCase {
    
    struct Curl: Executable {
        static let executableName = "curl"
        var arguments: [String] { return [] }
    }
    
    struct FFmpegHelp: Executable {
        static let executableName = "ffmpeg"
        var arguments: [String] { return ["-nostdin", "-h", "full"] }
    }
    
    override func setUp() {
        super.setUp()
    }
    
    func testExecutableCatch() throws {

        let result = try Curl().runAndCatch(checkNonZeroExitCode: false)
        print(result)
        XCTAssertEqual(result.stderr, Data("curl: try 'curl --help' or 'curl --manual' for more information\n".utf8))
        XCTAssertEqual(result.stdout, Data())
    }
    
    func testExecutableCatchPerformance() {
        measure {
//            _ = try! Curl().runAndCatch(checkNonZeroExitCode: false)
        }
    }
    
    func testExecutableCatchLargeOutputPerformance() {
        measure {
//            print(try! FFmpegHelp().runAndCatch(checkNonZeroExitCode: false))
        }
    }
    
    static var allTests : [(String, (ExecutableTests) -> () throws -> Void)] {
        return [
            ("testExecutableCatch", testExecutableCatch),
            ("testExecutableCatchPerformance", testExecutableCatchPerformance),
            ("testExecutableCatchLargeOutputPerformance", testExecutableCatchLargeOutputPerformance)
        ]
    }
}
#endif
