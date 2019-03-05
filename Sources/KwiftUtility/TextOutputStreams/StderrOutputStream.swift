//
//  StderrOutputStream.swift
//  Kwift
//
//  Created by Kojirou on 2018/8/27.
//

import Foundation

public struct StderrOutputStream: TextOutputStream {
    public func write(_ string: String) {
        fputs(string, stderr)
    }
}

public var stderrOutputStream = StderrOutputStream.init()
