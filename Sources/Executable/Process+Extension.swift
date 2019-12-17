#if os(macOS) || os(Linux)
import Foundation

extension Process {
    
    internal func kwift_run(wait: Bool, afterRun: ((Process) -> Void)? = nil) throws {
        #if os(macOS)
        if #available(OSX 10.13, *) {
//            try autoreleasepool {
                try run()
//            }
        } else {
//            autoreleasepool {
                launch()
//            }
        }
        #else
        try run()
        #endif
        afterRun?(self)
        if wait {
            while isRunning {
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
    }

}
#endif
