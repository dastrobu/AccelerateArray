# AccelerateArray

[![Swift Version](https://img.shields.io/badge/swift-5.1-blue.svg)](https://swift.org) 
![Platform](https://img.shields.io/badge/platform-osx--64-lightgray.svg)
[![Build Travis-CI Status](https://travis-ci.org/dastrobu/AccelerateArray.svg?branch=master)](https://travis-ci.org/dastrobu/AccelerateArray) 
[![documentation](https://github.com/dastrobu/AccelerateArray/raw/master/docs/badge.svg?sanitize=true)](https://dastrobu.github.io/AccelerateArray/)

Swift Array Extensions for the Apple Accelerate Framework. 

The goal of this package is to provide slightly easier access to the BLAS, LAPACK and vDSP functions
of the [Accelerate](https://developer.apple.com/documentation/accelerate) framework, 
to apply these functions to Float and Double swift arrays. 

Out of scope of this package are more convenient wrappers to handle arrays as matrices, which 
would include storing strides, shapes and order (row/column major). This would require to add 
additional types, which can be easily built on top of this package. 

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
(generated with [DocToc](https://github.com/thlorenz/doctoc))

- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [Cocoa Pods](#cocoa-pods)
  - [Dependencies](#dependencies)
- [Docs](#docs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
(generated with [DocToc](https://github.com/thlorenz/doctoc))
     
## Installation

### Swift Package Manager
    dependencies: [
            .package(url: "https://github.com/dastrobu/AccelerateArray.git", from: "0.3.0"),
        ],
        
### Cocoa Pods

Make sure a valid deployment target is setup in the Podfile and add

    pod 'AccelerateArray', '~> 0'
    
### Dependencies

There are no dependencies on macOS apart from the Accelerate framework, which is installed by default.
Since Accelerate is also include din iOS and other Apple Platforms, this package should run on all Apple plattforms.

## Docs

Read the [docs](https://dastrobu.github.io/AccelerateArray/). 
