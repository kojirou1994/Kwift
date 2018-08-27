//
//  Autoreleasepool.swift
//  Kwift
//
//  Created by Kojirou on 2018/7/8.
//

import Foundation

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public func autoreleasepoolIfDarwin<Result>(invoking body: () throws -> Result) rethrows -> Result {
    return try autoreleasepool(invoking: body)
}
#else
public func autoreleasepoolIfDarwin<Result>(invoking body: () throws -> Result) rethrows -> Result {
    return try body()
}
#endif
