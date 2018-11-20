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
    
}
