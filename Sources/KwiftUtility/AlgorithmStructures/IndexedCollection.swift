/*
 https://swiftwithmajid.com/2019/12/04/must-have-swiftui-extensions/
 */

public struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {

  public typealias Index = Base.Index

  public struct Element {
    public let index: Index
    public let element: Base.Element
  }

  public let base: Base

  public init(_ base: Base) {
    self.base = base
  }

  public var startIndex: Index { base.startIndex }

  public var endIndex: Index { base.endIndex }

  public func index(after i: Index) -> Index {
    base.index(after: i)
  }

  public func index(before i: Index) -> Index {
    base.index(before: i)
  }

  public func index(_ i: Index, offsetBy distance: Int) -> Index {
    base.index(i, offsetBy: distance)
  }

  public subscript(position: Index) -> Element {
    .init(index: position, element: base[position])
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6.0, *)
extension IndexedCollection.Element: Identifiable where Base.Element: Identifiable {
  public var id: some Hashable { element.id }
}

extension RandomAccessCollection {
  @inlinable
  public var indexedCollection: IndexedCollection<Self> {
    .init(self)
  }
}
