# HKUIViewAutoCornerExtension
#### HK UIView extension for automatically corner radius calculation

## INTRODUCTION

Using fixed corner radius in rectangular views often lead to inconsistent results when the device is rotated. This module provides the basic funcationalities to calculate a corner radius dynamically base on one of the sizes.

## HOW IT WORKS

Since extension cannot have variables, descendents should override these four methods to provide the values.

```
    @objc open func autoCornerRoundingBasis() -> LengthCalculationBasis {
        return .shorterEdge
    }
    
    @objc open func autoCornerRoundingConstant() -> CGFloat {
        return 30.0
    }
    @objc open func autoCornerRoundingEnabled() -> Bool {
        return false
    }
    
    @objc open func autoCornerRoundingFactor() -> CGFloat {
        return 12.0
    }
```

A method calculates the corner radius based on one of the 5 ways:

  1. proportional to width
  2. proportional to height
  3. proportional to the shorter edge
  4. proportional to the longer edge
  5. constant
  
and set the corner radius of the layer. Descendants can call this method when it is ready to redraw.

```
    public func updateCornerRadius()
```

## INSTALLATION

Manually: 

Include in your project

```
  UIView+HKAutoCornerRounding.swift
  UIView+LengthCalculationBasis.swift
```

Or use CocoaPod. Don't forget to import the module if you are using CocoaPod:

```
  import HKUIKeyboardManager
```
