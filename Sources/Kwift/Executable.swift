//
//  Executable.swift
//  Kwift
//
//  Created by Kojirou on 2018/11/20.
//

import Foundation

public protocol Executable {
    
    static var executableName: String {get}
    
    var arguments: [String] {get}
    
    ///
    ///
    /// - Returns: Process ready for launching
    /// - Throws: ExeSearchError
    func generateProcess() throws -> Process
    
}

extension Executable {
    
    public func generateProcess() throws -> Process {
        return try Process.init(executableName: Self.executableName, arguments: arguments)
    }
    
    public func runAndWait(prepare: ((Process) -> Void)? = nil) throws -> Process {
        let p = try generateProcess()
        prepare?(p)
        if #available(OSX 10.13, *) {
            try p.run()
        } else {
            p.launch()
        }
        p.waitUntilExit()
        return p
    }
    
}
