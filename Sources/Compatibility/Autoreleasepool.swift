//
//  Autoreleasepool.swift
//  Kwift
//
//  Created by Kojirou on 2018/7/8.
//

import Foundation

public func autoreleasepoolIfDarwin<Result>(invoking body: () throws -> Result) rethrows -> Result {
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    return try autoreleasepool(invoking: body)
    #else
    return try body()
    #endif
}