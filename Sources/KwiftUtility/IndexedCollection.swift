/*
 https://swiftwithmajid.com/2019/12/04/must-have-swiftui-extensions/
 */

public struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {

    public typealias Index = Base.Index

    public typealias Element = (index: Index, element: Base.Element)

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
        (index: position, element: base[position])
    }
}

extension RandomAccessCollection {
    public var indexedCollection: IndexedCollection<Self> {
        .init(self)
    }
}
