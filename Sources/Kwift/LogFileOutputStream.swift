//
//  LogFileOutputStream.swift
//  Kwift
//
//  Created by Kojirou on 2018/1/22.
//

import Foundation

public struct LogFileOutputStream: TextOutputStream {
    
    let fileout: FileHandle?
    
    let terminal: Bool
    
    public init(logPath: String? = nil, terminal: Bool) {
        if logPath != nil {
            if !FileManager.default.fileExists(atPath: logPath!) {
                FileManager.default.createFile(atPath: logPath!, contents: nil, attributes: nil)
            }
            fileout = FileHandle.init(forWritingAtPath: logPath!)
            fileout?.seekToEndOfFile()
        } else {
            fileout = nil
        }
        self.terminal = terminal
    }
    
    public func write(_ string: String) {
        if terminal {
            print(string, terminator: "")
        }
        fileout?.write(string.data(using: .utf8)!)
    }
    
}
