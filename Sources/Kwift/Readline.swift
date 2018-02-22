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

    public static func read(at path: URL, _ handler: (String, Int) -> Void) throws {
        var obtainedBuffer = Data()
        var currentLineBuffer = Data()
        var currentLineIndex = 0
        var bufferStartIndex = 0
        var validBufferLength = 0
        let filehandle = try FileHandle.init(forReadingFrom: path)
    
        func readBuffer() -> Data {
            #if os(macOS)
            return autoreleasepool { () -> Data in
                let buffer = filehandle.readData(ofLength: 4000)
                return buffer
            }
            #else
            let buffer = filehandle.readData(ofLength: 4000)
            return buffer
            #endif
            
        }
        
        while case let buffer = readBuffer(),
            buffer.count > 0 {
                obtainedBuffer = buffer
                validBufferLength = obtainedBuffer.count
                bufferStartIndex = 0
                while validBufferLength > 0 {
                    let restBufferSlice = obtainedBuffer[bufferStartIndex..<bufferStartIndex+validBufferLength]
                    guard let newlineIndex = restBufferSlice.index(of: Readline.delimiter) else {
                        // 没有换行，全部转存缓存
                        currentLineBuffer.append(contentsOf: restBufferSlice)
                        validBufferLength = 0
                        bufferStartIndex = 0
                        continue
                    }
                    // 有换行 转存， index更改
                    currentLineBuffer.append(contentsOf: restBufferSlice[bufferStartIndex..<newlineIndex])
                    handler(String.init(data: currentLineBuffer, encoding: .utf8)!, currentLineIndex)
                    validBufferLength = validBufferLength + bufferStartIndex - newlineIndex - 1
                    bufferStartIndex = newlineIndex + 1
                    currentLineIndex += 1
                    currentLineBuffer = Data()
                }
        }
        // last line
        handler(String.init(data: currentLineBuffer, encoding: .utf8)!, currentLineIndex)
        filehandle.closeFile()
    }

}
