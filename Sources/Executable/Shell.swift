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
    
    public var preparation: ProcessPreparation?
    
    let background: Bool
    
    let customPaths: [Substring]?
    
    public init(background: Bool = false, customPath: String? = nil, preparation: ProcessPreparation? = nil) {
        self.preparation = preparation
        self.customPaths = customPath?.split(separator: ":")
        self.background = background
    }
    
    public subscript(dynamicMember key: String) -> ShellProcess {
        get {
            return ShellProcess.init(executablePath: .init(catching: { try Process.loookup(key, customPaths: customPaths)}), preparation: preparation, background: background)
        }
    }
    
    @dynamicCallable
//    @dynamicMemberLookup
    public struct ShellProcess {
        let executablePath: Result<String, Error>
        
        let preparation: ProcessPreparation?
        
        let background: Bool
        
        fileprivate init(executablePath: Result<String, Error>, preparation: ProcessPreparation?, background: Bool) {
            self.executablePath = executablePath
            self.preparation = preparation
            self.background = background
        }
        
//        public subscript(dynamicMember key: String) -> ShellProcess {
//            return .init(executablePath: executablePath + "-" + key, preparation: preparation, background: background)
//        }
        
        @discardableResult
        public func dynamicallyCall(withArguments arguments: [String]) throws -> Process {
            let executablePath = try self.executablePath.get()
            let p = Process.init()
            if #available(OSX 10.13, *) {
                p.executableURL = URL.init(fileURLWithPath: executablePath)
            } else {
                p.launchPath = executablePath
            }
            p.arguments = arguments
            preparation?(p)
            try p.kwift_run(wait: !background)
            return p
        }
    }
    
}

#endif
