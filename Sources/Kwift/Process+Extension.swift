//
//  Process+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2018/2/3.
//

#if os(macOS) || os(Linux)
import Foundation

public enum ExeSearchError: Error {
    case pathNull
    case executableNotFound(String)
}

extension Process {

    public convenience init(executableName: String, arguments: [String]) throws {
        guard let PATH = ProcessInfo.processInfo.environment["PATH"] else {
            throw ExeSearchError.pathNull
        }
        let paths = PATH.split(separator: ":")
        for path in paths {
            let tmp = String(path).appendingPathComponent(executableName)
            if FileManager.default.isExecutableFile(atPath: tmp) {
                self.init()
                if #available(OSX 10.13, *) {
                    self.executableURL = URL.init(fileURLWithPath: tmp)
                } else {
                    self.launchPath = tmp
                }
//                self.environment = ProcessInfo.processInfo.environment
                self.arguments = arguments
                return
            }
        }
        throw ExeSearchError.executableNotFound(executableName)
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
