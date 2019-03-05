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
    
    @discardableResult
    public func runAndWait(prepare: ((Process) -> Void)? = nil) throws -> Process {
        let p = try generateProcess()
        prepare?(p)
        #if os(Linux)
        p.launch()
        #else
        if #available(OSX 10.13, *) {
            try p.run()
        } else {
            p.launch()
        }
        #endif
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

public class ProcessOperation: Operation {
    
    internal let _process: Process
    
    public init(process: Process) {
        _process = process
    }
    
    override public func main() {
        _process.launch()
        _process.waitUntilExit()
    }
    
    override public func cancel() {
        _process.terminate()
    }
}

public class ParallelProcessQueue {
    
    internal let _queue: OperationQueue
    
    public init() {
        _queue = OperationQueue.init()
    }
    
    public var maxConcurrentCount: Int {
        set {
            _queue.maxConcurrentOperationCount = newValue
        }
        
        get {
            return _queue.maxConcurrentOperationCount
        }
    }
    
    public func add(_ process: Process) {
        _queue.addOperation(ProcessOperation.init(process: process))
    }
    
    public func add(_ executable: Executable, termination: @escaping (Process) -> Void) throws {
        let p = try executable.generateProcess()
        p.terminationHandler = termination
        _queue.addOperation(ProcessOperation.init(process: p))
    }
    
    public func waitUntilAllOProcessesAreFinished() {
        _queue.waitUntilAllOperationsAreFinished()
    }
    
    public func terminateAllProcesses() {
        _queue.cancelAllOperations()
    }
    
}
#endif
