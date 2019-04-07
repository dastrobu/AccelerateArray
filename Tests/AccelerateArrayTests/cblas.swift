import XCTest
@testable import AccelerateArray

class CblasTests: XCTestCase {

    func testScalFloat() {
        var a: [Float] = []
        a.scal(1)
        XCTAssertEqual(a, [])

        a = [1, 2]
        a.scal(2)
        XCTAssertEqual(a, [2, 4])

        a = [1, 2]
        a.scal(2, offset: 1)
        XCTAssertEqual(a, [1, 4])
    }

    func testScalDouble() {
        var a: [Double] = []
        a.scal(1)
        XCTAssertEqual(a, [])

        a = [1, 2]
        a.scal(2)
        XCTAssertEqual(a, [2, 4])

        a = [1, 2]
        a.scal(2, offset: 1)
        XCTAssertEqual(a, [1, 4])
    }

    func testSetFloat() {
        var a: [Float] = []
        a.set(1)
        XCTAssertEqual(a, [])

        a = [1, 2]
        a.set(2)
        XCTAssertEqual(a, [2, 2])

        a = [1, 2]
        a.set(4, offset: 1)
        XCTAssertEqual(a, [1, 4])
    }

    func testSetDouble() {
        var a: [Double] = []
        a.set(1)
        XCTAssertEqual(a, [])

        a = [1, 2]
        a.set(2)
        XCTAssertEqual(a, [2, 2])

        a = [1, 2]
        a.set(4, offset: 1)
        XCTAssertEqual(a, [1, 4])
    }

    static var allTests: [(String, (cblasTests) -> () throws -> Void)] {
        return [
            ("testScalFloat", testScalFloat),
            ("testScalDouble", testScalDouble),
            ("testSetFloat", testSetFloat),
            ("testSetDouble", testSetDouble),
        ]
    }
}
