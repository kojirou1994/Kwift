
/*
 public var longestCommonPrefix2: Element.SubSequence? {
 guard let firstV = self.first, !contains(where: {$0.isEmpty}) else {
 return nil
 }

 for firstIndex in firstV.indices {
 if !allSatisfy({ (element) -> Bool in
 let index = element.index(element.startIndex, offsetBy: firstV.distance(from: firstV.startIndex, to: firstIndex))
 if element.indices.contains(index) {
 return element[index] == firstV[firstIndex]
 }
 return false
 }) {
 if firstIndex == firstV.startIndex {
 return nil
 }
 return firstV[..<firstIndex]
 }
 }
 return firstV[firstV.startIndex...]
 }
 */

func test() {
  
}
