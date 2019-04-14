//
//  Shell.swift
//  Kwift
//
//  Created by Kojirou on 2019/2/7.
//

import Foundation

#if swift(>=5.0)

@dynamicMemberLookup
public struct Shell {
    
    public typealias ProcessPreparation = (Process) -> Void
    
    public var beforeRun: ProcessPreparation?
    
    let background: Bool
    
    let customPaths: [Substring]?
    
    public init(background: Bool = false, customPath: String? = nil, beforeRun: ProcessPreparation? = nil) {
        self.beforeRun = beforeRun
        self.customPaths = customPath?.split(separator: ":")
        self.background = background
    }
    
    public subscript(dynamicMember key: String) -> ShellProcess {
        get {
            return ShellProcess.init(executablePath: .init(catching: { try Process.loookup(key, customPaths: customPaths)}), beforeRun: beforeRun, background: background)
        }
    }
    
    @dynamicCallable
//    @dynamicMemberLookup
    public struct ShellProcess {
        let executablePath: Result<String, Error>
        
        let beforeRun: ProcessPreparation?
        
        let background: Bool
        
        fileprivate init(executablePath: Result<String, Error>, beforeRun: ProcessPreparation?, background: Bool) {
            self.executablePath = executablePath
            self.beforeRun = beforeRun
            self.background = background
        }
        
//        public subscript(dynamicMember key: String) -> ShellProcess {
//            return .init(executablePath: executablePath + "-" + key, preparation: preparation, background: background)
//        }
        
//        @discardableResult
        public func dynamicallyCall(withArguments arguments: [String]) throws -> LaunchResult {
            let executablePath = try self.executablePath.get()
            let process = Process.init()
            if #available(OSX 10.13, *) {
                process.executableURL = URL.init(fileURLWithPath: executablePath)
            } else {
                process.launchPath = executablePath
            }
            process.arguments = arguments
            beforeRun?(process)
            
            return try process.catchResult()
        }
        
    }
    
}

internal extension Process {
    func catchResult() throws -> LaunchResult {
        let copyQueue = DispatchQueue.init(label: UUID().uuidString)
        let stderr = Pipe()
        let stdout = Pipe()
        self.standardError = stderr
        self.standardOutput = stdout
        
        var stdoutData = Data()
        var stderrData  = Data()
        stderr.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            copyQueue.async {
                stderrData.append(data)
            }
        }
        
        stdout.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            copyQueue.async {
                stdoutData.append(data)
            }
        }
        try self.kwift_run(wait: true)
        stdout.fileHandleForReading.readabilityHandler = nil
        stderr.fileHandleForReading.readabilityHandler = nil
        return copyQueue.sync {
            return LaunchResult.init(process: self, stdout: stdoutData, stderr: stderrData)
        }
    }
}

public struct LaunchResult {
    public let process: Process
    public let stdout: Data
    public let stderr: Data
    
    public var terminationStatus: Int32 {
        return process.terminationStatus
    }
}

#endif
