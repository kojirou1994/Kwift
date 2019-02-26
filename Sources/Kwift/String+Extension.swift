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
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var lastPathComponent2: String.SubSequence {
        let splited = split(separator: "/")
        if splited.count > 0 {
            return splited.last!
        } else {
            return "/"
        }
    }
    
    public var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        if hasSuffix("/") {
            return appending(str)
        } else {
            return appending("/\(str)")
        }
    }
    
    public func appendingPathComponentURL(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    public var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    public func appendingPathExtension(_ str: String) -> String {
        return (self as NSString).appendingPathExtension(str)!
    }
    
    public func safeFilename(_ replacingString: String = "_") -> String {
            // characterSet contains all illegal characters on OS X and Windows
        let illegalCharacters = CharacterSet(charactersIn: "\"\\/?<>:*|\n\r")
            // replace "-" with character of choice
        return components(separatedBy: illegalCharacters).joined(separator: replacingString)
    }
    
    public var firstUppercased: String {
        if isEmpty {
            return ""
        }
        #if swift(>=5.0)
        let firstC = self[startIndex].uppercased()
        #else
        let firstC = String(self[startIndex]).uppercased()
        #endif
        return replacingCharacters(in: ...startIndex, with: firstC)
    }
}
