//
//  Readline.swift
//  Kwift
//
//  Created by Kojirou on 2017/11/4.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import Foundation

public struct Readline {

    static let delimiter: UInt8 = 0x0A

    public static func read(at path: URL,
                            _ handler: (_ line: String, _ index: Int, _ interrupt: inout Bool) -> Void) throws {
        var obtainedBuffer = Data()
        var currentLineBuffer = Data()
        var currentLineIndex = 0
        var bufferStartIndex = 0
        var validBufferLength = 0
        var interrupt = false
        let filehandle = try FileHandle.init(forReadingFrom: path)
        defer {
            filehandle.closeFile()
        }
        
        func readBuffer() -> Data {
            return autoreleasepoolIfDarwin(invoking: { () -> Data in
                let buffer = filehandle.readData(ofLength: 4000)
                return buffer
            })
        }
        
        while case let buffer = readBuffer(),
            buffer.count > 0 {
                obtainedBuffer = buffer
                validBufferLength = obtainedBuffer.count
                bufferStartIndex = 0
                while validBufferLength > 0 {
                    let restBufferSlice = obtainedBuffer[bufferStartIndex..<bufferStartIndex+validBufferLength]
                    guard let newlineIndex = restBufferSlice.firstIndex(of: Readline.delimiter) else {
                        // 没有换行，全部转存缓存
                        currentLineBuffer.append(contentsOf: restBufferSlice)
                        validBufferLength = 0
                        bufferStartIndex = 0
                        continue
                    }
                    // 有换行 转存， index更改
                    currentLineBuffer.append(contentsOf: restBufferSlice[bufferStartIndex..<newlineIndex])
                    handler(String.init(data: currentLineBuffer, encoding: .utf8)!, currentLineIndex, &interrupt)
                    if interrupt {
                        return
                    }
                    validBufferLength = validBufferLength + bufferStartIndex - newlineIndex - 1
                    bufferStartIndex = newlineIndex + 1
                    currentLineIndex += 1
                    currentLineBuffer = Data()
                }
        }
        // last line
        handler(String.init(data: currentLineBuffer, encoding: .utf8)!, currentLineIndex, &interrupt)
        
    }

}


//struct TextLineIterator: IteratorProtocol {
//    
//    typealias Element = String
//    
//    let encoding: String.Encoding
//    
//    init() {
//        
//    }
//    
//    mutating func next() -> String? {
//        
//    }
//}
