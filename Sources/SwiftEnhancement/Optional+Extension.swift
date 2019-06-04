//
//  Optional+Extension.swift
//  SwiftEnhancement
//
//  Created by Kojirou on 2019/5/28.
//

import Foundation

public struct NilError: Error, CustomStringConvertible {
    
    public let file: String
    
    public let line: Int
    
    internal init(file: String, line: Int) {
        self.file = file
        self.line = line
    }
    
    public var description: String {
        return "Nil value returned at \(file):\(line)"
    }
    
}

extension Optional {
    
    @discardableResult
    public func unwrap(file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let value = self else {
            throw NilError.init(file: file, line: line)
        }
//        print(String(describing: Wrapped.self))
        return value
    }
    
}
