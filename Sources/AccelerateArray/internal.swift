/// Some helpers for internal usage.
///
internal extension Array {
    /// dimension, if the array represents a square matrix
    @inlinable var n: Int {
        get {
            let n = Int(Double(count).squareRoot())
            assert(n * n == count, "\(n) * \(n) == \(count)")
            return n
        }
    }
}
