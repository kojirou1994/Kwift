@inlinable @inline(__always)
public func unsafeBitCast<T, U>(_ x: T) -> U {
  unsafeBitCast(x, to: U.self)
}

@inlinable @inline(__always)
public func unsafeDowncast<T>(_ x: AnyObject) -> T where T: AnyObject {
  unsafeDowncast(x, to: T.self)
}
