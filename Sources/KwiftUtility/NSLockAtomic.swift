import Foundation

public final class NSLockAtomic<T> {

  private let lock: NSLock = .init()
  public private(set) var value: T

  public init(value: T) {
    self.value = value
  }

  public func withLock(_ body: (inout T) throws-> Void) rethrows {
    lock.lock()
    try body(&value)
    lock.unlock()
  }

}
