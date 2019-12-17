extension Sequence where Element: Hashable {
    public var duplicatedElements: Set<Element> {
        var result = Set<Element>()
        var set = Set<Element>()
        forEach { (e) in
            if set.contains(e) {
                result.insert(e)
            } else {
                set.insert(e)
            }
        }
        return result
    }
}

extension Sequence {
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try predicate(element) {
                count += 1
            }
        }
        return count
    }
}
