import XCTest

import KwiftUtilityTests
import SwiftEnhancementTests

var tests = [XCTestCaseEntry]()
tests += KwiftUtilityTests.__allTests()
tests += SwiftEnhancementTests.__allTests()

XCTMain(tests)
