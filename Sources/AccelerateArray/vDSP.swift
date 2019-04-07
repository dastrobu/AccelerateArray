import Accelerate

/// Array extension employing the vDSP framework.
/// https://developer.apple.com/documentation/accelerate/vdsp
///
/// Double array extension
public extension Array where Element == Float {

    /// Build ramped vector
    /// https://developer.apple.com/documentation/accelerate/1450369-vdsp_vramp
    ///
    /// full efficiency is currently blocked by
    /// https://github.com/apple/swift-evolution/blob/master/proposals/0223-array-uninitialized-initializer.md
    init(start: Element = 0.0, stop: Element, step: Element = 1.0) {
        let n: Int = Int(abs(ceil((stop - start) / step)))
        // since there is no way of creating an uninitialized array (see SE-0223), the array must be zeroed out first
        self.init(start: start, step: step, n: n)
    }

    /// Build ramped vector
    /// https://developer.apple.com/documentation/accelerate/1450369-vdsp_vramp
    init(start: Element, step: Element, n: Int) {
        self.init(repeating: 0, count: n)
        var a = start
        var b = step
        vDSP_vramp(&a, &b, &self, 1, vDSP_Length(n))
    }

    /// Creates a transposed matrix C from a source matrix A.
    /// https://developer.apple.com/documentation/accelerate/1449988-vdsp_mtrans
    ///
    /// By default, assumes row major storage
    ///
    /// - Parameters:
    ///     - m: number of columns
    ///     - n: number of rows
    func mtrans(m: Int, n: Int) -> [Element] {
        assert(count == m * n)

        if isEmpty {
            return []
        }

        var C: [Element] = Array(repeating: 0, count: count)
        mtrans(C: &C, strideC: 1, m: m, n: n)
        return C
    }

    /// Creates a transposed matrix C from a source matrix A.
    /// https://developer.apple.com/documentation/accelerate/1449988-vdsp_mtrans
    ///
    /// By default, assumes row major storage
    ///
    /// - Parameters:
    ///     - m: number of columns
    ///     - n: number of rows
    func mtrans(strideA: Int = 1, C: inout [Element], strideC: Int, m: Int, n: Int) {
        vDSP_mtrans(self, strideA, &C, strideC, vDSP_Length(m), vDSP_Length(n))
    }

    /// Performs an out-of-place multiplication of two matrices.
    /// https://developer.apple.com/documentation/accelerate/1449984-vdsp_mmul
    ///
    /// By default, assumes row major storage
    ///
    /// - Parameters:
    ///     - m: number of rows
    ///     - n: number of columns in B
    ///     - p: number of columns and number of rows in B
    func mmul(B: [Element], strideB: Int = 1, m: Int, n: Int, p: Int) -> [Element] {
        assert(count == m * p, "\(count) == \(m) * \(p)")
        var C: [Element] = Array(repeating: 0, count: Int(m * n))
        mmul(B: B, strideB: strideB, C: &C, m: m, n: n, p: p)
        return C
    }

    /// Performs an out-of-place multiplication of two matrices.
    /// https://developer.apple.com/documentation/accelerate/1449984-vdsp_mmul
    ///
    /// By default, assumes row major storage
    ///
    /// - Parameters:
    ///     - m: number of rows
    ///     - n: number of columns in B
    ///     - p: number of columns and number of rows in B
    func mmul(strideA: Int = 1,
              B: [Element],
              strideB: Int = 1,
              C: inout [Element],
              strideC: Int = 1,
              m: Int,
              n: Int,
              p: Int) {
        vDSP_mmul(self, strideA, B, strideB, &C, strideC, vDSP_Length(m), vDSP_Length(n), vDSP_Length(p))
    }
}

/// Array extension employing the vDSP framework.
/// https://developer.apple.com/documentation/accelerate/vdsp
///
/// Double array extension
public extension Array where Element == Double {

    /// Build ramped vector
    /// https://developer.apple.com/documentation/accelerate/1449999-vdsp_vrampd
    ///
    /// full efficiency is currently blocked by
    /// https://github.com/apple/swift-evolution/blob/master/proposals/0223-array-uninitialized-initializer.md
    init(start: Element = 0.0, stop: Element, step: Element = 1.0) {
        let n: Int = Int(abs(ceil((stop - start) / step)))
        // since there is no way of creating an uninitialized array (see SE-0223), the array must be zeroed out first
        self.init(start: start, step: step, n: n)
    }

    /// Build ramped vector
    /// https://developer.apple.com/documentation/accelerate/1449999-vdsp_vrampd
    init(start: Element, step: Element, n: Int) {
        self.init(repeating: 0, count: n)
        var a = start
        var b = step
        vDSP_vrampD(&a, &b, &self, 1, vDSP_Length(n))
    }

    /// Creates a transposed matrix C from a source matrix A.
    /// https://developer.apple.com/documentation/accelerate/1450422-vdsp_mtransd
    ///
    /// By default, assumes row major storage
    ///
    /// - Parameters:
    ///     - m: number of columns
    ///     - n: number of rows
    func mtrans(m: Int, n: Int) -> [Element] {
        assert(count == m * n, "\(count) == \(m) * \(n)")

        if isEmpty {
            return []
        }

        var C: [Element] = Array(repeating: 0, count: count)
        mtrans(C: &C, strideC: 1, m: m, n: n)
        return C
    }

    /// Creates a transposed matrix C from a source matrix A.
    /// https://developer.apple.com/documentation/accelerate/1450422-vdsp_mtransd
    ///
    /// - Parameters:
    ///     - m: number of columns
    ///     - n: number of rows
    func mtrans(strideA: Int = 1, C: inout [Element], strideC: Int, m: Int, n: Int) {
        vDSP_mtransD(self, strideA, &C, strideC, vDSP_Length(m), vDSP_Length(n))
    }

    /// Performs an out-of-place multiplication of two matrices.
    /// https://developer.apple.com/documentation/accelerate/1450386-vdsp_mmuld
    ///
    /// By default, assumes row major storage
    ///
    /// - Parameters:
    ///     - m: number of rows
    ///     - n: number of columns in B
    ///     - p: number of columns and number of rows in B
    func mmul(B: [Element], strideB: Int = 1, m: Int, n: Int, p: Int) -> [Element] {
        assert(count == m * p, "\(count) == \(m) * \(p)")

        if isEmpty {
            return []
        }

        var C: [Element] = Array(repeating: 0, count: Int(m * n))
        mmul(B: B, strideB: strideB, C: &C, m: m, n: n, p: p)
        return C
    }

    /// Performs an out-of-place multiplication of two matrices.
    /// https://developer.apple.com/documentation/accelerate/1450386-vdsp_mmuld
    ///
    /// By default, assumes row major storage
    ///
    /// - Parameters:
    ///     - m: number of rows
    ///     - n: number of columns in B
    ///     - p: number of columns and number of rows in B
    func mmul(strideA: Int = 1,
              B: [Element],
              strideB: Int = 1,
              C: inout [Element],
              strideC: Int = 1,
              m: Int,
              n: Int,
              p: Int) {
        vDSP_mmulD(self, strideA, B, strideB, &C, strideC, vDSP_Length(m), vDSP_Length(n), vDSP_Length(p))
    }
}
