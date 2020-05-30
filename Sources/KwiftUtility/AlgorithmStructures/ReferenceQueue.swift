public struct ReferenceQueue<Element>: RandomAccessCollection, MutableCollection, RangeReplaceableCollection, CustomStringConvertible where Element: AnyObject {

  @usableFromInline
  internal var _queue: ContiguousArray<Element?> = .init()

  @usableFromInline
  internal var garbageCount: Int = 0

  @inlinable
  public var startIndex: Int { garbageCount }

  @inlinable
  public var endIndex: Int { _queue.endIndex }

  @inlinable
  public init() {
  }

  @inlinable
  public mutating func append(_ newElement: Element) {
    _queue.append(newElement)
  }

  @inlinable
  public mutating func append<S>(contentsOf newElements: S) where S : Sequence, Element == S.Element {
    newElements.forEach {_queue.append($0)}
  }

  //    public mutating func removeFirst(_ k: Int) {
  //        guard !isEmpty, k > 0 else {
  //            return
  //        }
  //        precondition(k <= count, "Can't remove more items from a collection than it has")
  //
  //    }

  @discardableResult
  public mutating func removeFirst() -> Element? {
    guard !isEmpty else {
      return nil
    }
    defer {
      _queue[startIndex] = nil
      garbageCount += 1
      if needRemoveGarbage {
        removeGarbage()
      }
    }
    return _queue[startIndex]
  }

  @inlinable
  public mutating func removeGarbage() {
    _queue.removeFirst(garbageCount)
    garbageCount = 0
  }

  @inlinable
  public mutating func removeAll() {
    _queue.removeAll()
    garbageCount = 0
  }

  @inline(__always) private var needRemoveGarbage: Bool {
    _queue.count > 100 && garbageCount >= 50
  }

  public mutating func removeSubrange(_ bounds: Range<Int>) {
    if bounds.lowerBound == startIndex {
      let oldCount = garbageCount
      garbageCount += bounds.count
      if needRemoveGarbage {
        removeGarbage()
      } else {
        for index in oldCount..<garbageCount {
          _queue[index] = nil
        }
      }
    } else {
      _queue.removeSubrange(bounds)
    }
  }

  @inlinable
  public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, Element == C.Element, Index == R.Bound {
    _queue.replaceSubrange(fixedRange(subrange), with: newElements.map { $0 })
  }

  @usableFromInline
  func fixedRange<R>(_ bounds: R) -> Range<Int> where R : RangeExpression, Index == R.Bound {
    let range = bounds.relative(to: _queue)
    return (range.lowerBound+garbageCount)..<(range.upperBound+garbageCount)
  }

  @inlinable
  public mutating func reserveCapacity(_ n: Int) {
    _queue.reserveCapacity(n)
  }

  @inlinable
  public subscript(position: Int) -> Element {
    get {
      _queue[position]!
    }
    set {
      _queue[position] = newValue
    }
  }

  public var description: String {
    _queue[startIndex...].description
  }
}

