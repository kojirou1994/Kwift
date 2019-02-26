//
//  Array+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2017/2/15.
//
//

import Foundation

// MARK: - Quicksort
extension Array where Element: Comparable {
    
    public var quicksorted: Array<Element> {
        var new = self
        new.quicksort()
        return new
    }
    
    public mutating func quicksort() {
        quicksort(left: 0, right: count-1)
    }
    
    private mutating func partition(left: Index, right: Index) -> Index {
        var i = left
        for j in index(left, offsetBy: 1)...right {
            if self[j] < self[left] {
                i += 1
                (self[i], self[j]) = (self[j], self[i])
            }
        }
        (self[i], self[left]) = (self[left], self[i])
        print(self)
        return i
    }
    
    private mutating func quicksort(left: Index, right: Index) {
        if right > left {
            let pivotIndex = partition(left: left, right: right)
            quicksort(left: left, right: pivotIndex - 1)
            quicksort(left: pivotIndex + 1, right: right)
        }
    }
}

extension Array {
    
    public struct Conflict<V> {
        let value: V
        var indexes: [Int]
    }
    
    public func conflicted<V>(_ block: (Element) -> V) -> [Conflict<V>] where V: Hashable {
        let useValue = map(block)
        var result = [V : [Int]]()
        //        result.reserveCapacity(useValue.count)
        for (index, value) in useValue.enumerated() {
            result[value, default: []].append(index)
        }
        return result.compactMap({ (e) -> Conflict<V>? in
            if e.value.count > 1 {
                return Conflict<V>.init(value: e.key, indexes: e.value)
            } else {
                return nil
            }
        })
    }
}

#if !swift(>=3.3) || (swift(>=4) && !swift(>=4.1))
public extension Sequence {
    public func compactMap<T>(_ transform: (Element) throws -> T?) rethrows -> [T] {
        return try flatMap { arg -> [T] in try transform(arg).map { [$0] } ?? [] }
    }
}
#endif
