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
    
    let stderr: Bool
    
    public init(logPath: String? = nil, terminal: Bool, stderr: Bool = false) {
        if logPath != nil {
            if !FileManager.default.fileExists(atPath: logPath!) {
                _ = FileManager.default.createFile(atPath: logPath!, contents: nil, attributes: nil)
            }
            fileout = FileHandle.init(forWritingAtPath: logPath!)
            fileout?.seekToEndOfFile()
        } else {
            fileout = nil
        }
        self.terminal = terminal
        self.stderr = stderr
    }
    
    public func write(_ string: String) {
        if terminal {
            if stderr {
                print(string, terminator: "", to: &stderrOutputStream)
            } else {
                print(string, terminator: "")
            }
        }
        fileout?.write(string.data(using: .utf8)!)
    }
    
}
