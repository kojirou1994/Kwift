#if !swift(>=3.3) || (swift(>=4) && !swift(>=4.1))
public extension Sequence {
    public func compactMap<T>(_ transform: (Element) throws -> T?) rethrows -> [T] {
        return try flatMap { arg -> [T] in try transform(arg).map { [$0] } ?? [] }
    }
}
#endif
