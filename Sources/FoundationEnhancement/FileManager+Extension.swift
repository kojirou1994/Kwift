//
//  FileManager+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2019/1/6.
//

import Foundation

extension FileManager {
    
    public func directoryExists(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return fileExists && isDirectory.boolValue
    }
    
}
