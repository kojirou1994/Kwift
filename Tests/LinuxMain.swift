import XCTest

import ExecutableTests
import KwiftUtilityTests
import SwiftEnhancementTests

var tests = [XCTestCaseEntry]()
tests += ExecutableTests.__allTests()
tests += KwiftUtilityTests.__allTests()
tests += SwiftEnhancementTests.__allTests()

XCTMain(tests)
