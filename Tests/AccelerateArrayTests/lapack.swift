import XCTest
@testable import AccelerateArray

class LapackTests: XCTestCase {
    func testGetrfDouble() throws {
        // A in row major
        let A: [Double] = [
            1.0, 2.0,
            3.0, 4.0,
            5.0, 6.0,
            7.0, 8.0
        ]
        // convert A to col major
        var At = A.mtrans(m: 2, n: 4)
        let ipiv = try At.getrf(m: 4, n: 2)
        // convert solution to row major
        let X = At.mtrans(m: 4, n: 2)
        // L in row major
        let L: [Double] = [
            1.0, 0.0,
            X[2], 1.0,
            X[4], X[5],
            X[6], X[7],
        ]
        // U in row major
        let U: [Double] = [
            X[0], X[1],
            0.0, X[3],
        ]

        // note, the indices in ipiv are one base (fortran)
        // construct the permutation vector
        // see: https://math.stackexchange.com/a/3112224/91477
        var p = [0, 1, 2, 3]
        for i in 0..<ipiv.count {
            p.swapAt(i, Int(ipiv[i] - 1))
        }

        let n = 4
        var P: [Double] = Array(repeating: 0, count: n * n)
        for i in 0..<p.count {
            // i iterates columns of P (in row major)
            // p[i] indicates which element in the column must be set to one, to create the permutation matrix
            P[i + p[i] * n] = 1.0
        }

        let PLU = P.mmul(B: L.mmul(B: U, m: 4, n: 2, p: 2), m: 4, n: 2, p: 4)
        XCTAssertEqual(A, PLU, accuracy: 1e-15)
    }

    func testGetriDouble() throws {
        // inversion is independent of row/col major storage
        var A: [Double] = [
            1.0, 2.0,
            3.0, 4.0,
        ]
        try A.getri()

        let Ainv: [Double] = [
            -2.0, 1.0,
            1.5, -0.5,
        ]

        XCTAssertEqual(A, Ainv)
    }

    func testGesvDouble() throws {
        // A in row major
        let A: [Double] = [
            1.0, 2.0,
            3.0, 4.0,
        ]
        // convert A to col major
        var At = A.mtrans(m: 2, n: 2)
        let b: [Double] = [
            1.0, 1.0
        ]
        // B in row major
        let B: [Double] = [
            1.0, 2.0, 3.0,
            1.0, 2.0, 3.0,
        ]
        // B in col major
        var Bt = B.mtrans(m: 3, n: 2)
        // Ainv in row major
        let Ainv: [Double] = [
            -2.0, 1.0,
            1.5, -0.5,
        ]
        let x1 = Ainv.mmul(B: b, m: 2, n: 1, p: 2)
        // X1 is in row major
        let X1 = Ainv.mmul(B: B, m: 2, n: 3, p: 2)

        // solution is stored col major in Bt
        try At.gesv(B: &Bt)
        let X2 = Bt.mtrans(m: 2, n: 3)

        XCTAssertEqual(x1[0], X1[0], accuracy: 1e-15)
        XCTAssertEqual(x1[1], X1[3], accuracy: 1e-15)
        XCTAssertEqual(X1, X2, accuracy: 1e-15)
    }

    func testGtsvDouble() throws {
        // A in row major
        let A: [Double] = [
            1.0, 1.0, 0.0, 0.0,
            -1.0, 2.0, 2.0, 0.0,
            0.0, -2.0, 3.0, 3.0,
            0.0, 0.0, -3.0, 4.0,
        ]
        // convert A to col major
        var At = A.mtrans(m: 4, n: 4)

        // diagonals of A
        var d: [Double] = [1.0, 2.0, 3.0, 4.0, ]
        var du: [Double] = [1.0, 2.0, 3.0, ]
        var dl: [Double] = [-1.0, -2.0, -3.0, ]

        // B in row major
        let B: [Double] = [
            1.0, 2.0,
            1.0, 2.0,
            1.0, 2.0,
            1.0, 2.0,
        ]
        // B in col major
        var Bt = B.mtrans(m: 2, n: 4)
        // make a copy of Bt
        var Ct = Bt

        // solve with general solver
        // solution is stored col major in Ct
        try At.gesv(B: &Ct)
        let X1 = Ct.mtrans(m: 4, n: 2)

        // solution is stored col major in Bt
        try d.gtsv(nrhs: 2, dl: &dl, du: &du, B: &Bt)
        let X2 = Bt.mtrans(m: 4, n: 2)

        XCTAssertEqual(X1, X2, accuracy: 1e-15)
    }

    static var allTests: [(String, (LapackTests) -> () throws -> Void)] {
        return [
            ("testGetrfDouble", testGetrfDouble),
            ("testGetriDouble", testGetriDouble),
            ("testGesvDouble", testGesvDouble),
            ("testGtsvDouble", testGtsvDouble),
        ]
    }
}
