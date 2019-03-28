//
//  DataHandle.swift
//  Kwift
//
//  Created by Kojirou on 2019/2/5.
//

import Foundation

public class DataHandle {
    
    public private(set) var currentIndex: Data.Index
    
    public func seek(to offset: Data.Index) {
        precondition((data.startIndex + offset)<=data.endIndex)
        currentIndex = offset
    }
    
    public let data: Data
    
    public init(data: Data) {
        self.data = data
        currentIndex = data.startIndex
    }
    
    public func read(_ count: Int) -> Data {
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
        return data[currentIndex]
    }
    
    public func skip(_ count: Int) {
        precondition((currentIndex + count)<=data.endIndex)
        currentIndex += count
    }
    
    public func readToEnd() -> Data {
        if isAtEnd {
            return .init()
        } else {
            defer { currentIndex = data.endIndex }
            return data[currentIndex..<data.endIndex]
        }
    }
    
    public var isAtEnd: Bool {
        return currentIndex == (data.endIndex)
    }
    
    public var restBytesCount: Int {
        return data.endIndex - currentIndex
    }
    
}
