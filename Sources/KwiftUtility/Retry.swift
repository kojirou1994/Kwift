@discardableResult
@inlinable
public func retry<T>(body: @autoclosure () throws -> T, count: UInt = 3,
                     onError: ((UInt, Error) ->Void)?) rethrows -> T {
    for i in 0...count {
        do {
            let t = try body()
            return t
        } catch {
            if i == count {
                throw error
            } else {
                onError?(i, error)
            }
        }
    }
    fatalError()
}
