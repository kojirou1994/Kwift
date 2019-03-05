//
//  Readline.swift
//  Kwift
//
//  Created by Kojirou on 2017/11/4.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import Foundation
import Compatibility

extension Collection where Element == UInt8 {
    
    public func enumerateLines(_ block: Readline.ReadlineHandler) {
        var interrupt = false
        for line in split(separator: Readline.delimiter).enumerated() {
            block(String.init(decoding: line.element, as: UTF8.self), line.offset, &interrupt)
            if interrupt {
                break
            }
        }
    }
    
}

public struct Readline {

    fileprivate static let delimiter: UInt8 = 0x0A
    
    public typealias ReadlineHandler = (_ line: String, _ index: Int, _ interrupt: inout Bool) -> Void
    
    public static func read(at path: URL,
                            _ handler: ReadlineHandler) throws {
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
