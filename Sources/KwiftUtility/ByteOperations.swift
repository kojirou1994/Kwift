//
//  ByteOperations.swift
//  Kwift
//
//  Created by Kojirou on 2019/1/28.
//

import Foundation

extension FixedWidthInteger {
    
    public var binaryString: String {
        var result: [String] = []
        let count = Self.bitWidth / 8
        for i in 1...count {
            let byte = UInt8(truncatingIfNeeded: self >> ((count - i) * 8))
            let byteString = String(byte, radix: 2)
            let padding = String(repeating: "0", count: 8 - byteString.count)
            result.append(padding + byteString)
        }
        return "0b" + result.joined(separator: "_")
    }
    
    public func hexString(uppercase: Bool = false, prefix: String = "0x") -> String {
        var result: [String] = []
        let count = Self.bitWidth / 8
        for i in 1...count {
            let byte = UInt8(truncatingIfNeeded: self >> ((count - i) * 8))
            let byteString = String(byte, radix: 16, uppercase: uppercase)
            let padding = String(repeating: "0", count: 2 - byteString.count)
            result.append(padding + byteString)
        }
        return prefix + result.joined(separator: "")
    }
    
    @available(*, unavailable)
    public func split() -> [UInt8] {
        var result = [UInt8]()
        withUnsafeBytes(of: self) { (p) -> Void in
            let new = p.bindMemory(to: UInt8.self)
            let count = Self.bitWidth / 8
            for i in 0..<count {
                result.append(new[i])
            }
        }
        return result.reversed()
    }
    
    public var splited: [UInt8] {
        let count = Self.bitWidth / 8
        var result = [UInt8].init(repeating: 0, count: count)
        for i in 1...count {
            result[i-1] = UInt8.init(truncatingIfNeeded: self >> ( (count - i) * 8))
        }
        return result
    }
    
}

extension Collection where Element == UInt8 {
    
    public func joined<T>(_ type: T.Type) -> T where T : FixedWidthInteger {
        let byteCount = T.bitWidth / 8
        var result = T.init()
        for element in enumerated() {
            if element.offset == byteCount {
                break
            }
            result = (result << 8) | T(truncatingIfNeeded: element.element)
        }
        return result
    }
    
    public func joined<T>() -> T where T : FixedWidthInteger {
        return joined(T.self)
    }
    
    public func hexString(uppercase: Bool = false, prefix: String = "0x") -> String {
        return prefix + map {$0.hexString(uppercase: uppercase, prefix: "")}.joined()
    }
    
}
