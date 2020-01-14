//
//  HKUIButton.swift
//  HK UIButton
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

//  Note:
// ---------------------------------------------------------------
//  There is a bug in XCode, you must go to the IB Inspector panel
//  and type something into the "image" field, then delete it for
//  the highlight behaviors to work properly
//
//  Set button type to "custom" in Interface Builder

import UIKit

@IBDesignable class HKUIButton : UIButton {
    
    // MARK: - Overridden Properties
    // MARK: -
    
    override var isEnabled : Bool {
        didSet {
            renderBorder()
        }
    }
    
    override var isHighlighted : Bool {
        didSet {
            renderEnabledBorder()
        }
    }

    // MARK: - IB Inspectable Properties
    // MARK: -
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
            updateNormalBkgColor()
        }
    }

    @IBInspectable var borderColor : UIColor = UIColor.white {
        didSet {
            updateBorderColor()
        }
    }

    @IBInspectable var borderAlpha: CGFloat = 1.0 {
        didSet {
            if borderAlpha < 0 { borderAlpha = 0.0 }
            if borderAlpha > 1 { borderAlpha = 1.0 }
            updateBorderAlpha()
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet {
            updateBorderWidth()
        }
    }
    
    @IBInspectable var normalBkg: UIColor = UIColor.init(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1.0) {
        didSet {
            updateNormalBkgColor()
        }
    }
 
    @IBInspectable var normalBkgAlpha: CGFloat = 1.0 {
        didSet {
            if normalBkgAlpha < 0 { normalBkgAlpha = 0.0 }
            if normalBkgAlpha > 1 { normalBkgAlpha = 1.0 }
            updateNormalBkgAlpha()
        }
    }
    
    @IBInspectable var normalText: UIColor = UIColor.white {
        didSet {
            updateNormalTextColor()
        }
    }

    @IBInspectable var normalTextAlpha: CGFloat = 1.0 {
        didSet {
            if normalTextAlpha < 0 { normalTextAlpha = 0.0 }
            if normalTextAlpha > 1 { normalTextAlpha = 1.0 }
            updateNormalTextAlpha()
        }
    }
    
    @IBInspectable var hiliteBdColor : UIColor = UIColor.red {
        didSet {
            updateHLBorderColor()
        }
    }

    @IBInspectable var hiliteBdAlpha: CGFloat = 1.0 {
        didSet {
            if hiliteBdAlpha < 0 { hiliteBdAlpha = 0.0 }
            if hiliteBdAlpha > 1 { hiliteBdAlpha = 1.0 }
            updateHLBorderAlpha()
        }
    }
    
    @IBInspectable var hiliteBdWidth : CGFloat = 0.0 {
        didSet {
            updateHLBorderWidth()
        }
    }
    
    @IBInspectable var hiliteBkg: UIColor = UIColor.init(red: 122/255.0, green: 122/255.0, blue: 122/255.0, alpha: 1.0) {
        didSet {
            updateHLBkgColor()
        }
    }
    
    @IBInspectable var hiliteBkgAlpha: CGFloat = 1.0 {
        didSet {
            if hiliteBkgAlpha < 0 { hiliteBkgAlpha = 0.0 }
            if hiliteBkgAlpha > 1 { hiliteBkgAlpha = 1.0 }
            updateHLBkgAlpha()
        }
    }

    @IBInspectable var hiliteText: UIColor = UIColor.white {
        didSet {
            updateHLTextColor()
        }
    }
    
    @IBInspectable var hiliteTextAlpha: CGFloat = 0.5 {
        didSet {
            if hiliteTextAlpha < 0 { hiliteTextAlpha = 0.0 }
            if hiliteTextAlpha > 1 { hiliteTextAlpha = 1.0 }
            updateHLTextAlpha()
        }
    }

    @IBInspectable var disabledBdColor : UIColor = UIColor.red {
        didSet {
            updateDisabledBorderColor()
        }
    }

    @IBInspectable var disabledBdAlpha: CGFloat = 1.0 {
        didSet {
            if disabledBdAlpha < 0 { disabledBdAlpha = 0.0 }
            if disabledBdAlpha > 1 { disabledBdAlpha = 1.0 }
            updateDisabledBorderAlpha()
        }
    }
    
    @IBInspectable var disabledBdWidth : CGFloat = 0.0 {
        didSet {
            updateDisabledBorderWidth()
        }
    }
    
    @IBInspectable var disabledBkg: UIColor = UIColor.darkGray {
        didSet {
            updateDisabledBkgColor()
        }
    }
    
    @IBInspectable var disabledBkgAlpha: CGFloat = 1.0 {
        didSet {
            if disabledBkgAlpha < 0 { disabledBkgAlpha = 0.0 }
            if disabledBkgAlpha > 1 { disabledBkgAlpha = 1.0 }
            updateDisabledBkgAlpha()
        }
    }

    @IBInspectable var disabledText: UIColor = UIColor.white {
        didSet {
            updateDisabledTextColor()
        }
    }
    
    @IBInspectable var disabledTextAlpha: CGFloat = 0.5 {
        didSet {
            if disabledTextAlpha < 0 { disabledTextAlpha = 0.0 }
            if disabledTextAlpha > 1 { disabledTextAlpha = 1.0 }
            updateDisabledTextAlpha()
        }
    }
    
    // MARK: - Overridden Methods
    // MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    // MARK: - Instance Methods
    // MARK: -
    
    private func commonInit() {
        
        updateCornerRadius()
        // (updating alphas auto triggers corresp. color update)
        updateBorderAlpha()
        updateBorderWidth()
        updateDisabledBorderAlpha()
        updateDisabledBorderWidth()
        updateHLBorderAlpha()
        updateHLBorderWidth()
        updateDisabledBkgAlpha()
        updateDisabledTextAlpha()
        updateHLBkgAlpha()
        updateHLTextAlpha()
        updateNormalBkgAlpha()
        updateNormalTextAlpha()
        renderBorder()
    }

    private func createImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x:0, y:0, width:1, height:1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    private func renderBorder() {
        if isEnabled {
            renderEnabledBorder()
        } else {
            layer.borderColor = disabledBdColor.cgColor
            layer.borderWidth = disabledBdWidth
        }
    }
    
    private func renderEnabledBorder() {
        layer.borderColor = isHighlighted ? hiliteBdColor.cgColor : borderColor.cgColor
        layer.borderWidth = isHighlighted ? hiliteBdWidth : borderWidth
    }
    
    private func updateBorderAlpha() {
        borderColor = borderColor.withAlphaComponent(borderAlpha)
    }
    
    private func updateBorderColor() {
        if isEnabled {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    private func updateBorderWidth() {
        if isEnabled {
            layer.borderWidth = borderWidth
        }
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
    
    private func updateDisabledBkgAlpha() {
        disabledBkg = disabledBkg.withAlphaComponent(disabledBkgAlpha)
    }
 
    private func updateDisabledBkgColor() {
        if disabledBkg == UIColor.clear {
            setBackgroundImage(nil, for: UIControl.State.disabled)
        } else {
            let image = createImage(color: disabledBkg)
            setBackgroundImage(image, for: UIControl.State.disabled)
            clipsToBounds = true
        }
    }

    private func updateDisabledBorderAlpha() {
        disabledBdColor = disabledBdColor.withAlphaComponent(disabledBdAlpha)
    }
    
    private func updateDisabledBorderColor() {
        if !isEnabled {
            layer.borderColor = disabledBdColor.cgColor
        }
    }
    
    private func updateDisabledBorderWidth() {
        if !isEnabled {
            layer.borderWidth = disabledBdWidth
        }
    }
    
    private func updateDisabledTextAlpha() {
        disabledText = disabledText.withAlphaComponent(disabledTextAlpha)
    }
    
    private func updateDisabledTextColor() {
        setTitleColor(disabledText, for: UIControl.State.disabled)
    }
    
    private func updateHLBorderAlpha() {
        hiliteBdColor = hiliteBdColor.withAlphaComponent(hiliteBdAlpha)
    }
    
    private func updateHLBorderColor() {
        if state == UIControl.State.highlighted {
            layer.borderColor = hiliteBdColor.cgColor
        }
    }
    
    private func updateHLBorderWidth() {
        if state == UIControl.State.highlighted {
            layer.borderWidth = hiliteBdWidth
        }
    }
    
    private func updateHLBkgAlpha() {
        hiliteBkg = hiliteBkg.withAlphaComponent(hiliteTextAlpha)
    }

    private func updateHLBkgColor() {
        if hiliteBkg == UIColor.clear {
            setBackgroundImage(nil, for: UIControl.State.highlighted)
        } else {
            let image = createImage(color: hiliteBkg)
            setBackgroundImage(image, for: UIControl.State.highlighted)
            clipsToBounds = true
        }
    }
    
    private func updateHLTextAlpha() {
        hiliteText = hiliteText.withAlphaComponent(hiliteTextAlpha)
    }
    
    private func updateHLTextColor() {
        setTitleColor(hiliteText, for: UIControl.State.highlighted)
    }

    private func updateNormalBkgAlpha() {
        normalBkg = normalBkg.withAlphaComponent(normalBkgAlpha)
    }
    
    private func updateNormalBkgColor() {
        backgroundColor = normalBkg
    }

    private func updateNormalTextAlpha() {
        normalText = normalText.withAlphaComponent(normalTextAlpha)
    }
    
    private func updateNormalTextColor() {
        setTitleColor(normalText, for: UIControl.State.normal)
    }
}