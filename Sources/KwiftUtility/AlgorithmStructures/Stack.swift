public struct Stack<Element> {
  @usableFromInline internal var stack: ContiguousArray<Element> = .init()

  @inlinable public init(stackCapacity: Int) { stack.reserveCapacity(stackCapacity) }

  @inlinable public init() {}

  @inlinable public var isEmpty: Bool { stack.isEmpty }

  @inlinable public var count: Int { stack.count }

  @inlinable public var top: Element? { stack.last }

  @inlinable public mutating func push(_ element: Element) { stack.append(element) }

  @inlinable public mutating func push<S>(contentsOf newElements: S)
  where S: Sequence, Element == S.Element { stack.append(contentsOf: newElements) }

  @inlinable public mutating func pop() -> Element? { stack.popLast() }
}
