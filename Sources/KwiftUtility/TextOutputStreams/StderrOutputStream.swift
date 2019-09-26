import Foundation

public struct StdioOutputStream: TextOutputStream {
    
    private let file: UnsafeMutablePointer<FILE>
    
    private init(_ file: UnsafeMutablePointer<FILE>) { self.file = file }
    
    public func write(_ string: String) {
//        flockfile(file)
//        defer {
//            funlockfile(file)
//        }
        fputs(string, file)
    }
    
    public static let stderr = StdioOutputStream(Foundation.stderr)
    
    public static let stdout = StdioOutputStream(Foundation.stdout)
    
}
