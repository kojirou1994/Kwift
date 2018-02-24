//
//  Result.swift
//  Kwift
//
//  Created by Kojirou on 2018/2/25.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failed(Error)
}
