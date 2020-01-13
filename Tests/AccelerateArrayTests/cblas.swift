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

        a = [1, 2, 3]
        a.scal(n: Int32(a.count), alpha: 2, incX: 2)
        XCTAssertEqual(a, [2, 2, 6])
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

        a = [1, 2, 3]
        a.scal(n: Int32(a.count), alpha: 2, incX: 2)
        XCTAssertEqual(a, [2, 2, 6])
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

    func testAxpbyFloat() {
        var a: [Float] = [1, 2]
        var b: [Float] = [3, 4]
        a.axpby(alpha: 2, beta: 3, y: &b)
        XCTAssertEqual(a, [1, 2])
        XCTAssertEqual(b, [11, 16])

        b = [3, 4]
        a.axpby(n: 1, alpha: 2, beta: 3, y: &b)
        XCTAssertEqual(a, [1, 2])
        XCTAssertEqual(b, [11, 4])

        b = [3, 1, 4]
        a.axpby(n: 2, alpha: 2, beta: 3, y: &b, incY: 2)
        XCTAssertEqual(a, [1, 2])
        XCTAssertEqual(b, [11, 1, 16])
    }

    func testAxpbyDouble() {
        var a: [Double] = [1, 2]
        var b: [Double] = [3, 4]
        a.axpby(alpha: 2, beta: 3, y: &b)
        XCTAssertEqual(a, [1, 2])
        XCTAssertEqual(b, [11, 16])

        b = [3, 4]
        a.axpby(n: 1, alpha: 2, beta: 3, y: &b)
        XCTAssertEqual(a, [1, 2])
        XCTAssertEqual(b, [11, 4])

        b = [3, 1, 4]
        a.axpby(n: 2, alpha: 2, beta: 3, y: &b, incY: 2)
        XCTAssertEqual(a, [1, 2])
        XCTAssertEqual(b, [11, 1, 16])
    }

    static var allTests: [(String, (CblasTests) -> () throws -> Void)] {
        return [
            ("testScalFloat", testScalFloat),
            ("testScalDouble", testScalDouble),
            ("testSetFloat", testSetFloat),
            ("testSetDouble", testSetDouble),
            ("testAxpbyFloat", testAxpbyFloat),
            ("testAxpbyDouble", testAxpbyDouble),
        ]
    }
}
