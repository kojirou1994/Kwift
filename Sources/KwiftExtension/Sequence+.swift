// MARK: unique elements and duplicate elements
extension Sequence where Element: Hashable {

  /// - Returns: All ununique elemnts in the sequence
  public func duplicate() -> Set<Element> {
    var duplicate = Set<Element>()
    var allElements = Set<Element>()
    forEach { element in
      if !allElements.insert(element).inserted {
        duplicate.insert(element)
      }
    }
    return duplicate
  }

  @inlinable
  public func unique() -> [Element] {
    var allElements = Set<Element>()
    return filter{ allElements.insert($0).inserted }
  }
}

extension Sequence {

    #if swift(<999.0)
    /*
     https://github.com/apple/swift-evolution/blob/master/proposals/0220-count-where.md
     */
    @inlinable
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try predicate(element) {
                count += 1
            }
        }
        return count
    }
    #endif

    @inlinable
    public func sorted<T>(by keyPath: KeyPath<Element, T>) -> [Element] where T: Comparable {
        sorted(by: {$0[keyPath: keyPath] < $1[keyPath: keyPath]})
    }

    public func makeUniqueName(basename: String, startIndex: Int = 1, closure: (Element) -> String) -> String {
        var temp = basename
        var index = startIndex
        while self.contains(where: { closure($0) == temp }) {
            temp = "\(basename) \(index)"
            index += 1
        }
        return temp
    }

    public func makeUniqueName(basename: String, startIndex: Int = 1, keyPath: KeyPath<Element, String>) -> String {
        var temp = basename
        var index = startIndex
        while self.contains(where: { $0[keyPath: keyPath] == temp }) {
            temp = "\(basename) \(index)"
            index += 1
        }
        return temp
    }

}

extension Sequence where Element: Equatable {

  #if swift(<999.0)
  /*
   https://github.com/apple/swift-evolution/blob/master/proposals/0220-count-where.md
   */
  @inlinable
  public func count(of element: Element) -> Int {
    count(where: {$0 == element})
  }
  #endif

}

extension Sequence where Element == String {
  @inlinable
  public func makeUniqueName(basename: String, startIndex: Int = 1) -> String {
    makeUniqueName(basename: basename, startIndex: startIndex, keyPath: \.self)
  }
}
