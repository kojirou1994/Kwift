#if os(macOS) || os(Linux)
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
    
    /// add process to manager
    ///
    /// - Parameter process: process must be running
    public func add(process: Process) {
        guard process.isRunning else {
            return
        }
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
#endif
