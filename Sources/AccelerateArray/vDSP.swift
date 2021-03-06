import Accelerate

/// Array extension employing the vDSP framework.
/// https://developer.apple.com/documentation/accelerate/vdsp
///
/// Double array extension
public extension Array where Element == Float {

    /// Build ramped vector
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// full efficiency is currently blocked by
    /// https://github.com/apple/swift-evolution/blob/master/proposals/0223-array-uninitialized-initializer.md
    init(start: Element = 0.0, stop: Element, step: Element = 1.0) {
        let n: Int = Int(abs(ceil((stop - start) / step)))
        // since there is no way of creating an uninitialized array (see SE-0223), the array must be zeroed out first
        self.init(start: start, step: step, n: n)
    }

    /// Build ramped vector
    /// https://developer.apple.com/documentation/accelerate/vdsp
    init(start: Element = 0.0, step: Element = 1.0, n: Int) {
        self.init(repeating: 0, count: n)
        var a = start
        var b = step
        vDSP_vramp(&a, &b, &self, 1, vDSP_Length(n))
    }

    /// Creates a transposed matrix C from a source matrix A.
    /// https://developer.apple.com/documentation/accelerate/vdsp
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
    /// https://developer.apple.com/documentation/accelerate/vdsp
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
    /// https://developer.apple.com/documentation/accelerate/vdsp
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
    /// https://developer.apple.com/documentation/accelerate/vdsp
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

    /// Vector polynomial evaluation.
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// - Parameters:
    ///     - strideA: stride for a
    ///     - b: variable values
    ///     - strideB: stride for b
    ///     - c: output vector
    ///     - strideC: stride for c
    func vpoly(_ b: [Element]) -> [Element] {
        return vpoly(b: b)
    }

    /// Vector polynomial evaluation.
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// - Parameters:
    ///     - strideA: stride for a
    ///     - b: variable values
    ///     - strideB: stride for b
    ///     - c: output vector
    ///     - strideC: stride for c
    func vpoly(strideA: Int = 1, b: [Element], strideB: Int = 1) -> [Element] {
        assert(b.count % strideB == 0, "\(b.count) % \(strideB) == 0")
        var c: [Element] = Array(repeating: 0, count: b.count / strideB)
        vpoly(strideA: strideA, b: b, strideB: strideB, c: &c)
        return c
    }

    /// Vector polynomial evaluation.
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// - Parameters:
    ///     - strideA: stride for a
    ///     - b: variable values
    ///     - strideB: stride for b
    ///     - c: output vector
    ///     - strideC: stride for c
    func vpoly(strideA: Int = 1, b: [Element], strideB: Int = 1, c: inout [Element], strideC: Int = 1) {
        assert(b.count % strideB == 0, "\(b.count) % \(strideB) == 0")
        assert(c.count % strideC == 0, "\(c.count) % \(strideC) == 0")
        assert(b.count / strideB == c.count / strideC, "\(b.count) / \(strideB) == \(c.count) / \(strideC)")
        if isEmpty {
            return
        }
        assert(count % strideA == 0, "\(count) % \(strideA) == 0")
        let p = vDSP_Length(count / strideA - 1)
        let n = vDSP_Length(b.count / strideB)
        vDSP_vpoly(self, strideA, b, strideB, &c, strideC, n, p)
    }
}

/// Array extension employing the vDSP framework.
/// https://developer.apple.com/documentation/accelerate/vdsp
///
/// Double array extension
public extension Array where Element == Double {

    /// Build ramped vector
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// full efficiency is currently blocked by
    /// https://github.com/apple/swift-evolution/blob/master/proposals/0223-array-uninitialized-initializer.md
    init(start: Element = 0.0, stop: Element, step: Element = 1.0) {
        let n: Int = Int(abs(ceil((stop - start) / step)))
        // since there is no way of creating an uninitialized array (see SE-0223), the array must be zeroed out first
        self.init(start: start, step: step, n: n)
    }

    /// Build ramped vector
    /// https://developer.apple.com/documentation/accelerate/vdsp
    init(start: Element = 0.0, step: Element = 1.0, n: Int) {
        self.init(repeating: 0, count: n)
        var a = start
        var b = step
        vDSP_vrampD(&a, &b, &self, 1, vDSP_Length(n))
    }

    /// Creates a transposed matrix C from a source matrix A.
    /// https://developer.apple.com/documentation/accelerate/vdsp
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
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// - Parameters:
    ///     - m: number of columns
    ///     - n: number of rows
    func mtrans(strideA: Int = 1, C: inout [Element], strideC: Int, m: Int, n: Int) {
        vDSP_mtransD(self, strideA, &C, strideC, vDSP_Length(m), vDSP_Length(n))
    }

    /// Performs an out-of-place multiplication of two matrices.
    /// https://developer.apple.com/documentation/accelerate/vdsp
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
    /// https://developer.apple.com/documentation/accelerate/vdsp
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

    /// Vector polynomial evaluation.
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// - Parameters:
    ///     - strideA: stride for a
    ///     - b: variable values
    ///     - strideB: stride for b
    ///     - c: output vector
    ///     - strideC: stride for c
    func vpoly(_ b: [Element]) -> [Element] {
        return vpoly(b: b)
    }

    /// Vector polynomial evaluation.
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// - Parameters:
    ///     - strideA: stride for a
    ///     - b: variable values
    ///     - strideB: stride for b
    ///     - c: output vector
    ///     - strideC: stride for c
    func vpoly(strideA: Int = 1, b: [Element], strideB: Int = 1) -> [Element] {
        assert(b.count % strideB == 0, "\(b.count) % \(strideB) == 0")
        var c: [Element] = Array(repeating: 0, count: b.count / strideB)
        vpoly(strideA: strideA, b: b, strideB: strideB, c: &c)
        return c
    }

    /// Vector polynomial evaluation.
    /// https://developer.apple.com/documentation/accelerate/vdsp
    ///
    /// - Parameters:
    ///     - strideA: stride for a
    ///     - b: variable values
    ///     - strideB: stride for b
    ///     - c: output vector
    ///     - strideC: stride for c
    func vpoly(strideA: Int = 1, b: [Element], strideB: Int = 1, c: inout [Element], strideC: Int = 1) {
        assert(b.count % strideB == 0, "\(b.count) % \(strideB) == 0")
        assert(c.count % strideC == 0, "\(c.count) % \(strideC) == 0")
        assert(b.count / strideB == c.count / strideC, "\(b.count) / \(strideB) == \(c.count) / \(strideC)")
        if isEmpty {
            return
        }
        assert(count % strideA == 0, "\(count) % \(strideA) == 0")
        let p = vDSP_Length(count / strideA - 1)
        let n = vDSP_Length(b.count / strideB)
        vDSP_vpolyD(self, strideA, b, strideB, &c, strideC, n, p)
    }
}
