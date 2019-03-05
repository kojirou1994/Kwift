//
//  rusage.swift
//  Kwift
//
//  Created by Kojirou on 2018/11/25.
//

import Foundation

extension rusage: CustomStringConvertible {
    
    public var description: String {
        return """
        user time used (PL): \(ru_utime)
        system time used (PL): \(ru_stime)
        max resident set size (PL): \(ru_maxrss)
        integral shared memory size (NU): \(ru_ixrss)
        integral unshared data (NU): \(ru_idrss)
        integral unshared stack (NU): \(ru_isrss)
        page reclaims (NU): \(ru_minflt)
        page faults (NU): \(ru_majflt)
        swaps (NU): \(ru_nswap)
        block input operations (atomic): \(ru_inblock)
        block output operations (atomic): \(ru_oublock)
        messages sent (atomic): \(ru_msgsnd)
        messages received (atomic): \(ru_msgrcv)
        signals received (atomic): \(ru_nsignals)
        voluntary context switches (atomic): \(ru_nvcsw)
        involuntary: \(ru_nivcsw)
        """
    }
    
    public static func display() {
        rusage.shared.update()
        print(rusage.shared)
    }
    
    public static var shared: rusage = .init()
    
    public mutating func update() {
        getrusage(0, &self)
    }
}
