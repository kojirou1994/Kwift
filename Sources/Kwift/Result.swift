//
//  Result.swift
//  Kwift
//
//  Created by Kojirou on 2018/2/25.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

extension Result {
    
    public func resolve() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
}

public enum ResultWithError<Value, E: Error> {
    case success(Value)
    case failure(E)
}

extension ResultWithError {
    
    public func resolve() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
}

public struct ResultClosure<Value> {
    
    public var success: Handler<Value>?
    public var failure: Handler<Error>?
    public var completion: Handler<Result<Value>>?
    
    public typealias Handler<T> = (T) -> ()
    
    public init(success: Handler<Value>? = nil, failure: Handler<Error>? = nil, completion: Handler<Result<Value>>? = nil) {
        self.success = success
        self.failure = failure
        self.completion = completion
    }
}
