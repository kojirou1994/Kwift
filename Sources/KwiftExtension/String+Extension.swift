// MARK: Int based Subscript
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
        self[index(startIndex, offsetBy: bounds.lowerBound)...]
    }
    
    @inlinable
    public subscript(bounds: PartialRangeUpTo<Int>) -> String.SubSequence {
        self[..<index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    @inlinable
    public subscript(bounds: PartialRangeThrough<Int>) -> String.SubSequence {
        self[...index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    @inlinable
    public subscript(i: Int) -> Character {
        self[index(startIndex, offsetBy: i)]
    }
    
}

#if canImport(Foundation)
import Foundation
// MARK: Utility

// characterSet contains all illegal characters on OS X and Windows
private let illegalCharacters = CharacterSet(charactersIn: "\"\\/?<>:*|\n\r")

extension StringProtocol {
    
    public func safeFilename(_ replacingString: String = "_") -> String {
        components(separatedBy: illegalCharacters).joined(separator: replacingString)
    }
    
    public func ranges<T>(of aString: T, options mask: String.CompareOptions = [], locale: Locale? = nil) -> [Range<Self.Index>] where T : StringProtocol {
        var result = [Range<Self.Index>]()
        var start = startIndex
        while let range = range(of: aString, options: mask, range: start..<endIndex, locale: locale) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    //    public var firstUppercased: String {
    //        if isEmpty {
    //            return ""
    //        }
    //        let firstC = self[startIndex].uppercased()
    //        return replacingCharacters(in: ...startIndex, with: firstC)
    //    }
    
}

#endif

#if !os(Linux)

extension String.Encoding {
    
    @inlinable
    public init(_ cfEncoding: CFStringEncodings) {
        self.init(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue)))
    }
    
}

#endif

extension StringProtocol {
    
    @inlinable
    public var isBlank: Bool {
        allSatisfy {$0.isWhitespace}
    }
    
}

extension Optional where Wrapped: StringProtocol {
    
    @inlinable
    public var isBlank: Bool {
        switch self {
        case .none:
            return true
        case .some(let v):
            return v.allSatisfy {$0.isWhitespace}
        }
    }
    
}