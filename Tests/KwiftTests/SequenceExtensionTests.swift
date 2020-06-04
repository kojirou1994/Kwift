import XCTest
@testable import KwiftExtension

class SequenceExtensionTests: XCTestCase {

  func testDuplicateAndUnique() {
    let duplicate: Set<Int> = [1,2,3,4,5]
    let sequence = CollectionOfOne(0) + duplicate.sorted() + duplicate.shuffled()

    XCTAssertEqual(sequence.duplicate(), duplicate)
    XCTAssertEqual(sequence.unique(), Array(0...5))
  }

  func testPredicateCount() {
    let range = 1...100

    XCTAssertEqual(range.count(where: {_ in true}), 100)
    XCTAssertEqual(range.count(where: {$0.isMultiple(of: 2)}), 50)

    for number in range {
      XCTAssertEqual(range.count(of: number), 1)
    }
  }

  func testMakeUniqueName() {
    let basename = "Name"
    var existedNames = [String]()
    for _ in 1...3 {
      existedNames.append(existedNames.makeUniqueName(basename: basename, startIndex: 1, keyPath: \.self))
    }

    for _ in 1...2 {
      existedNames.append(existedNames.makeUniqueName(basename: basename, startIndex: 1, closure: { $0 }))
    }

    for _ in 1...2 {
      existedNames.append(existedNames.makeUniqueName(basename: basename, startIndex: 1))
    }

    let expectedResult = CollectionOfOne(basename)
      + (1...6).map {"\(basename) \($0)"}

    XCTAssertEqual(existedNames, expectedResult)
  }

  func testSortKeyPath() {
    struct Wrapper {
      let value: Int
    }
    let data = (1...100).reversed()
    let wrappers = data.map(Wrapper.init(value:))
    XCTAssertEqual(data.sorted(), wrappers.sorted(by: \.value).map(\.value))
  }
}
