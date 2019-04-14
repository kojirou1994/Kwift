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
//    func generateProcess() throws -> Process
    
}

extension Executable {
    
    public func generateProcess() throws -> Process {
        return try Process.init(executableName: Self.executableName, arguments: arguments)
    }
    
    @discardableResult
    public func runAndWait(checkNonZeroExitCode: Bool,
                           beforeRun: ((Process) -> Void)? = nil,
                           afterRun: ((Process) -> Void)? = nil) throws -> Process {
        let p = try generateProcess()
        beforeRun?(p)
        try p.kwift_run(wait: true, afterRun: afterRun)
        if checkNonZeroExitCode, p.terminationStatus != 0 {
            throw ExecutableError.nonZeroExitCode(p.terminationStatus)
        }
        return p
    }
    
    public func runAndCatch(checkNonZeroExitCode: Bool) throws -> LaunchResult {
        let result = try generateProcess().catchResult()
        if checkNonZeroExitCode, result.process.terminationStatus != 0 {
            throw ExecutableError.nonZeroExitCode(result.process.terminationStatus)
        }
        return result
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
        try! _process.kwift_run(wait: true)
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
    
    public var operationCount: Int {
        return _queue.operationCount
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
