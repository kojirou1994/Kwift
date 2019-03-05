//
//  Process+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2018/2/3.
//

#if os(macOS) || os(Linux)
import Foundation

public enum ExecutableError: Error {
    case pathNull
    case executableNotFound(String)
}

extension Process {

    private static let PATHs = ProcessInfo.processInfo.environment["PATH", default: ""].split(separator: ":")
    
    public convenience init(executableName: String, arguments: [String]) throws {
        let path = try Process.loookup(executableName)
        self.init()
        if #available(OSX 10.13, *) {
            self.executableURL = URL.init(fileURLWithPath: path)
        } else {
            self.launchPath = path
        }
        self.arguments = arguments
        
    }
    
    internal static func loookup(_ executable: String) throws -> String {
        guard Process.PATHs.count > 0 else {
            throw ExecutableError.pathNull
        }
        for path in Process.PATHs {
            let tmp: String
            if path.hasSuffix("/") {
                tmp = "\(path)\(executable)"
            } else {
                tmp = "\(path)/\(executable)"
            }
            if FileManager.default.isExecutableFile(atPath: tmp) {
                return tmp
            }
        }
        throw ExecutableError.executableNotFound(executable)
    }
    
    @discardableResult
    public static func run(_ args: [String], wait: Bool = false,
                           prepare: ((Process) -> Void)? = nil) throws -> Process {
        precondition(!args.isEmpty, "args must not be empty")
        let p = try Process.init(executableName: args[0], arguments: Array(args.dropFirst()))
        if let prepare = prepare {
            prepare(p)
        }
        p.launch()
        if wait {
            p.waitUntilExit()
            return p
        } else {
            return p
        }
    }

}

#endif
