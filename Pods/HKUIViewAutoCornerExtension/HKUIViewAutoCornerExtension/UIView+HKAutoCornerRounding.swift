//
//  UIView+HKAutoCornerRounding.swift
//  HK UIView Auto Corner-Rounding
//

///  MIT License
///
///  Copyright (c) 2020 Harrison Kong
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to deal
///  in the Software without restriction, including without limitation the rights
///  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell/
///  copies of the Software, and to permit persons to whom the Software is
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in all
///  copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
///  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
///  SOFTWARE.

//  Version: 1.0.0
//
//  Version History
//  -----------------------------------------------------------------
//  1.0.0     - 2020/01/18 initial release
//
//  Dependencies
//  -----------------------------------------------------------------
//  HKUIViewLengthCalculationBasis    >= 1.0.0
//  HKUIViewUtilities                 >= 1.0.0

import UIKit
import HKUIViewLengthCalculationBasis
import HKUIViewUtilities

extension UIView {

    // MARK: - Overridden Methods
    // MARK: -
    
    override open func awakeFromNib() {
        updateCornerRadius()
    }
    
    // MARK: - Private Methods
    // MARK: -
    
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
    
    public func updateCornerRadius() {
               
        if autoCornerRoundingEnabled() {
            switch autoCornerRoundingBasis() {
                
            case .width:
                layer.cornerRadius = frame.width / autoCornerRoundingFactor()
            
            case .height:
                layer.cornerRadius = frame.height / autoCornerRoundingFactor()
            
            case .shorterEdge:
                layer.cornerRadius = shorterEdgeLength() / autoCornerRoundingFactor()

            case .longerEdge:
                layer.cornerRadius = longerEdgeLength() / autoCornerRoundingFactor()
            
            case .constant:
                layer.cornerRadius = autoCornerRoundingConstant()
            }
        } else {
            layer.cornerRadius = 0
        }
    }
}
