//
//  Executable.swift
//  Kwift
//
//  Created by Kojirou on 2018/11/20.
//

import Foundation

#if os(macOS) || os(Linux)
public protocol Executable: CustomStringConvertible {
    
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
    
    public var description: String {
        return "CommandLine: \(Self.executableName) \(arguments.joined(separator: " "))"
    }
    
    public var commandLine: [String] {
        return [Self.executableName] + arguments
    }
    
}

public class ParallelProcess {
    
    let q: OperationQueue
    
    public init() {
        q = OperationQueue.init()
    }
    
    public var maxConcurrentCount: Int {
        set {
            q.maxConcurrentOperationCount = newValue
        }
        
        get {
            return q.maxConcurrentOperationCount
        }
    }
    
    public func add(_ process: Process) {
        q.addOperation {
            process.launch()
            process.waitUntilExit()
        }
    }
    
    public func add(_ executable: Executable) {
        q.addOperation {
            _ = try? executable.runAndWait()
        }
    }
    
    public func waitUntilAllOProcessesAreFinished() {
        q.waitUntilAllOperationsAreFinished()
    }
    
}
#endif
