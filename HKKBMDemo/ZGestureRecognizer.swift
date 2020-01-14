//
//  ZGestureRecognizer.swift
//  Z Gesture Recognizer
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

import UIKit

public class ZGestureRecognizer : UIGestureRecognizer {
    
    // MARK: - Properties
    // MARK: -

    let requiredPasses = 2
    let minPassDistance : CGFloat = 20.0
    
    enum Direction: Int {
        case DirectionUndetermined = 0
        case DirectionLeft
        case DirectionRight
    }

    var leftToRightPassesCount : Int = 0
    var currentPassStart : CGPoint = CGPoint.zero
    var lastDirection : Direction = .DirectionUndetermined
    
    // MARK: - Overridden Methods
    // MARK: -
    
    override public func touchesBegan(_ touches: Set<UITouch>, with Event: UIEvent) {
        
        if let touch = touches.first {
            currentPassStart = touch.location(in: self.view)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        
        guard let touch = touches.first
            else { return }
        
        let touchPoint = touch.location(in: self.view)
        let moveAmt = touchPoint.x - currentPassStart.x
        var currentDirection : Direction
        currentDirection = moveAmt < 0 ? .DirectionLeft : .DirectionRight
        
        if abs(moveAmt) < minPassDistance { return }
        
        if lastDirection == .DirectionUndetermined || (lastDirection == .DirectionLeft && currentDirection == .DirectionRight) || (lastDirection == .DirectionRight && currentDirection == .DirectionLeft) {

            if currentDirection == .DirectionRight {
                leftToRightPassesCount += 1
            }

            currentPassStart = touchPoint
            lastDirection = currentDirection
            
            if state == .possible && leftToRightPassesCount >= requiredPasses{
                state = .ended
            }
        }
    }
    
    override public func reset() {
        leftToRightPassesCount = 0
        currentPassStart = CGPoint.zero
        lastDirection = .DirectionUndetermined
        if state == .possible {
            state = .failed
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        reset()
    }
  
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        reset()
    }
    
}


