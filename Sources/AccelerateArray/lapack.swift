/// This wrapper calls the lapack functions from Accelerate.
/// Note that LAPACk expected columnd major storage (Fortran order).
/// Unlike in LAPACKE, there is no option to tell LAPACK that a matrix is stored column major (C order).

import Accelerate

public enum LapackError: Error {
    case getrf(_: Int32)
    case getri(_: Int32)
    case dgesv(_: Int32)
}

/// Array extension employing the LAPACK framework.
/// http://www.netlib.org/lapack/lug/
///
/// Float array extension
public extension Array where Element == Float {

}

/// Array extension employing the LAPACK framework.
/// http://www.netlib.org/lapack/lug/
///
/// Double array extension
public extension Array where Element == Double {

    /// DGETRF computes an LU factorization of a general M-by-N matrix A
    /// using partial pivoting with row interchanges.
    ///
    /// The factorization has the form
    ///    A = P * L * U
    /// where P is a permutation matrix, L is lower triangular with unit
    /// diagonal elements (lower trapezoidal if m > n), and U is upper
    /// triangular (upper trapezoidal if m < n).
    ///
    /// This is the right-looking Level 3 BLAS version of the algorithm.
    ///
    /// This array must be in column major storage.
    ///
    /// http://www.netlib.org/lapack/explore-html/dd/d9a/group__double_g_ecomputational_ga0019443faea08275ca60a734d0593e60.html#ga0019443faea08275ca60a734d0593e60
    ///
    /// - Parameters:
    ///     - m: number of rows
    ///     - n: number of columns
    ///
    /// - Returns: The pivot indices; for 1 <= i <= min(M,N), row i of the matrix was interchanged with row IPIV(i).
    mutating func getrf(m: Int, n: Int) throws -> [Int32] {
        var ipiv = [Int32](repeating: 0, count: Swift.min(m, n))
        try getrf(m: m, n: n, ipiv: &ipiv)
        return ipiv
    }

    /// DGETRF computes an LU factorization of a general M-by-N matrix A
    /// using partial pivoting with row interchanges.
    ///
    /// The factorization has the form
    ///    A = P * L * U
    /// where P is a permutation matrix, L is lower triangular with unit
    /// diagonal elements (lower trapezoidal if m > n), and U is upper
    /// triangular (upper trapezoidal if m < n).
    ///
    /// This is the right-looking Level 3 BLAS version of the algorithm.
    ///
    /// This array must be in column major storage.
    ///
    /// http://www.netlib.org/lapack/explore-html/dd/d9a/group__double_g_ecomputational_ga0019443faea08275ca60a734d0593e60.html#ga0019443faea08275ca60a734d0593e60
    ///
    /// - Parameters:
    ///     - m: number of rows
    ///     - n: number of columns
    ///     - ipiv: the pivot indices; for 1 <= i <= min(m,n), row i of the matrix was interchanged with row ipiv[i].
    mutating func getrf(m m_: Int, n n_: Int, ipiv: inout [Int32]) throws {
        var m = Int32(m_)
        assert(m >= 0, "\(m) >= 0")
        var n = Int32(n_)
        assert(n >= 0, "\(n) >= 0")
        // leading dimension is the number of rows in column major order
        var lda = Int32(m)
        assert(lda >= Swift.max(1, m), "\(lda) >= max(1, \(m)")
        assert(count == lda * n, "\(count) == (\(lda),\(n))")

        assert(ipiv.count >= Swift.min(m, n), "\(ipiv.count) > min(\(m), \(n)")

        var info: Int32 = 0
        dgetrf_(&m, &n, &self, &lda, &ipiv, &info)
        if info != 0 {
            throw LapackError.getrf(info)
        }
    }

    /// DGETRI computes the inverse of a matrix using the LU factorization
    /// computed by DGETRF.
    ///
    /// This method inverts U and then computes inv(A) by solving the system
    /// inv(A)*L = inv(U) for inv(A).
    ///
    /// http://www.netlib.org/lapack/explore-html/dd/d9a/group__double_g_ecomputational_ga56d9c860ce4ce42ded7f914fdb0683ff.html#ga56d9c860ce4ce42ded7f914fdb0683ff
    mutating func getri() throws {
        var n = Int32(Double(count).squareRoot())
        assert(count == n * n, "\(count) == \(n) * \(n)")
        var ipiv = try getrf(m: Int(n), n: Int(n))

        var lda = Int32(count / Int(n))
        assert(lda >= Swift.max(1, n), "\(lda) >= max(1, \(n)")

        var info: Int32 = 0

        // do optimal workspace query
        var lwork: Int32 = -1
        var work = [__CLPK_doublereal](repeating: 0.0, count: 1)
        dgetri_(&n, &self, &lda, &ipiv, &work, &lwork, &info)
        if info != 0 {
            throw LapackError.getri(info)
        }

        // retrieve optimal workspace
        lwork = Int32(work[0])
        work = [__CLPK_doublereal](repeating: 0.0, count: Int(lwork))

        // do the inversion
        dgetri_(&n, &self, &lda, &ipiv, &work, &lwork, &info)
        if info != 0 {
            throw LapackError.getri(info)
        }
    }

    /// DGESV computes the solution to a real system of linear equations
    ///    A * X = B,
    /// where A is an N-by-N matrix and X and B are N-by-NRHS matrices.
    ///
    /// The LU decomposition with partial pivoting and row interchanges is
    /// used to factor A as
    ///    A = P * L * U,
    /// where P is a permutation matrix, L is unit lower triangular, and U is
    /// upper triangular.  The factored form of A is then used to solve the
    /// system of equations A * X = B.
    ///
    /// This array must be in column major storage.
    ///
    /// http://www.netlib.org/lapack/explore-html/d7/d3b/group__double_g_esolve_ga5ee879032a8365897c3ba91e3dc8d512.html#ga5ee879032a8365897c3ba91e3dc8d512
    mutating func gesv(B: inout [Element]) throws {
        var ipiv: [Int32] = [repeating: 0, count: n]
        try gesv(ipiv: &ipiv, B: &B)
    }

    /// DGESV computes the solution to a real system of linear equations
    ///    A * X = B,
    /// where A is an N-by-N matrix and X and B are N-by-NRHS matrices.
    ///
    /// The LU decomposition with partial pivoting and row interchanges is
    /// used to factor A as
    ///    A = P * L * U,
    /// where P is a permutation matrix, L is unit lower triangular, and U is
    /// upper triangular.  The factored form of A is then used to solve the
    /// system of equations A * X = B.
    ///
    /// This array and B must be in column major storage.
    ///
    /// http://www.netlib.org/lapack/explore-html/d7/d3b/group__double_g_esolve_ga5ee879032a8365897c3ba91e3dc8d512.html#ga5ee879032a8365897c3ba91e3dc8d512
    mutating func gesv(ipiv: inout [Int32], B: inout [Element]) throws {
        var n = Int32(self.n)
        assert(count == n * n, "\(count) == \(n) * \(n)")
        assert(ipiv.count == n, "\(ipiv.count) == \(n)")

        var nrhs = Int32(B.count / Int(n))
        assert(nrhs >= 1, "\(nrhs) >= 1")
        assert(B.count == nrhs * n, "\(B.count) == \(nrhs) * \(n)")

        var lda = n
        assert(lda >= Swift.max(1, n), "\(lda) >= max(1, \(n)")

        var ldb = Int32(B.count / Int(nrhs))
        assert(ldb * nrhs == B.count, "\(ldb) * \(nrhs) == \(B.count)")
        assert(ldb >= Swift.max(1, n), "\(ldb) >= max(1, \(n))")

        var info: Int32 = 0

        dgesv_(&n, &nrhs, &self, &lda, &ipiv, &B, &ldb, &info)
        if info != 0 {
            throw LapackError.dgesv(info)
        }
    }
}
