#if !canImport(Darwin)
@inlinable @inline(__always)
public func autoreleasepool<Result>(invoking body: () throws -> Result) rethrows -> Result {
    try body()
}
#endif
