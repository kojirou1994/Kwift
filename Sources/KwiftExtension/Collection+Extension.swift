extension Collection where Element: Collection, Element.SubSequence: Equatable {
    
    public var samePrefix: Element.SubSequence? {
        guard let firstV = self.first else {
            return nil
        }
        let length = firstV.count
        for maxLength in 0..<length {
            let p = firstV.prefix(length-maxLength)
            if allSatisfy({$0.prefix(length-maxLength) == p}) {
                return p
            }
        }
        return nil
    }

    public var sameSuffix: Element.SubSequence? {
        guard let firstV = self.first else {
            return nil
        }
        let length = firstV.count
        for maxLength in 0..<length {
            let p = firstV.suffix(length-maxLength)
            if allSatisfy({$0.suffix(length-maxLength) == p}) {
                return p
            }
        }
        return nil
    }
    
}
