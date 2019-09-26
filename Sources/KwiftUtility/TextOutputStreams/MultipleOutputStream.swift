import Foundation

public struct MultipleOutputStream: TextOutputStream {
    
    private let stream: StdioOutputStream?
    
    private let files: [FileHandle]
    
    public init(stream: StdioOutputStream?, files: [URL]) throws {
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
    
    public init(stream: StdioOutputStream) {
        self.stream = stream
        self.files = []
    }
    
    public func write(_ string: String) {
        stream?.write(string)
        if !files.isEmpty {
            let data = Data(string.utf8)
            files.forEach {$0.write(data)}
        }
    }
    
}
