# AccelerateArray

[![Swift Version](https://img.shields.io/badge/swift-5.5-blue.svg)](https://swift.org)
![Platform](https://img.shields.io/badge/platform-macOS-lightgray.svg)
![Build](https://github.com/dastrobu/AccelerateArray/actions/workflows/ci.yaml/badge.svg)
[![documentation](https://github.com/dastrobu/AccelerateArray/raw/master/docs/badge.svg?sanitize=true)](https://dastrobu.github.io/AccelerateArray/)

Swift Array Extensions for the Apple Accelerate Framework. 

The goal of this package is to provide slightly easier access to the [BLAS](http://www.netlib.org/blas/), 
[LAPACK](http://www.netlib.org/lapack/) and [vDSP](https://developer.apple.com/documentation/accelerate/vdsp) functions
of the [Accelerate](https://developer.apple.com/documentation/accelerate) framework, 
to apply these functions to Float and Double swift arrays. 

Out of scope of this package are more convenient wrappers to handle arrays as matrices, which 
would include storing strides, shapes and order (row/column major). This would require to add 
additional types, which can be easily built on top of this package. 


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [Cocoa Pods](#cocoa-pods)
  - [Dependencies](#dependencies)
- [Examples](#examples)
  - [BLAS (ATLAS)](#blas-atlas)
    - [Scale Vector (sscal, dscal)](#scale-vector-sscal-dscal)
    - [Set Vector to Constant (sset, dset)](#set-vector-to-constant-sset-dset)
  - [LAPACK](#lapack)
    - [LU Factorization](#lu-factorization)
    - [Inverse](#inverse)
- [Docs](#docs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
     
## Installation

### Swift Package Manager

```swift
let package = Package(
        dependencies: [
          .package(url: "https://github.com/dastrobu/AccelerateArray.git", from: "0.3.1"),
        ]
)
```
        
### Cocoa Pods

Make sure a valid deployment target is setup in the Podfile and add

    pod 'AccelerateArray', '~> 0'
    
### Dependencies

There are no dependencies on macOS apart from the Accelerate framework, which is installed by default.
Since Accelerate is also include din iOS and other Apple Platforms, this package should run on all Apple plattforms.

## Examples

### BLAS (ATLAS)

#### Scale Vector (sscal, dscal)

Vector can be scaled by
```swift
a = [1, 2, 3]
a.scal(2) // [2, 4, 6]
```
or by providing all parameters for example with a stride of two
```swift
a = [1, 2, 3]
a.scal(n: Int32(a.count), alpha: 2, incX: 2) // [2, 2, 6]
```

#### Set Vector to Constant (sset, dset)

Set all elements of a vector to a single constant.
```swift
a = [1, 2, 3]
a.set(9) // [9, 9, 9]
```
or by providing all parameters for example with a stride of two
```swift
a = [1, 2, 3]
a.set(n: Int32(a.count), alpha: 2, incX: 2) // [9, 2, 9]
```

### LAPACK

#### LU Factorization 

Compute LU factorization.

```swift
// A in row major
let A: [Float] = [
    1.0, 2.0,
    3.0, 4.0,
    5.0, 6.0,
    7.0, 8.0
]
// convert A to col major (for fortran)
var At = A.mtrans(m: 2, n: 4)
// compute factorization

let ipiv = try At.getrf(m: 4, n: 2)

// convert solution to row major
let X = At.mtrans(m: 4, n: 2)

// L in row major (pic lower triangular matrix)
let L: [Float] = [
    1.0, 0.0,
    X[2], 1.0,
    X[4], X[5],
    X[6], X[7],
]

// U in row major (pic upper triangular matrix)
let U: [Float] = [
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

// construct the full permuation matrix
let n = 4
var P: [Float] = Array(repeating: 0, count: n * n)
for i in 0..<p.count {
    // i iterates columns of P (in row major)
    // p[i] indicates which element in the column must be set to one, to create the permutation matrix
    P[i + p[i] * n] = 1.0
}

// now compute PLU (which should be equal to A within numerical accuracy)
let PLU = P.mmul(B: L.mmul(B: U, m: 4, n: 2, p: 2), m: 4, n: 2, p: 4)
// gives [
//   1.0      , 2.0,
//   3.0000002, 4.0,
//   5.0      , 6.0,
//   7.0      , 8.0
// ]
```

#### Inverse

Invert matrix by 
```swift
// inversion is independent of row/col major storage
var A: [Float] = [
    1.0, 2.0,
    3.0, 4.0,
]
try A.getri()
// gives [
//  -2.0, 1.0,
//  1.5, -0.5,
// ]
```

## Docs

Read the [docs](https://dastrobu.github.io/AccelerateArray/). 

