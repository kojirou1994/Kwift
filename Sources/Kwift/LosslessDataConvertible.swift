//
//  LosslessDataConvertible.swift
//  Kwift
//
//  Created by Kojirou on 2019/2/6.
//

import Foundation

public protocol LosslessDataConvertible {
    
    init(_ data: Data) throws
    
    var data: Data { get }
    
}
