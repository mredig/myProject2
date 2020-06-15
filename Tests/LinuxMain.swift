#if os(Linux)

import XCTest
//@testable import AppTests

XCTMain([
    // AppTests
//    testCase(AppTests.allTests)
])
print("use `swift test --enable-test-discovery --sanitize=thread`, don't rely on old, listed Linux tests")

#endif
