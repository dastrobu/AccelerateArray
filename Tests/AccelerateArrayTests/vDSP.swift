import XCTest
@testable import AccelerateArray

class VDSPTests: XCTestCase {

    func testVrampFloat() {
        XCTAssertEqual([Float].init(stop: 2.0), [0.0, 1.0])
        XCTAssertEqual([Float].init(start: 0.0, stop: 1.0, step: 1.0), [0.0])
        XCTAssertEqual([Float].init(start: 0.0, stop: 2.0, step: 1.1), [0.0, 1.1])
        XCTAssertEqual([Float].init(start: -1.0, stop: 2.0, step: 1.0), [-1.0, 0.0, 1.0])
        XCTAssertEqual([Float].init(start: -1.0, stop: -3.0, step: -1.0), [-1.0, -2.0])

        XCTAssertEqual([Float].init(n: 2), [0.0, 1.0])
        XCTAssertEqual([Float].init(start: 1.0, n: 2), [1.0, 2.0])
        XCTAssertEqual([Float].init(start: 1.0, step: 2.0, n: 2), [1.0, 3.0])
    }

    func testVrampDouble() {
        XCTAssertEqual([Double].init(stop: 2.0), [0.0, 1.0])
        XCTAssertEqual([Double].init(start: 0.0, stop: 1.0, step: 1.0), [0.0])
        XCTAssertEqual([Double].init(start: 0.0, stop: 2.0, step: 1.1), [0.0, 1.1])
        XCTAssertEqual([Double].init(start: -1.0, stop: 2.0, step: 1.0), [-1.0, 0.0, 1.0])
        XCTAssertEqual([Double].init(start: -1.0, stop: -3.0, step: -1.0), [-1.0, -2.0])

        XCTAssertEqual([Double].init(n: 2), [0.0, 1.0])
        XCTAssertEqual([Double].init(start: 1.0, n: 2), [1.0, 2.0])
        XCTAssertEqual([Double].init(start: 1.0, step: 2.0, n: 2), [1.0, 3.0])
    }

    func testMtransFloatWhenEmpty() {
        let A: [Float] = []
        XCTAssertEqual(A.mtrans(m: 0, n: 0), [])
    }

    func testMtransFloat() {
        let A: [Float] = [
            1.0, 2.0, 3.0,
            4.0, 5.0, 6.0
        ]
        let At: [Float] = [
            1.0, 4.0,
            2.0, 5.0,
            3.0, 6.0
        ]
        XCTAssertEqual(A.mtrans(m: 3, n: 2), At)
    }

    func testMtransDoubleWhenEmpty() {
        let A: [Double] = []
        XCTAssertEqual(A.mtrans(m: 0, n: 0), [])
    }

    func testMtransDouble() {
        let A: [Double] = [
            1.0, 2.0, 3.0,
            4.0, 5.0, 6.0
        ]
        let At: [Double] = [
            1.0, 4.0,
            2.0, 5.0,
            3.0, 6.0
        ]
        XCTAssertEqual(A.mtrans(m: 3, n: 2), At)
    }

    func testMmulFloatWhenEmpty() {
        let A: [Float] = []
        XCTAssertEqual(A.mmul(B: [], m: 0, n: 0, p: 0), [])
    }

    func testMmulFloat() {
        // row major storage
        let A: [Float] = [
            3.0, 2.0,
            4.0, 5.0,
            6.0, 7.0,
        ]
        let B: [Float] = [
            10.0, 20.0, 30.0,
            30.0, 40.0, 50.0
        ]
        let AB: [Float] = [
            90.0, 140.0, 190.0,
            190.0, 280.0, 370.0,
            270.0, 400.0, 530.0,
        ]
        XCTAssertEqual(A.mmul(B: B, m: 3, n: 3, p: 2), AB)
    }

    func testMmulDoubleWhenEmpty() {
        let A: [Double] = []
        XCTAssertEqual(A.mmul(B: [], m: 0, n: 0, p: 0), [])
    }

    func testMmulDouble() {
        // row major storage
        let A: [Double] = [
            3.0, 2.0,
            4.0, 5.0,
            6.0, 7.0,
        ]
        let B: [Double] = [
            10.0, 20.0, 30.0,
            30.0, 40.0, 50.0
        ]
        let AB: [Double] = [
            90.0, 140.0, 190.0,
            190.0, 280.0, 370.0,
            270.0, 400.0, 530.0,
        ]
        XCTAssertEqual(A.mmul(B: B, m: 3, n: 3, p: 2), AB)
    }

    func testVpolyShouldReturnEmptyArrayWhenCoefficientsEmptyFloat() {
        let a: [Float] = []
        let b: [Float] = []
        let c: [Float] = a.vpoly(b)
        XCTAssertEqual(c, [])
    }

    func testVpolyFloat() {
        let a: [Float] = [1, 2, 3]
        let b: [Float] = [0, 1, 2, 3, 4]
        XCTAssertEqual(a.vpoly(b), [3, 6, 11, 18, 27])
    }

    func testVpolyShouldRespectStrideAFloat() {
        let a: [Float] = [1, 0, 3, 0]
        let b: [Float] = [0, 1, 2, 3, 4]
        XCTAssertEqual(a.vpoly(strideA: 2, b: b), [3, 4, 5, 6, 7])
    }

    func testVpolyShouldRespectStrideBFloat() {
        let a: [Float] = [1, 3]
        let b: [Float] = [0, 1, 2, 3]
        XCTAssertEqual(a.vpoly(b: b, strideB: 2), [3, 5])
    }

    func testVpolyShouldRespectStrideCFloat() {
        let a: [Float] = [1, 3]
        let b: [Float] = [0, 2]
        var c: [Float] = [0, 0, 0, 0]
        a.vpoly(b: b, c: &c, strideC: 2)
        XCTAssertEqual(c, [3, 0, 5, 0])
    }

    func testVpolyShouldReturnEmptyArrayWhenCoefficientsEmptyDouble() {
        let a: [Double] = []
        let b: [Double] = []
        let c: [Double] = a.vpoly(b)
        XCTAssertEqual(c, [])
    }

    func testVpolyDouble() {
        let a: [Double] = [1, 2, 3]
        let b: [Double] = [0, 1, 2, 3, 4]
        XCTAssertEqual(a.vpoly(b), [3, 6, 11, 18, 27])
    }

    func testVpolyShouldRespectStrideADouble() {
        let a: [Double] = [1, 0, 3, 0]
        let b: [Double] = [0, 1, 2, 3, 4]
        XCTAssertEqual(a.vpoly(strideA: 2, b: b), [3, 4, 5, 6, 7])
    }

    func testVpolyShouldRespectStrideBDouble() {
        let a: [Double] = [1, 3]
        let b: [Double] = [0, 1, 2, 3]
        XCTAssertEqual(a.vpoly(b: b, strideB: 2), [3, 5])
    }

    func testVpolyShouldRespectStrideCDouble() {
        let a: [Double] = [1, 3]
        let b: [Double] = [0, 2]
        var c: [Double] = [0, 0, 0, 0]
        a.vpoly(b: b, c: &c, strideC: 2)
        XCTAssertEqual(c, [3, 0, 5, 0])
    }

    static var allTests: [(String, (VDSPTests) -> () throws -> Void)] {
        return [
            ("testVrampFloat", testVrampFloat),
            ("testVrampDouble", testVrampDouble),
            ("testMtransFloatWhenEmpty", testMtransFloatWhenEmpty),
            ("testMtransFloat", testMtransFloat),
            ("testMtransDoubleWhenEmpty", testMtransDoubleWhenEmpty),
            ("testMtransDouble", testMtransDouble),
            ("testMmulFloatWhenEmpty", testMmulFloatWhenEmpty),
            ("testMmulFloat", testMmulFloat),
            ("testMmulDoubleWhenEmpty", testMmulDoubleWhenEmpty),
            ("testMmulDouble", testMmulDouble),
            ("testVpolyShouldReturnEmptyArrayWhenCoefficientsEmptyDouble", testVpolyShouldReturnEmptyArrayWhenCoefficientsEmptyDouble),
            ("testVpolyDouble", testVpolyDouble),
            ("testVpolyShouldRespectStrideADouble", testVpolyShouldRespectStrideADouble),
            ("testVpolyShouldRespectStrideBDouble", testVpolyShouldRespectStrideBDouble),
            ("testVpolyShouldRespectStrideCDouble", testVpolyShouldRespectStrideCDouble),
            ("testVpolyShouldReturnEmptyArrayWhenCoefficientsEmptyFloat", testVpolyShouldReturnEmptyArrayWhenCoefficientsEmptyFloat),
            ("testVpolyFloat", testVpolyFloat),
            ("testVpolyShouldRespectStrideAFloat", testVpolyShouldRespectStrideAFloat),
            ("testVpolyShouldRespectStrideBFloat", testVpolyShouldRespectStrideBFloat),
            ("testVpolyShouldRespectStrideCFloat", testVpolyShouldRespectStrideCFloat),
        ]
    }
}
