import XCTest

import ExecutableTests
import KwiftExtensionTests
import KwiftUtilityTests

var tests = [XCTestCaseEntry]()
tests += ExecutableTests.__allTests()
tests += KwiftExtensionTests.__allTests()
tests += KwiftUtilityTests.__allTests()

XCTMain(tests)
