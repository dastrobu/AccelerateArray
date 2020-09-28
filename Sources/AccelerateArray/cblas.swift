import Accelerate

/// Array extension employing the BLAS framework.
/// https://developer.apple.com/documentation/accelerate/blas
///
/// Float array extension
public extension Array where Element == Float {
    /// Multiplies each element of a vector by a constant.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func scal(_ alpha: Element, offset: Int = 0) {
        scal(n: Int32(count - offset), alpha: alpha, offset: offset)
    }

    /// Multiplies each element of a vector by a constant.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func scal(n: Int32, alpha: Element, incX: Int32 = 1, offset: Int = 0) {
        assert(offset == 0 || (offset >= 0 && offset < count),
            "\(offset) == 0 || (\(offset) >= 0 && \(offset) < \(count))")
        assert(n >= 0 && n <= count - offset, "\(n) >= 0 && \(n) <= \(count) - \(offset)")
        assert(incX >= 1, "\(incX) >= 1")
        withUnsafeMutableBufferPointer {
            cblas_sscal(n, alpha, $0.baseAddress! + offset, incX)
        }
    }

    /// Modifies a vector in place, setting each element to a given value.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func set(_ alpha: Element, offset: Int = 0) {
        set(n: Int32(count - offset), alpha: alpha, offset: offset)
    }

    /// Modifies a vector in place, setting each element to a given value.
    /// https://developer.apple.com/documentation/accelerate/blas
    ///
    /// - Parameters:
    ///     - n: number of items
    ///     - alpha: scaling factor
    ///     - incX: stride within x
    ///     - offset: offset w.r.t to the start of the array from which to start the operation
    mutating func set(n: Int32, alpha: Element, incX: Int32 = 1, offset: Int = 0) {
        assert(offset == 0 || (offset >= 0 && offset < count),
            "\(offset) == 0 || (\(offset) >= 0 && \(offset) < \(count))")
        assert(n >= 0 && n / incX <= count - offset, "\(n) >= 0 && \(n) / \(incX) <= \(count) - \(offset)")
        assert(incX >= 1, "\(incX) >= 1")
        withUnsafeMutableBufferPointer {
            catlas_sset(n, alpha, $0.baseAddress! + offset, incX)
        }
    }

    /// Computes the sum of two vectors, scaling each one separately (single-precision).
    /// On return, the contents of vector Y are replaced with the result.
    /// https://developer.apple.com/documentation/accelerate/blas
    /// - Parameters:
    ///     - alpha: scaling factor x
    ///     - beta: scaling factor for y
    ///     - offsetX: offset w.r.t to the start of the array from which to start the operation in x
    ///     - offsetY: offset w.r.t to the start of the array from which to start the operation in y
    mutating func axpby(alpha: Element, beta: Element, y: inout [Element], offsetX: Int = 0, offsetY: Int = 0) {
        axpby(n: Int32(count - offsetX), alpha: alpha, beta: beta, y: &y, offsetX: offsetX, offsetY: offsetY)
    }

    /// Computes the sum of two vectors, scaling each one separately (single-precision).
    /// On return, the contents of vector Y are replaced with the result.
    /// https://developer.apple.com/documentation/accelerate/blas
    /// - Parameters:
    ///     - n: number of items
    ///     - alpha: scaling factor x
    ///     - incX: stride within x
    ///     - beta: scaling factor for y
    ///     - incY: stride within y
    ///     - offsetX: offset w.r.t to the start of the array from which to start the operation in x
    ///     - offsetY: offset w.r.t to the start of the array from which to start the operation in y
    mutating func axpby(n: Int32, alpha: Element, incX: Int32 = 1, beta: Element, y: inout [Element], incY: Int32 = 1, offsetX: Int = 0, offsetY: Int = 0) {
        assert(offsetX == 0 || (offsetX >= 0 && offsetX < count),
            "\(offsetX) == 0 || (\(offsetX) >= 0 && \(offsetX) < \(count))")
        assert(offsetY == 0 || (offsetY >= 0 && offsetY < y.count),
            "\(offsetY) == 0 || (\(offsetY) >= 0 && \(offsetY) < \(y.count))")
        assert(n >= 0 && n / incX <= count - offsetX, "\(n) >= 0 && \(n) / \(incX) <= \(count) - \(offsetX)")
        assert(n >= 0 && n / incY <= y.count - offsetY, "\(n) >= 0 && \(n) / \(incY) <= \(y.count) - \(offsetY)")
        assert(incX >= 1, "\(incX) >= 1")
        assert(incY >= 1, "\(incY) >= 1")
        withUnsafeMutableBufferPointer { X in
            y.withUnsafeMutableBufferPointer { Y in
                catlas_saxpby(n, alpha, X.baseAddress! + offsetX, incX, beta, Y.baseAddress! + offsetY, incY)
            }
        }
    }

}

/// Array extension employing the BLAS framework.
/// https://developer.apple.com/documentation/accelerate/blas
///
/// Double array extension
public extension Array where Element == Double {
    /// Multiplies each element of a vector by a constant.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func scal(_ alpha: Element, offset: Int = 0) {
        scal(n: Int32(count - offset), alpha: alpha, offset: offset)
    }

    /// Multiplies each element of a vector by a constant.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func scal(n: Int32, alpha: Element, incX: Int32 = 1, offset: Int = 0) {
        assert(offset == 0 || (offset >= 0 && offset < count),
            "\(offset) == 0 || (\(offset) >= 0 && \(offset) < \(count))")
        assert(n >= 0 && n <= count - offset, "\(n) >= 0 && \(n) <= \(count) - \(offset)")
        assert(incX >= 1, "\(incX) >= 1")
        withUnsafeMutableBufferPointer {
            cblas_dscal(n, alpha, $0.baseAddress! + offset, incX)
        }
    }

    /// Modifies a vector in place, setting each element to a given value.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func set(_ alpha: Element, offset: Int = 0) {
        set(n: Int32(count - offset), alpha: alpha, offset: offset)
    }

    /// Modifies a vector in place, setting each element to a given value.
    /// https://developer.apple.com/documentation/accelerate/blas
    ///
    /// - Parameters:
    ///     - n: number of items
    ///     - alpha: scaling factor
    ///     - incX: stride within x
    ///     - offset: offset w.r.t to the start of the array from which to start the operation
    mutating func set(n: Int32, alpha: Element, incX: Int32 = 1, offset: Int = 0) {
        assert(offset == 0 || (offset >= 0 && offset < count),
            "\(offset) == 0 || (\(offset) >= 0 && \(offset) < \(count))")
        assert(n >= 0 && n <= count - offset,
            "\(n) >= 0 && \(n) <= \(count) - \(offset)")
        assert(incX >= 1, "\(incX) >= 1")
        withUnsafeMutableBufferPointer {
            catlas_dset(n, alpha, $0.baseAddress! + offset, incX)
        }
    }

    /// Computes the sum of two vectors, scaling each one separately (single-precision).
    /// On return, the contents of vector Y are replaced with the result.
    /// https://developer.apple.com/documentation/accelerate/blas
    /// - Parameters:
    ///     - alpha: scaling factor x
    ///     - beta: scaling factor for y
    ///     - offsetX: offset w.r.t to the start of the array from which to start the operation in x
    ///     - offsetY: offset w.r.t to the start of the array from which to start the operation in y
    mutating func axpby(alpha: Element, beta: Element, y: inout [Element], offsetX: Int = 0, offsetY: Int = 0) {
        axpby(n: Int32(count - offsetX), alpha: alpha, beta: beta, y: &y, offsetX: offsetX, offsetY: offsetY)
    }

    /// Computes the sum of two vectors, scaling each one separately (single-precision).
    /// On return, the contents of vector Y are replaced with the result.
    /// https://developer.apple.com/documentation/accelerate/blas
    /// - Parameters:
    ///     - n: number of items
    ///     - alpha: scaling factor x
    ///     - incX: stride within x
    ///     - beta: scaling factor for y
    ///     - incY: stride within y
    ///     - offsetX: offset w.r.t to the start of the array from which to start the operation in x
    ///     - offsetY: offset w.r.t to the start of the array from which to start the operation in y
    mutating func axpby(n: Int32, alpha: Element, incX: Int32 = 1, beta: Element, y: inout [Element], incY: Int32 = 1, offsetX: Int = 0, offsetY: Int = 0) {
        assert(offsetX == 0 || (offsetX >= 0 && offsetX < count),
            "\(offsetX) == 0 || (\(offsetX) >= 0 && \(offsetX) < \(count))")
        assert(offsetY == 0 || (offsetY >= 0 && offsetY < y.count),
            "\(offsetY) == 0 || (\(offsetY) >= 0 && \(offsetY) < \(y.count))")
        assert(n >= 0 && n / incX <= count - offsetX, "\(n) >= 0 && \(n) / \(incX) <= \(count) - \(offsetX)")
        assert(n >= 0 && n / incY <= y.count - offsetY, "\(n) >= 0 && \(n) / \(incY) <= \(y.count) - \(offsetY)")
        assert(incX >= 1, "\(incX) >= 1")
        assert(incY >= 1, "\(incY) >= 1")
        withUnsafeMutableBufferPointer { X in
            y.withUnsafeMutableBufferPointer { Y in
                catlas_daxpby(n, alpha, X.baseAddress! + offsetX, incX, beta, Y.baseAddress! + offsetY, incY)
            }
        }
    }
}
