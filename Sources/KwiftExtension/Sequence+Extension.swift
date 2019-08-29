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
