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
//  1.0.0     - 2020/01/01 - initial release
//                           autoCornerRounding

//  Dependencies
//  -----------------------------------------------------------------
//  UIView+HKUtilities

import UIKit

extension UIView {
    
    // declaring this as an objective C raw Int enum makes it inspectable
    // in interface builder
    
    // MARK: - Properties
    // MARK: -
        
    @objc public enum AutoCornerRoundingBasis: Int {
        case width = 1
        case height
        case shorterEdge
        case longerEdge
        case constant
    }

    // MARK: - Overridden Methods
    // MARK: -
    
    override open func awakeFromNib() {
        updateCornerRadius()
    }
    
    // MARK: - Private Methods
    // MARK: -
    
    @objc func autoCornerRoundingBasis() -> AutoCornerRoundingBasis {
        return AutoCornerRoundingBasis.shorterEdge
    }
    
    @objc func autoCornerRoundingConstant() -> CGFloat {
        return 30.0
    }
    @objc func autoCornerRoundingEnabled() -> Bool {
        return false
    }
    
    @objc func autoCornerRoundingFactor() -> CGFloat {
        return 12.0
    }
    
    func updateCornerRadius() {
               
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
            
            case .constant:                print("by constant")
                layer.cornerRadius = autoCornerRoundingConstant()
            }
        } else {
            layer.cornerRadius = 0
        }
    }
}
