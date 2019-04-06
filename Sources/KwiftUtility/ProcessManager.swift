//
//  ProcessManager.swift
//  KwiftUtility
//
//  Created by Kojirou on 2019/4/5.
//

import Foundation

public class SubProcessManager {
    
    private let queue: DispatchQueue
    private var pids: Set<pid_t>
    
    public init() {
        queue = .init(label: "Kwift.ProcessManager")
        pids = .init()
    }
    
    public func terminateAll() {
        queue.sync {
            for pid in pids {
                kill(pid, SIGTERM)
            }
        }
    }
    
    public func add(process: Process) {
        queue.sync {
            _ = self.pids.insert(process.processIdentifier)
        }
    }
    
    public func remove(process: Process) {
        queue.sync {
            _ = self.pids.remove(process.processIdentifier)
        }
    }
    
}
