@discardableResult
@inlinable
public func retry<T>(body: @autoclosure () throws -> T,
                     maxFailureCount: UInt = 3,
                     onError errorHandler: (_ failedCount: UInt, _ error: Error) -> Void = {_,_ in}) rethrows -> T {
  for i in 0..<maxFailureCount {
    do {
      return try body()
    } catch {
      errorHandler(i+1, error)
    }
  }
  return try body()
}
