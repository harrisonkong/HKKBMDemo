//
//  HKUIImageView.swift
//  HK UIImageView
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
//                         - auto corner rounding
//  Dependencies
//  -----------------------------------------------------------------
//  HKLengthCalculationBasis        >= 1.0.0
//  UIView+HKAutoCornerRounding

import UIKit
import HKUIViewAutoCornerExtension
import HKUIViewLengthCalculationBasis

@IBDesignable public class HKUIImageView : UIImageView {
    
    // MARK: - Properties
    // MARK: -
    
    override public var isHighlighted : Bool {
        didSet {
            renderBorder()
        }
    }

    // MARK: - IB Inspectable Properties
    // MARK: -
    
    @IBInspectable var autoCornerRounding : Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    // unfortunately IB inspectable does not support enum, we have to use
    // an integer:
    //
    // 1 = .width
    // 2 = .height
    // 3 = .shorterEdge
    // 4 = .longerEdge
    // 5 = .constant
    
    var roundingBasis : LengthCalculationBasis = .shorterEdge
    
    @IBInspectable public var cornerRoundingBasis : Int {
        get {
            return roundingBasis.rawValue
        }
        set(index) {
            
            var newIndex = index
            if newIndex < 0 { newIndex = 1 }
            if newIndex > 5 { newIndex = 5 }
            roundingBasis = LengthCalculationBasis(rawValue: newIndex) ?? .shorterEdge
            updateCornerRadius()
        }
    }
    
    @IBInspectable public var cornerRadiusConstant : CGFloat = 30.0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable public var cornerRadiusFactor : CGFloat = 12.0 {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable public var borderColor : UIColor = UIColor.white {
        didSet {
            updateBorderColor()
        }
    }

    @IBInspectable public var borderAlpha: CGFloat = 1.0 {
        didSet {
            if borderAlpha < 0 { borderAlpha = 0.0 }
            if borderAlpha > 1 { borderAlpha = 1.0 }
            updateBorderAlpha()
        }
    }
    
    @IBInspectable public var borderWidth : CGFloat = 0.0 {
        didSet {
            updateBorderWidth()
        }
    }
    
    @IBInspectable public var hiliteBdColor : UIColor = UIColor.red {
        didSet {
            updateHLBorderColor()
        }
    }

    @IBInspectable public var hiliteBdAlpha: CGFloat = 1.0 {
        didSet {
            if hiliteBdAlpha < 0 { hiliteBdAlpha = 0.0 }
            if hiliteBdAlpha > 1 { hiliteBdAlpha = 1.0 }
            updateHLBorderAlpha()
        }
    }
    
    @IBInspectable public var hiliteBdWidth : CGFloat = 0.0 {
        didSet {
            updateHLBorderWidth()
        }
    }
    
    @IBInspectable public var hiliteBkg: UIColor = UIColor.init(red: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0) {
        didSet {
            updateHLBkgColor()
        }
    }
    
    @IBInspectable public var hiliteBkgAlpha: CGFloat = 1.0 {
        didSet {
            if hiliteBkgAlpha < 0 { hiliteBkgAlpha = 0.0 }
            if hiliteBkgAlpha > 1 { hiliteBkgAlpha = 1.0 }
            updateHLBkgAlpha()
        }
    }
    
    // MARK: - Overridden Methods
    // MARK: -
    
    override public func autoCornerRoundingBasis() -> LengthCalculationBasis {
        return roundingBasis
    }
    
    override public func autoCornerRoundingConstant() -> CGFloat {
        return cornerRadiusConstant
    }
    
    override public func autoCornerRoundingEnabled() -> Bool {
        return autoCornerRounding
    }
    
    override public func autoCornerRoundingFactor() -> CGFloat {
        return cornerRadiusFactor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
  
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    override public func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    // MARK: - Private Methods
    // MARK: -
    
    private func commonInit() {
        
        updateCornerRadius()
        // (updating alphas auto triggers corresp. color update)
        updateBorderAlpha()
        updateBorderWidth()
        updateHLBorderAlpha()
        updateHLBorderWidth()
        updateHLBkgAlpha()
        renderBorder()
    }
    
    private func renderBorder() {
        layer.borderColor = isHighlighted ? hiliteBdColor.cgColor : borderColor.cgColor
        layer.borderWidth = isHighlighted ? hiliteBdWidth : borderWidth
    }
    
    private func updateBorderAlpha() {
        borderColor = borderColor.withAlphaComponent(borderAlpha)
    }
    
    private func updateBorderColor() {
        layer.borderColor = borderColor.cgColor
    }
    
    private func updateBorderWidth() {
        layer.borderWidth = borderWidth
    }
    
    private func updateHLBorderAlpha() {
        hiliteBdColor = hiliteBdColor.withAlphaComponent(hiliteBdAlpha)
    }
    
    private func updateHLBorderColor() {
        if isHighlighted {
            layer.borderColor = hiliteBdColor.cgColor
        }
    }
    
    private func updateHLBorderWidth() {
        if isHighlighted {
            layer.borderWidth = hiliteBdWidth
        }
    }
    
    private func updateHLBkgAlpha() {
        hiliteBkg = hiliteBkg.withAlphaComponent(hiliteBkgAlpha)
    }

    private func updateHLBkgColor() {
        if hiliteBkg == UIColor.clear {
            backgroundColor = nil
        } else {
            backgroundColor = hiliteBkg

        }
    }
}

