//
//  String+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2016/11/28.
//
//

import Foundation

extension String {
    
    public subscript(bounds: Range<Int>) -> String.SubSequence {
        return self[index(startIndex, offsetBy: bounds.lowerBound)..<index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    public subscript(bounds: ClosedRange<Int>) -> String.SubSequence {
        return self[index(startIndex, offsetBy: bounds.lowerBound)...index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    public subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    public var fileURL: URL {
        return URL.init(fileURLWithPath: self)
    }
    
    public var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
    
    public var deletingLastPathComponent: String {
        return fileURL.deletingLastPathComponent().path
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return fileURL.appendingPathComponent(str).path
    }
    
    public var pathExtension: String {
        return fileURL.pathExtension
    }
    
    public var deletingPathExtension: String {
        return fileURL.deletingPathExtension().path
    }
    
    public func appendingPathExtension(_ str: String) -> String? {
        return fileURL.appendingPathExtension(str).path
    }
    
}
