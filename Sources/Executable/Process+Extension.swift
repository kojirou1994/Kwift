//
//  Process+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2018/2/3.
//

import Foundation

#if os(macOS) || os(Linux)
public enum ExecutableError: Error {
    case pathNull
    case executableNotFound(String)
    case nonZeroExitCode(Int32)
}

extension Process {

    private static var PATHs = ProcessInfo.processInfo.environment["PATH", default: ""].split(separator: ":")
    
    public static func set(path: String) {
        Process.PATHs = path.split(separator: ":")
    }
    
    public convenience init(executableName: String, arguments: [String]) throws {
        let path = try Process.lookup(executableName)
        self.init()
        #if os(macOS)
        if #available(OSX 10.13, *) {
            self.executableURL = URL.init(fileURLWithPath: path)
        } else {
            self.launchPath = path
        }
        #else
        self.executableURL = URL.init(fileURLWithPath: path)
        #endif
        self.arguments = arguments
        
    }
    
    internal static func lookup(_ executable: String, customPaths: [Substring]? = nil) throws -> String {
        let paths: [Substring]
        if let customPaths = customPaths, customPaths.count > 0 {
            paths = customPaths
        } else if Process.PATHs.count > 0 {
            paths = Process.PATHs
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
    
    @discardableResult
    public static func run(_ args: [String], wait: Bool = false,
                           beforeRun: ((Process) -> Void)? = nil) throws -> Process {
        precondition(!args.isEmpty, "args must not be empty")
        let p = try Process.init(executableName: args[0], arguments: Array(args.dropFirst()))
        beforeRun?(p)
        try p.kwift_run(wait: wait)
        return p
    }
    
    internal func kwift_run(wait: Bool, afterRun: ((Process) -> Void)? = nil) throws {
        #if os(macOS)
        if #available(OSX 10.13, *) {
            try run()
        } else {
            launch()
        }
        afterRun?(self)
        if wait {
            waitUntilExit()
        }
        #else
        try run()
        afterRun?(self)
        if wait {
            while isRunning {
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        #endif
    }

}
#endif
