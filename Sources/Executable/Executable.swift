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
        assert(!executable.isEmpty)
        if let customLookup = Self.customLookup {
            if let result = customLookup(executable) {
                return result
            } else {
//                throw ExecutableError.executableNotFound(executable)
            }
        }
        let paths: [Substring]
        if let customPaths = customPaths, !customPaths.isEmpty {
            paths = customPaths
        } else if !ExecutablePath.PATHs.isEmpty {
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

public enum ExecutableStandardStream {
    case fileHandle(FileHandle)
    case pipe(Pipe)

    var valueForProcess: Any {
        switch self {
        case .fileHandle(let f):
            return f as Any
        case .pipe(let p):
            return p as Any
        }
    }
}

public protocol Executable: CustomStringConvertible {
    
    static var executableName: String {get}
    
    var arguments: [String] {get}

    var environment: [String : String]? {get}

    var standardInput: ExecutableStandardStream? {get}

    var standardOutput: ExecutableStandardStream? {get}

    var standardError: ExecutableStandardStream? {get}

    var currentDirectoryURL: URL? {get}

    var executableName: String {get}
    
}

extension Executable {
    
    public var executableName: String {
        Self.executableName
    }

    public var environment: [String : String]? {nil}

    public var standardInput: ExecutableStandardStream? {nil}

    public var standardOutput: ExecutableStandardStream? {nil}

    public var standardError: ExecutableStandardStream? {nil}

    public var currentDirectoryURL: URL? {nil}
    
    public func checkValid() throws {
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
        if let environment = self.environment {
            process.environment = environment
        }
        if let standardInput = self.standardInput?.valueForProcess {
            process.standardInput = standardInput
        }
        if let standardOutput = self.standardOutput?.valueForProcess {
            process.standardOutput = standardOutput
        }
        if let standardError = self.standardError?.valueForProcess {
            process.standardError = standardError
        }
        if let currentDirectoryURL = self.currentDirectoryURL {
            #if os(macOS)
            if #available(OSX 10.13, *) {
                process.currentDirectoryURL = currentDirectoryURL
            } else {
                process.currentDirectoryPath = currentDirectoryURL.path
            }
            #else
            process.currentDirectoryURL = currentDirectoryURL
            #endif
        }
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
        CollectionOfOne(executableName) + arguments
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

    public var environment: [String : String]?

    public var standardInput: ExecutableStandardStream?

    public var standardOutput: ExecutableStandardStream?

    public var standardError: ExecutableStandardStream?

    public var currentDirectoryURL: URL?
    
    public let arguments: [String]
    
}

public class ProcessOperation: Operation {
    
    internal let _process: Process
    
    public init(_ process: Process) {
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

public extension OperationQueue {
    func add(_ process: Process) {
        addOperation(ProcessOperation(process))
    }
    
    func add<E: Executable>(_ executable: E/*, preparation: (Process) -> Void*/) {
        let p = try! executable.generateProcess()
//        preparation(p)
        addOperation(ProcessOperation(p))
    }
}
#endif
