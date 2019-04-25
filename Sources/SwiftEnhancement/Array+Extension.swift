//
//  Array+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2017/2/15.
//
//

import Foundation

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
