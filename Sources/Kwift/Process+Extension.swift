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
        let paths = PATH.components(separatedBy: ":")
        for path in paths {
            let tmp = URL.init(fileURLWithPath: path).appendingPathComponent(executableName).path
            if FileManager.default.fileExists(atPath: tmp), FileManager.default.isExecutableFile(atPath: tmp) {
                self.init()
                self.launchPath = tmp
                self.environment = ProcessInfo.processInfo.environment
                self.arguments = arguments
                return
            }
        }
        throw ExeSearchError.executableNotFound(executableName)
    }

}

#endif
