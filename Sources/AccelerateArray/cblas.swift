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
        cblas_sscal(n, alpha, &self + offset, incX)
    }

    /// Modifies a vector in place, setting each element to a given value.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func set(_ alpha: Element, offset: Int = 0) {
        set(n: Int32(count - offset), alpha: alpha, offset: offset)
    }

    /// Modifies a vector in place, setting each element to a given value.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func set(n: Int32, alpha: Element, incX: Int32 = 1, offset: Int = 0) {
        assert(offset == 0 || (offset >= 0 && offset < count),
            "\(offset) == 0 || (\(offset) >= 0 && \(offset) < \(count))")
        assert(n >= 0 && n <= count - offset, "\(n) >= 0 && \(n) <= \(count) - \(offset)")
        assert(incX >= 1, "\(incX) >= 1")
        catlas_sset(n, alpha, &self + offset, incX)
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
        cblas_dscal(n, alpha, &self + offset, incX)
    }

    /// Modifies a vector in place, setting each element to a given value.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func set(_ alpha: Element, offset: Int = 0) {
        set(n: Int32(count - offset), alpha: alpha, offset: offset)
    }

    /// Modifies a vector in place, setting each element to a given value.
    /// https://developer.apple.com/documentation/accelerate/blas
    mutating func set(n: Int32, alpha: Element, incX: Int32 = 1, offset: Int = 0) {
        assert(offset == 0 || (offset >= 0 && offset < count),
            "\(offset) == 0 || (\(offset) >= 0 && \(offset) < \(count))")
        assert(n >= 0 && n <= count - offset,
            "\(n) >= 0 && \(n) <= \(count) - \(offset)")
        assert(incX >= 1, "\(incX) >= 1")
        catlas_dset(n, alpha, &self + offset, incX)
    }
}
