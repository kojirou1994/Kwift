import XCTest
@testable import KwiftExtension

class CollectionExtensionTests: XCTestCase {
  
  func testEmptyError() {
    let emptyCollection = EmptyCollection<Int>()
    let nonEmptyCollection = CollectionOfOne(0)

    XCTAssertThrowsError(try emptyCollection.notEmpty())
    XCTAssertNoThrow(try nonEmptyCollection.notEmpty())

  }

  func testFindAllIndexes() {
    let array = Array(0..<100)

    let evenIndexes = array.indexes(where: {$0 % 2 != 0})
    let oddIndexes = array.indexes(where: {$0 % 2 == 0})

    XCTAssertEqual(evenIndexes, Array(stride(from: 1, through: 99, by: 2)))
    XCTAssertEqual(oddIndexes, Array(stride(from: 0, through: 99, by: 2)))

    let allZero = repeatElement(0, count: 100)
    XCTAssertEqual(allZero.indexes(of: 0), Array(0..<100))
    XCTAssertTrue(allZero.indexes(of: 1).isEmpty)
  }

  let arrayPrefixAndSuffix = [UInt8](repeating: 0, count: 1_00)

  func testTwoArrayCommonPrefix() {
    let sample = arrayPrefixAndSuffix + repeatElement(1, count: 10)

    XCTAssertTrue(arrayPrefixAndSuffix.elementsEqual(arrayPrefixAndSuffix.commonPrefix(with: sample)))
    XCTAssertTrue(arrayPrefixAndSuffix.elementsEqual(sample.commonPrefix(with: arrayPrefixAndSuffix)))

    measure {
      _ = arrayPrefixAndSuffix.commonPrefix(with: sample)
    }
  }

  func testTwoStringCommonPrefix() {
    let sample = stringPrefixSuffix + repeatElement("0", count: 10)

    XCTAssertTrue(stringPrefixSuffix.elementsEqual(stringPrefixSuffix.commonPrefix(with: sample)))
    XCTAssertTrue(stringPrefixSuffix.elementsEqual(sample.commonPrefix(with: stringPrefixSuffix)))

    measure {
      _ = stringPrefixSuffix.commonPrefix(with: sample)
    }
  }

  func testTwoArrayCommonSuffix() {
    let sample = repeatElement(1, count: 10) + arrayPrefixAndSuffix

    XCTAssertTrue(arrayPrefixAndSuffix.elementsEqual(arrayPrefixAndSuffix.commonSuffix(with: sample)))
    XCTAssertTrue(arrayPrefixAndSuffix.elementsEqual(sample.commonSuffix(with: arrayPrefixAndSuffix)))

    measure {
      _ = arrayPrefixAndSuffix.commonPrefix(with: sample)
    }
  }

  func testTwoStringCommonSuffix() {
    let sample = repeatElement("0", count: 10) + stringPrefixSuffix

    XCTAssertTrue(stringPrefixSuffix.elementsEqual(stringPrefixSuffix.commonSuffix(with: sample)))
    XCTAssertTrue(stringPrefixSuffix.elementsEqual(sample.commonSuffix(with: stringPrefixSuffix)))

    measure {
      _ = stringPrefixSuffix.commonPrefix(with: sample)
    }
  }

  func testArrayLongestCommonPrefix() {
    let samples = (0...1_000).map { arrayPrefixAndSuffix + repeatElement(1, count: $0) }

    let longestCommonPrefix = samples.longestCommonPrefix
    XCTAssertNotNil(longestCommonPrefix)
    XCTAssertEqual(arrayPrefixAndSuffix, Array(longestCommonPrefix!))

    measure {
      _ = samples.longestCommonPrefix
    }
  }

  func testArrayLongestCommonSuffix() {
    let samples = (0...1_000).map { repeatElement(1, count: $0) + arrayPrefixAndSuffix }

    let longestCommonSuffix = samples.longestCommonSuffix
    XCTAssertNotNil(longestCommonSuffix)
    XCTAssertEqual(arrayPrefixAndSuffix, Array(longestCommonSuffix!))

    measure {
      _ = samples.longestCommonSuffix
    }
  }

  let stringPrefixSuffix = String(repeating: "A", count: 1_0)
  func testStringLongestCommonPrefixSuffix() {
    let samples = (1...1_000).map { "\(stringPrefixSuffix)\($0)" }

    let longestCommonPrefix = samples.longestCommonPrefix
    XCTAssertNotNil(longestCommonPrefix)
    XCTAssertEqual(stringPrefixSuffix, String(longestCommonPrefix!))

    measure {
      _ = samples.longestCommonPrefix
    }
  }

  func testStringLongestCommonSuffix() {

    let samples = (1...1_000).map { "\($0)\(stringPrefixSuffix)" }

    let longestCommonSuffix = samples.longestCommonSuffix
    XCTAssertNotNil(longestCommonSuffix)
    XCTAssertEqual(stringPrefixSuffix, String(longestCommonSuffix!))
    measure {
      _ = samples.longestCommonSuffix
    }
  }
}
