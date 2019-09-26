#if os(macOS) || os(Linux)
import Foundation

public final class SubProcessManager {
    
    private let lock: NSLock
    private var pids: Set<pid_t>
    
    public init() {
        lock = .init()
        pids = .init()
    }
    
    public func terminateAll() {
        lock.lock()
        defer { lock.unlock() }
        for pid in pids {
            kill(pid, SIGTERM)
        }
    }
    
    /// add process to manager
    ///
    /// - Parameter process: process must be running
    public func add(_ process: Process) {
        guard process.isRunning else {
            return
        }
        lock.lock()
        defer { lock.unlock() }
        _ = self.pids.insert(process.processIdentifier)
    }
    
    public func remove(_ process: Process) {
        lock.lock()
        defer { lock.unlock() }
        _ = self.pids.remove(process.processIdentifier)
    }
    
}
#endif
