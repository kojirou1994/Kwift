import Foundation

public typealias DataHandle = ByteReader<Data>

public class ByteReader<C> where C: Collection, C.Element == UInt8, C.Index == Int {
    
    public private(set) var currentIndex: Int
    
    public func seek(to offset: Int) {
        precondition((data.startIndex + offset)<=data.endIndex)
        currentIndex = offset
    }
    
    public let data: C
    
    public init(data: C) {
        self.data = data
        currentIndex = data.startIndex
    }
    
    public func read(_ count: Int) -> C.SubSequence {
        precondition((currentIndex + count)<=data.endIndex)
        defer {
            currentIndex += count
        }
        return data[currentIndex..<(currentIndex + count)]
    }
    
    public func readByte() -> UInt8 {
        precondition((currentIndex + 1)<=data.endIndex)
        defer {
            currentIndex += 1
        }
        return data[currentIndex]
    }
    
    public var currentByte: UInt8 {
        data[currentIndex]
    }
    
    public func skip(_ count: Int) {
        precondition((currentIndex + count)<=data.endIndex)
        currentIndex += count
    }
    
    public func readToEnd() -> C.SubSequence {
        if isAtEnd {
            return data[data.endIndex..<data.endIndex]
        } else {
            defer { currentIndex = data.endIndex }
            return data[currentIndex..<data.endIndex]
        }
    }
    
    public var isAtEnd: Bool {
        currentIndex == (data.endIndex)
    }
    
    public var restBytesCount: Int {
        data.endIndex - currentIndex
    }
    
}
