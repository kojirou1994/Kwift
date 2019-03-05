//
//  Bool+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2018/7/26.
//

import Foundation

#if !swift(>=4.2)
extension Bool {
    mutating func toggle() {
        self = !self
    }
}
#endif
