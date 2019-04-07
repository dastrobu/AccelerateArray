# AccelerateArray
[![Swift Version](https://img.shields.io/badge/swift-5.0-blue.svg)](https://swift.org) 
![Platform](https://img.shields.io/badge/platform-osx--64-lightgray.svg)
[![Build Travis-CI Status](https://travis-ci.org/dastrobu/AccelerateArray.svg?branch=master)](https://travis-ci.org/dastrobu/AccelerateArray) 

Swift Array Extensions for the Apple Accelerate Framework. 

The goal of this package is to provide a slightly easier access to the BLAS, LAPACK and vDSP functions
of the [Accelerate](https://developer.apple.com/documentation/accelerate) framework, 
to apply these functions to Float and Double swift arrays. 

Out of scope of this package are more convenient wrappers to handle arrays as matrices, which 
would include storing strides, shapes and order (row/column major). This would require to add 
additional types, which can be easily built on top of this package. 

## Table of Contents

  * [Installation](#installation)
     * [Swift Package Manager](#swift-package-manager)
     * [Dependencies](#dependencies)
     
## Installation

### Swift Package Manager
    dependencies: [
            .package(url: "https://github.com/dastrobu/AccelerateArray.git", from: "0.0.0"),
        ],
        
### Dependencies
§
There are no dependencies on macOS apart from the Accelerate framework, which is installed by default. 
