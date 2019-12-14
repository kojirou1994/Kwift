public struct CirculatingCollection<Base : RandomAccessCollection>: RandomAccessCollection {

    public typealias Element = Base.Element

    public private(set) var _base: Base

    public private(set) var startIndex: Index

    public var endIndex: Index {
        switch startIndex.position {
        case .normal:
            return .init(position: .overhead, index: startIndex.index)
        case .overhead:
            fatalError()
        }
    }

    public init(_ base: Base) {
        self._base = base
        startIndex = .init(position: .normal, index: base.startIndex)
    }

    public mutating func moveStartIndex(to offset: Int) {
        var tempIndex = self.index(startIndex, offsetBy: offset)
        tempIndex.position = .normal
        startIndex = tempIndex
    }

    public func index(before i: Index) -> Index {
        switch i.position {
        case .normal:
            if i.index == _base.startIndex {
                return .init(position: .normal, index: _base.index(before: _base.endIndex))
            } else {
                return .init(position: .normal, index: _base.index(before: i.index))
            }
        case .overhead:
            if i.index == _base.startIndex {
                return .init(position: .normal, index: _base.index(before: _base.endIndex))
            } else {
                return .init(position: .overhead, index: _base.index(before: i.index))
            }
        }
    }

    public func index(after i: Index) -> Index {
        switch i.position {
        case .normal:
            if i.index == _base.index(before: _base.endIndex) {
                return .init(position: .overhead, index: _base.startIndex)
            } else {
                return .init(position: .normal, index: _base.index(after: i.index))
            }
        case .overhead:
            if i.index == _base.index(before: _base.endIndex) {
                //                return .init(position: .normal, index: _base.index(before: _base.endIndex))
                fatalError()
            } else {
                return .init(position: .overhead, index: _base.index(after: i.index))
            }
        }
    }

    public subscript(position: Index) -> Element {
        _read {
            yield _base[position.index]
        }
    }

    public struct Index: Comparable, Equatable {
        enum OffsetIndexPosition {
            case normal
            case overhead
        }
        var position: OffsetIndexPosition
        let index: Base.Index

        public static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs.position, rhs.position) {
            case (.normal, .overhead): return true
            case (.overhead, .normal): return false
            default: return lhs.index < rhs.index
            }
        }
    }
}
