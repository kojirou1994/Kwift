import XCTest
@testable import KwiftExtension

class CollectionExtensionTests: XCTestCase {

  func testEquatableCollectionOfOne() {
    XCTAssertEqual(CollectionOfOne(1), CollectionOfOne(1))
    XCTAssertNotEqual(CollectionOfOne(1), CollectionOfOne(0))
  }

  func testCollectionEmptyError() {
    let emptyCollection = EmptyCollection<Int>()

    // custom message
    let errorMessage = "Error message"
    XCTAssertThrowsError(try emptyCollection.notEmpty(errorMessage)) { error in
      XCTAssertTrue(error is ErrorInCode)
    }
    // no message
    XCTAssertThrowsError(try emptyCollection.notEmpty()) { error in
      XCTAssertTrue(error is ErrorInCode)
    }
    // custom error
    struct CustomError: Error {}

    XCTAssertThrowsError(try emptyCollection.notEmpty(CustomError())) { error in
      XCTAssertTrue(error is CustomError)
    }

    let nonEmptyCollection = CollectionOfOne(0)

    XCTAssertNoThrow(try nonEmptyCollection.notEmpty())

    XCTAssertEqual(nonEmptyCollection, try! nonEmptyCollection.notEmpty())
    XCTAssertEqual(nonEmptyCollection, try! nonEmptyCollection.notEmpty(CustomError()))
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

  func testEmptyCommonPrefixSuffix() {
    let emptyCollection = EmptyCollection<Int>()
    let nonEmptyCollection = CollectionOfOne(0)

    // prefix
    XCTAssertTrue(emptyCollection.commonPrefix(with: nonEmptyCollection).isEmpty)

    // suffix
    XCTAssertTrue(emptyCollection.commonSuffix(with: nonEmptyCollection).isEmpty)
    XCTAssertTrue(emptyCollection.commonSuffix(with: emptyCollection).isEmpty)
    XCTAssertTrue(nonEmptyCollection.commonSuffix(with: emptyCollection).isEmpty)
  }

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

  func testUInt8ArrayCommonPrefix() {
    let samples = (0...1_000).map { arrayPrefixAndSuffix + repeatElement(1, count: $0) }

    let longestCommonPrefix = samples.commonPrefix
    XCTAssertNotNil(longestCommonPrefix)
    XCTAssertEqual(arrayPrefixAndSuffix, Array(longestCommonPrefix!))

    measure {
      _ = samples.commonPrefix
    }
  }

  func testEmptyCollectionCommonPrefixAndSuffix() {
    XCTAssertNil(EmptyCollection<String>().commonPrefix)
    XCTAssertNil(EmptyCollection<String>().commonSuffix)
  }

  func testOneElementCollectionCommonPrefixAndSuffix() {
    XCTAssertNil(CollectionOfOne("A").commonPrefix)
    XCTAssertNil(CollectionOfOne("A").commonSuffix)
  }

  func testEmptyCommonPrefixAndSuffixCollection() {
    XCTAssertNil(["A", "B"].commonPrefix)
    XCTAssertNil(["A", "B"].commonSuffix)
  }

  func testUInt8ArrayCommonSuffix() {
    let samples = (0...1_000).map { repeatElement(1, count: $0) + arrayPrefixAndSuffix }

    let longestCommonSuffix = samples.commonSuffix
    XCTAssertNotNil(longestCommonSuffix)
    XCTAssertEqual(arrayPrefixAndSuffix, Array(longestCommonSuffix!))

    measure {
      _ = samples.commonSuffix
    }
  }

  let stringPrefixSuffix = String(repeating: "A", count: 1_0)

  func testStringArrayCommonPrefix() {
    let samples = (1...1_000).map { "\(stringPrefixSuffix)\($0)" }

    let longestCommonPrefix = samples.commonPrefix
    XCTAssertNotNil(longestCommonPrefix)
    XCTAssertEqual(stringPrefixSuffix, String(longestCommonPrefix!))

    measure {
      _ = samples.commonPrefix
    }
  }

  func testStringArrayCommonSuffix() {

    let samples = (1...1_000).map { "\($0)\(stringPrefixSuffix)" }

    let longestCommonSuffix = samples.commonSuffix
    XCTAssertNotNil(longestCommonSuffix)
    XCTAssertEqual(stringPrefixSuffix, String(longestCommonSuffix!))
    measure {
      _ = samples.commonSuffix
    }
  }

  func testMiscCodes() {
    // UTF8 String Wrapper
    let str = "ABCD"
    XCTAssertEqual(str.utf8.utf8String, String(decoding: str.utf8, as: UTF8.self))
  }
}
