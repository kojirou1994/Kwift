//
//  String+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2016/11/28.
//
//

import Foundation

extension String {
    
    @usableFromInline
    func calculateIndex(_ lowerBound: Int, _ upperBound: Int) -> (Index, Index) {
        let lowerIndex = index(startIndex, offsetBy: lowerBound)
        let upperIndex = index(lowerIndex, offsetBy: upperBound - lowerBound)
        return (lowerIndex, upperIndex)
    }
    
    @inlinable
    public subscript(bounds: Range<Int>) -> String.SubSequence {
        let (lowerIndex, upperIndex) = calculateIndex(bounds.lowerBound, bounds.upperBound)
        return self[lowerIndex..<upperIndex]
    }
    
    @inlinable
    public subscript(bounds: ClosedRange<Int>) -> String.SubSequence {
        let (lowerIndex, upperIndex) = calculateIndex(bounds.lowerBound, bounds.upperBound)
        return self[lowerIndex...upperIndex]
    }
    
    @inlinable
    public subscript(bounds: PartialRangeFrom<Int>) -> String.SubSequence {
        return self[index(startIndex, offsetBy: bounds.lowerBound)...]
    }
    
    @inlinable
    public subscript(bounds: PartialRangeUpTo<Int>) -> String.SubSequence {
        return self[..<index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    @inlinable
    public subscript(bounds: PartialRangeThrough<Int>) -> String.SubSequence {
        return self[...index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    @inlinable
    public subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    @inlinable
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    @available(*, unavailable)
    public var lastPathComponent2: String.SubSequence {
        let splited = split(separator: "/")
        if splited.count > 0 {
            return splited.last!
        } else {
            return "/"
        }
    }
    
    @inlinable
    public var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    @inlinable
    public func appendingPathComponent(_ str: String) -> String {
        if hasSuffix("/") {
            return appending(str)
        } else {
            return appending("/\(str)")
        }
    }
    
    @inlinable
    public func appendingPathComponentURL(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    @inlinable
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    @inlinable
    public var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    @inlinable
    public func appendingPathExtension(_ str: String) -> String {
        return (self as NSString).appendingPathExtension(str)!
    }
    
    // characterSet contains all illegal characters on OS X and Windows
    private static let illegalCharacters = CharacterSet(charactersIn: "\"\\/?<>:*|\n\r")
    
    public func safeFilename(_ replacingString: String = "_") -> String {
//        replace "-" with character of choice
        return components(separatedBy: String.illegalCharacters).joined(separator: replacingString)
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
