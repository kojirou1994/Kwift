import Foundation

public struct MultipleOutputStream<S: TextOutputStream>: TextOutputStream {
    
    private var stream: S?
    
    private let files: [FileHandle]
    
    public init(stream: S?, files: [URL] = []) throws {
        self.stream = stream
        self.files = try files.map({ (path) -> FileHandle in
            if !FileManager.default.fileExists(atPath: path.path) {
                _ = FileManager.default.createFile(atPath: path.path, contents: nil, attributes: nil)
            }
            let f = try FileHandle(forWritingTo: path)
            f.seekToEndOfFile()
            return f
        })
    }
    
    public mutating func write(_ string: String) {
        stream?.write(string)
        if !files.isEmpty {
            let data = Data(string.utf8)
            files.forEach {$0.write(data)}
        }
    }
    
}
