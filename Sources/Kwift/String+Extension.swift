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
    
    public subscript(bounds: PartialRangeFrom<Int>) -> String.SubSequence {
        return self[index(startIndex, offsetBy: bounds.lowerBound)...]
    }
    
    public subscript(bounds: PartialRangeUpTo<Int>) -> String.SubSequence {
        return self[..<index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    public subscript(bounds: PartialRangeThrough<Int>) -> String.SubSequence {
        return self[...index(startIndex, offsetBy: bounds.upperBound)]
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
        return fileURL.deletingLastPathComponent().relativePath
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return fileURL.appendingPathComponent(str).relativePath
    }
    
    public var pathExtension: String {
        return fileURL.pathExtension
    }
    
    public var deletingPathExtension: String {
        return fileURL.deletingPathExtension().relativePath
    }
    
    public func appendingPathExtension(_ str: String) -> String {
        return fileURL.appendingPathExtension(str).relativePath
    }
    
    public func safeFilename(_ replacingString: String = "_") -> String {
            // characterSet contains all illegal characters on OS X and Windows
        let illegalCharacters = CharacterSet(charactersIn: "\"\\/?<>:*|\n\r")
            // replace "-" with character of choice
        return components(separatedBy: illegalCharacters).joined(separator: replacingString)
    }
    
}
