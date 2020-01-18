# HKLengthCalculationBasis
#### HK Length Calculation Basis Enumeration

## SUMMARY

This module defines the HK Length Calculation Basis Enumeration. This is a required module for many other Swift HK modules.

## DEFINITION

This is defined as an objective C raw Int enum makes it adaptable as an `@IBInspectable` in XCode interface builder

```
  @objc public enum HKLengthCalculationBasis: Int {
      case width = 1
      case height
      case shorterEdge
      case longerEdge
      case constant
  }
```

## INSTALLATION

This will be automatically included by other HK modules or CocoaPods.

### TO USE IT IN YOUR OWN PROJECT

Just include the UIView+HKUILayoutShorthands.swift file in your project or use CocoaPod. Don't forget to import the module if you are using CocoaPod:

```
  import HKLengthCalculationBasis
```
