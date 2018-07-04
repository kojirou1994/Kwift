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

public enum ResultWithError<T, E: Error> {
    case success(T)
    case failed(E)
}


public struct ResultClosure<T> {
    public var success: ((_ result: T) -> ())?
    public var failure: ((_ error: Error) -> ())?
    
    public init(success: ((T) -> ())? = nil, failure: ((Error) -> ())? = nil) {
        self.success = success
        self.failure = failure
    }
}
