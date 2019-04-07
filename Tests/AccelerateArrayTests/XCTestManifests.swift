import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(cblasTests.allTests),
        testCase(lapackTests.allTests),
        testCase(vDSPTests.allTests),
    ]
}
#endif
