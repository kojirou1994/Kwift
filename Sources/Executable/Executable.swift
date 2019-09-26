#if os(macOS) || os(Linux)
import Foundation

public enum ExecutableError: Error {
    case pathNull
    case executableNotFound(String)
    case nonZeroExitCode(Int32)
}

public struct ExecutablePath {
    
    private static var PATHs = ProcessInfo.processInfo.environment["PATH", default: ""].split(separator: ":")
    
    public static func set(_ path: String) {
        ExecutablePath.PATHs = path.split(separator: ":")
    }
    
    private static var customLookup: ((String) -> String?)?
    
    public static func set(_ lookupMethod: ((String) -> String?)?) {
        Self.customLookup = lookupMethod
    }
    
    internal static func lookup(_ executable: String, customPaths: [Substring]? = nil) throws -> String {
        if let customLookup = Self.customLookup {
            if let result = customLookup(executable) {
                return result
            } else {
                throw ExecutableError.executableNotFound(executable)
            }
        }
        let paths: [Substring]
        if let customPaths = customPaths, customPaths.count > 0 {
            paths = customPaths
        } else if ExecutablePath.PATHs.count > 0 {
            paths = ExecutablePath.PATHs
        } else {
            throw ExecutableError.pathNull
        }
        
        for path in paths {
            let tmp = "\(path)/\(executable)"
            if FileManager.default.isExecutableFile(atPath: tmp) {
                return tmp
            }
        }
        throw ExecutableError.executableNotFound(executable)
    }
}

public protocol Executable: CustomStringConvertible {
    
    static var executableName: String {get}
    
    var arguments: [String] {get}
    
    var executableName: String { get }
    
}

extension Executable {
    
    public var executableName: String {
        Self.executableName
    }
    
    public static func check() throws {
        _ = try ExecutablePath.lookup(Self.executableName)
    }
    
    public func generateProcess() throws -> Process {
        let process = Process()
        let executableURL = URL(fileURLWithPath: try ExecutablePath.lookup(executableName))
        #if os(macOS)
        if #available(OSX 10.13, *) {
            process.executableURL = executableURL
        } else {
            process.launchPath = executableURL.path
        }
        #else
        process.executableURL = executableURL
        #endif
        process.arguments = arguments
        return process
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
        "CommandLine: \(executableName) \(arguments.joined(separator: " "))"
    }
    
    public var commandLine: [String] {
        [executableName] + arguments
    }
    
}

public struct AnyExecutable: Executable {
    
    public static var executableName: String {
        fatalError()
    }
    
    public init(executableName: String, arguments: [String]) {
        self.executableName = executableName
        self.arguments = arguments
    }
    
    public let executableName: String
    
    public let arguments: [String]
    
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
        #if os(macOS)
        _process.terminate()
        #else
        kill(_process.processIdentifier, SIGTERM)
        #endif
    }
}

public class ParallelProcessQueue {
    
    internal let _queue: OperationQueue
    
    public init() {
        _queue = OperationQueue.init()
    }
    
    public var operationCount: Int {
        _queue.operationCount
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
    
    public func add<E: Executable>(_ executable: E, termination: @escaping (Process) -> Void) throws {
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
