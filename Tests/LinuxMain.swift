import XCTest

import KwiftExtensionTests
import KwiftUtilityTests

var tests = [XCTestCaseEntry]()
tests += KwiftExtensionTests.__allTests()
tests += KwiftUtilityTests.__allTests()

XCTMain(tests)
