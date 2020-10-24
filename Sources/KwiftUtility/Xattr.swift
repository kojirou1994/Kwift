#if canImport(Darwin)
import Foundation

public enum Xattr {

  public typealias XattrType = Data

  ///
  /// - Parameters:
  ///   - url: The file URL
  ///   - options: noFollow and showCompression are accepted
  public static func xattributesOfItem(atURL url: URL, options: XattrOptions) throws -> [String : XattrType] {
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
  public static func xattributeKeysOfItem(atURL url: URL, options: XattrOptions) throws -> [String] {
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
  public static func xattributeOfItem(atURL url: URL, for key: String, options: XattrOptions) throws -> XattrType {
    assert(options.isSubset(of: [.noFollow, .showCompression]))
    return try _getxattr(path: url.path, key: key, position: 0, options: options.rawValue)
  }

  /// set xattr value for specific key
  /// - Parameters:
  ///   - value: xattr value
  ///   - key: xattr key
  ///   - url: The file URL
  ///   - options: noFollow, create and replace are accepted
  public static func setXattribute(_ value: XattrType, for key: String, ofItemAtURL url: URL, options: XattrOptions) throws {
    assert(options.isSubset(of: [.noFollow, .create, .replace]))
    try value.withUnsafeBytes { buffer in
      try preconditionOrThrow(setxattr(url.path, key, buffer.baseAddress, buffer.count, 0, options.rawValue) != -1, StdError.current)
    }
  }

  /// remove all xattr of the file
  /// - Parameters:
  ///   - url: The file URL
  ///   - options: noFollow and showCompression are accepted
  public static func removeAllXattributesOfItem(atURL url: URL, options: XattrOptions) throws {
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
  public static func removeXattributeOfItem(atURL url: URL, for key: String, options: XattrOptions) throws {
    assert(options.isSubset(of: [.noFollow, .showCompression]))
    try _removexattr(path: url.path, name: key, options: options.rawValue)
  }

  private static func _getxattr(path: UnsafePointer<Int8>, key: String, position: UInt32, options: Int32) throws -> XattrType {
    try key.withCString { name in
      let size = getxattr(path, name, nil, 0, position, options)
      try preconditionOrThrow(size != -1, StdError.current)
      let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: size)
      try preconditionOrThrow(getxattr(path, name, buffer, size, position, options) != -1, StdError.current)
      return .init(bytesNoCopy: buffer, count: size, deallocator: .free)
    }
  }

  private static func _removexattr(path: UnsafePointer<Int8>, name: UnsafePointer<Int8>, options: Int32) throws {
    try preconditionOrThrow(removexattr(path, name, options) != -1, StdError.current)
  }

  private static func _listxattr(_ path: UnsafePointer<Int8>, options: Int32) throws -> XattrType {
    let size = listxattr(path, nil, 0, options)
    try preconditionOrThrow(size != -1, StdError.current)
    let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: size)
    try preconditionOrThrow(listxattr(path, buffer, size, options) != -1, StdError.current)
    return Data(bytesNoCopy: buffer, count: size, deallocator: .free)
  }

}

extension Xattr {
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

  public static var maxNameLength: Int32 { XATTR_MAXNAMELEN }

  /* See the ATTR_CMN_FNDRINFO section of getattrlist(2) for details on FinderInfo */
  public static var finderInfoName: String { XATTR_FINDERINFO_NAME }

  public static var resourceForkName: String { XATTR_RESOURCEFORK_NAME }
}
#endif
