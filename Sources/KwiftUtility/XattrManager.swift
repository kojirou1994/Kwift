#if canImport(Darwin)
import Foundation

public final class XattrManager {

    public init() {}

    public typealias XattrType = Data

    ///
    /// - Parameters:
    ///   - url: The file URL
    ///   - options: noFollow and showCompression are accepted
    public func xattributesOfItem(atURL url: URL, options: XattrOptions) throws -> [String : XattrType] {
        assert(options.isSubset(of: [.noFollow, .showCompression]))
        return try url.path.withCString { path in
            var result = [String : XattrType]()

            try _listxattr(path, options: options.rawValue)
                .enumerateLines(separator: 0, ignoreLastEmptyLine: true, { (key, _, _) in
                    result[key] = try _getxattr(path: path, key: key, position: 0, options: options.rawValue)
                })
            return result
        }
    }

    ///
    /// - Parameters:
    ///   - url: The file URL
    ///   - options: noFollow and showCompression are accepted
    public func xattributeKeysOfItem(atURL url: URL, options: XattrOptions) throws -> [String] {
        assert(options.isSubset(of: [.noFollow, .showCompression]))
        return try _listxattr(url.path, options: options.rawValue)
            .split(separator: 0)
            .map { String(decoding: $0, as: UTF8.self) }
    }

    ///
    /// - Parameters:
    ///   - url: The file URL
    ///   - key: specific key
    ///   - options: noFollow and showCompression are accepted
    public func xattributeOfItem(atURL url: URL, for key: String, options: XattrOptions) throws -> XattrType {
        assert(options.isSubset(of: [.noFollow, .showCompression]))
        return try _getxattr(path: url.path, key: key, position: 0, options: options.rawValue)
    }

    /// set xattr value for specific key
    /// - Parameters:
    ///   - value: xattr value
    ///   - key: xattr key
    ///   - url: The file URL
    ///   - options: noFollow, create and replace are accepted
    public func setXattribute(_ value: XattrType, for key: String, ofItemAtURL url: URL, options: XattrOptions) throws {
        assert(options.isSubset(of: [.noFollow, .create, .replace]))
        try value.withUnsafeBytes { buffer in
            let value = setxattr(url.path, key, buffer.baseAddress, buffer.count, 0, options.rawValue)
            if value == -1 {
                throw StdError.current
            }
        }

    }

    /// remove all xattr of the file
    /// - Parameters:
    ///   - url: The file URL
    ///   - options: noFollow and showCompression are accepted
    public func removeAllXattributesOfItem(atURL url: URL, options: XattrOptions) throws {
        assert(options.isSubset(of: [.noFollow, .showCompression]))
        try url.path.withCString { path in
            try _listxattr(path, options: options.rawValue)
                .split(separator: 0)
                .forEach { (keyData) in
                    let key = String(decoding: keyData, as: UTF8.self)
                    try _removexattr(path: path, name: key, options: options.rawValue)
            }
        }
    }

    /// remove xattr for specific key
    /// - Parameters:
    ///   - url: The file URL
    ///   - key: xattr key
    ///   - options: noFollow and showCompression are accepted
    public func removeXattributeOfItem(atURL url: URL, for key: String, options: XattrOptions) throws {
        assert(options.isSubset(of: [.noFollow, .showCompression]))
        try _removexattr(path: url.path, name: key, options: options.rawValue)
    }

    private func _getxattr(path: UnsafePointer<Int8>, key: String, position: UInt32, options: Int32) throws -> XattrType {
        try key.withCString { name in
            let size = getxattr(path, name, nil, 0, position, options)
            guard size != -1 else {
                throw StdError.current
            }
            let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: size)
            guard getxattr(path, name, buffer, size, position, options) != -1 else {
                throw StdError.current
            }
            return Data(bytesNoCopy: buffer, count: size, deallocator: .free)
        }
    }

    private func _removexattr(path: UnsafePointer<Int8>, name: UnsafePointer<Int8>, options: Int32) throws {
        let value = removexattr(path, name, options)
        if value == -1 {
            throw StdError.current
        }
    }

    private func _listxattr(_ path: UnsafePointer<Int8>, options: Int32) throws -> XattrType {
        let size = listxattr(path, nil, 0, options)
        guard size != -1 else {
            throw StdError.current
        }
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: size)
        guard listxattr(path, buffer, size, options) != -1 else {
            throw StdError.current
        }
        return Data(bytesNoCopy: buffer, count: size, deallocator: .free)
    }

}

extension XattrManager {
    public struct XattrOptions: OptionSet {

        public var rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        /// Don't follow symbolic links
        public static let noFollow = Self(rawValue: XATTR_NOFOLLOW)
        /// set the value, fail if attr already exists
        public static let create = Self(rawValue: XATTR_CREATE)
        /// set the value, fail if attr does not exist
        public static let replace = Self(rawValue: XATTR_REPLACE)
        /// option for f/getxattr() and f/listxattr() to expose the HFS Compression extended attributes
        public static let showCompression = Self(rawValue: XATTR_SHOWCOMPRESSION)
        /*
         currently useless
         /// Set this to bypass authorization checking (eg. if doing auth-related work)
         public static let noSecurity = Self(rawValue: XATTR_NOSECURITY)
         /// Set this to bypass the default extended attribute file (dot-underscore file)
         public static let noDefault = Self(rawValue: XATTR_NODEFAULT)
         */
    }
}
#endif
/*
 import Darwin
 import SwiftOverlayShims

 /*
 * Copyright (c) 2004-2012 Apple Inc. All rights reserved.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. The rights granted to you under the License
 * may not be used to create, or enable the creation or redistribution of,
 * unlawful or unlicensed copies of an Apple operating system, or to
 * circumvent, violate, or enable the circumvention or violation of, any
 * terms of an Apple operating system software license agreement.
 *
 * Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_END@
 */

 /* Options for pathname based xattr calls */
 public var XATTR_NOFOLLOW: Int32 { get } /* Don't follow symbolic links */

 /* Options for setxattr calls */
 public var XATTR_CREATE: Int32 { get } /* set the value, fail if attr already exists */
 public var XATTR_REPLACE: Int32 { get } /* set the value, fail if attr does not exist */

 /* Set this to bypass authorization checking (eg. if doing auth-related work) */
 public var XATTR_NOSECURITY: Int32 { get }

 /* Set this to bypass the default extended attribute file (dot-underscore file) */
 public var XATTR_NODEFAULT: Int32 { get }

 /* option for f/getxattr() and f/listxattr() to expose the HFS Compression extended attributes */
 public var XATTR_SHOWCOMPRESSION: Int32 { get }

 public var XATTR_MAXNAMELEN: Int32 { get }

 /* See the ATTR_CMN_FNDRINFO section of getattrlist(2) for details on FinderInfo */
 public var XATTR_FINDERINFO_NAME: String { get }

 public var XATTR_RESOURCEFORK_NAME: String { get }

 public func getxattr(_ path: UnsafePointer<Int8>!, _ name: UnsafePointer<Int8>!, _ value: UnsafeMutableRawPointer!, _ size: Int, _ position: UInt32, _ options: Int32) -> Int

 public func fgetxattr(_ fd: Int32, _ name: UnsafePointer<Int8>!, _ value: UnsafeMutableRawPointer!, _ size: Int, _ position: UInt32, _ options: Int32) -> Int

 public func setxattr(_ path: UnsafePointer<Int8>!, _ name: UnsafePointer<Int8>!, _ value: UnsafeRawPointer!, _ size: Int, _ position: UInt32, _ options: Int32) -> Int32

 public func fsetxattr(_ fd: Int32, _ name: UnsafePointer<Int8>!, _ value: UnsafeRawPointer!, _ size: Int, _ position: UInt32, _ options: Int32) -> Int32

 public func removexattr(_ path: UnsafePointer<Int8>!, _ name: UnsafePointer<Int8>!, _ options: Int32) -> Int32

 public func fremovexattr(_ fd: Int32, _ name: UnsafePointer<Int8>!, _ options: Int32) -> Int32

 public func listxattr(_ path: UnsafePointer<Int8>!, _ namebuff: UnsafeMutablePointer<Int8>!, _ size: Int, _ options: Int32) -> Int

 public func flistxattr(_ fd: Int32, _ namebuff: UnsafeMutablePointer<Int8>!, _ size: Int, _ options: Int32) -> Int

 */
