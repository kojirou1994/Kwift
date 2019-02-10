//
//  Shell.swift
//  Kwift
//
//  Created by Kojirou on 2019/2/7.
//

import Foundation

@dynamicMemberLookup
public struct Shell {
    
    public typealias ProcessPreparation = (Process) -> Void
    
    public var preparation: ProcessPreparation?
    
    let background: Bool
    
    public init(background: Bool = false, preparation: ProcessPreparation? = nil) {
        self.preparation = preparation
        self.background = background
    }
    
    public subscript(dynamicMember key: String) -> ShellProcess {
        get {
            return ShellProcess.init(executable: key, preparation: preparation, background: background)
        }
    }
    
    @dynamicCallable
    @dynamicMemberLookup
    public struct ShellProcess {
        let executable: String
        
        let preparation: ProcessPreparation?
        
        let background: Bool
        
        fileprivate init(executable: String, preparation: ProcessPreparation?, background: Bool) {
            self.executable = executable
            self.preparation = preparation
            self.background = background
        }
        
        public subscript(dynamicMember key: String) -> ShellProcess {
            return .init(executable: executable + "-" + key, preparation: preparation, background: background)
        }
        
        @discardableResult
        public func dynamicallyCall(withArguments arguments: [String]) -> Process {
            let p = Process.init()
            let path: String
            do {
                path = try Process.loookup(executable)
            } catch {
                print(error)
                exit(1)
            }
            if #available(OSX 10.13, *) {
                p.executableURL = URL.init(fileURLWithPath: path)
            } else {
                p.launchPath = path
            }
            p.arguments = arguments
            preparation?(p)
            p.launch()
            if !background {
                p.waitUntilExit()
            }
            return p
        }
    }
    
}
