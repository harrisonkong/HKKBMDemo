//
//  HKUIKeyboardManagerScrollable.swift
//  HK Keyboard Manager
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
//  1.0.0     -     initial release

//  Dependencies
//  -----------------------------------------------------------------
//  HKDebug
//  UIView+HKUtilities

//  How To Use
//  -----------------------------------------------------------------

/*
 
    (Use HKUIKeyboardManager for non-scrollable views,
     use HKUIKeyboardManager for scrollable views such as UIScrollView, UITableView, UICollectionView)
 
    1. Initialize and register text fields
 
       let HKUIKeyboardManager : HKUIKeyboardManager?
       .
       .
       .
 
       override func viewDidLoad() {
         super.viewDidLoad()
   
           // code ...

           HKUIKeyboardManager = HKUIKeyboardManager.init(ownerView: scrollView, outermostView: view)
   
           HKUIKeyboardManager?.registerEditableField(nameTextField)
           HKUIKeyboardManager?.registerEditableField(addressTextField)
 
          // more code ...
        }
 
    (Optional Steps:)
 
    2. Call from the overridden prepare if you want to hide the keyboard
       when seguing to another screen (dismissDuringSegue == true)
  
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
           // some code ...

           HKUIKeyboardManager?.preparingSegue()
  
           // some other code ...
       }

    3. Call from the overridden viewWillTransition if you want to hide the
       keyboard during device rotation (dismissDuringDeviceRotation == true)
 
       override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
   
          super.viewWillTransition(to: size, with: coordinator)
   
          // do whatever ...
   
          HKUIKeyboardManager?.viewWillTransition()
       }

    4. If you would like the keyboard to be dismissed upon custom gestures,
      register your own custom gesture recognizers
 
      ...
      HKUIKeyboardManager?.registerCustomGestureRecognizer(tripleTapRecognizer)
      ...
 
    5. Change other user options as needed:
 
      property                    default     meaning if it is true
      -------------------------------------------------------------------------
      dismissOnTapGestures        true        if taps are detected outside
                                              of keyboard and not in text
                                              fields, keyboard will dismiss
 
      dismissOnPanGestures        true        if pans are detected outside
                                              of keyboard and not in text
                                              fields, keyboard will dismiss
 
                                  false       (set to false by default for
                                              HKUIKeyboardManagerScrollable to
                                              allow scrolling)

      dismissOnPinchGestures      true        if pinches are detected outside
                                              of keyboard and not in text
                                              fields, keyboard will dismiss
 
      dismissOnRotationGestures   true        if rotation gestures are detected
                                              outside of keyboard and not in
                                              text fields, keyboard will dismiss
 
      dismissDuringSegue          true        dismiss the keyboard when a segue
                                              is being prepared, only set to
                                              false if the view does not rotate.
                                              Subject to automatically setting
                                              to true if the view rotates and
                                              this is set to false.
                                              See development notes below.
 
      dismissDuringDeviceRotation true        dismiss the keyboard when the
                                              device is rotated, only set to
                                              false if the view does not segue
                                              to another screen.
                                              Subject to automatically setting
                                              to true if a segue is prepared and
                                              this is set to false.
                                              See development notes below.
 
      keepActiveFieldInViews      true        (HKUIKeyboardManagerScrollable
                                              only)
                                              if the active text field is
                                              obscured by the keyboard when it
                                              first receive focus, it will be
                                              scrolled to above the keyboard
 */
     
//  Development Notes
//  -----------------------------------------------------------------

/*
    Several bugs at the iOS level were discovered duriung development leading
    to some design considerations. These bugs have been around for a while. But
    there are no guarantee if they will behave the same in future iOS releases.

    1. Sometimes it is possible to get two
      UIResponder.keyboardWillShowNotification or
      UIResponder.keyboardWillHideNotification in succession. We do not
      want to process two in a row as it will set the insets twice. (e.g.,
      when something is typed into a text field and the return key is tapped.)
      A state instance variable keyboardWasShowing is set up to track to see
      if the keyboard is currently showing. (We check the same for the hide
      notifications, too but it is really not necessary because when we are
      hiding the keyboard, we simply set the insets to 0's.)

      For example, if we get a willShow notification and the variable is true,
      we ignore the notification.

    2. Keyboard height passed in the notification is very inconsistent but the
      first one received during either orientation is correct. So we save it
      for future use and ignore the future values unless they are bigger than
      the one saved.

      => maxPortraitKeyboardHeight
      => maxLandscapeKeyboardHeight

      This usually only occurs when the device is rotated while another screen
      is on top of the current one. Therefore, by default, the keyboard is
      dismissed to reset the system during segue preparation. But it can be
      overridden if rotation is not allowed for the screen.

      ==> Set dismissKeyboardDuringSegue to false.

      During device rotation, if we find this was set to false, we will set
      it to true as a safety measure!

    3. Related to 2. above, by default, we dismiss the keyboard when the device
      is rotated. But it can be overridden if the screen does not spawn another
      other screens.

      ==> Set `dismissDuringDeviceRotation` to false.

      During segue prepration, if we find this was set to false, we will set
      it to true as a safety measure!

    4. These classes listen to TextEditingDidBegin, TextEditingdidEnd,
      keyboardWillShow and keyboardWillHide notifications
 
      UITextField and UITextView do not follow the same notification sequence
      when it is entering and exiting edit mode
 
      UITextField                 UITextView
      ------------------          -------------------
      textEditingDidBegin         keyboardWillShow
      keyboardWillShow            textEditingDidBegin
      keyboardWillHide            keyboardWillHide
      textEditingWillEnd          textEditignWillEnd
 
      During the keyboard hide/show notifications we only have the keyboard
      frame dimension and not the active editing field and vice versa
 
      Therefore it is necessary to save the active field and keyboard frame
      as instance variables
 
*/

import UIKit

public class HKUIKeyboardManagerScrollable : HKUIKeyboardManager {
  
    // MARK: - Properties
    // MARK: -

    var keyboardWasShowing         : Bool = false
    var maxLandscapeKeyboardHeight : CGFloat = 0.0
    var maxPortraitKeyboardHeight  : CGFloat = 0.0
    var activeEditableField        : UIView?
    var cgKeyboardFrame            : CGRect?
  
    let EDITABLE_FIELD_BOTTOM_MARGIN = CGFloat(10.0)
    let EDITABLE_FIELD_TOP_MARGIN    = CGFloat(10.0)
 
    public var keepActiveFieldInView  = true
  
    // MARK: - Initializers
    // MARK: -
  
    override init(ownerView: UIView, outermostView: UIView) {
      
        super.init(ownerView: ownerView, outermostView: outermostView)
      
        // allow scrolling
      
        dismissOnPanGestures = false
      
        // listen for global keyboardWillShow
      
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow(_:)),
          name: UIResponder.keyboardWillShowNotification,
          object: nil)

        // listen for global keyboardWillHide
      
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide(_:)),
          name: UIResponder.keyboardWillHideNotification,
          object: nil)
      
        // listen for textDidBeginEditingNotification in text views
      
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(handleTextDidBeginEditing(_:)),
          name: UITextView.textDidBeginEditingNotification,
          object: nil)
      
        // listen for textDidEndEditingNotification in text views
      
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(handleTextDidEndEditing(_:)),
          name: UITextView.textDidEndEditingNotification,
          object: nil)
      
        // listen for textDidBeginEditingNotification in text fields
      
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(handleTextDidBeginEditing(_:)),
          name: UITextField.textDidBeginEditingNotification,
          object: nil)
      
        // listen for textDidEndEditingNotification in text fields
      
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(handleTextDidEndEditing(_:)),
          name: UITextField.textDidEndEditingNotification,
          object: nil)
      
  }
  
    // MARK: - Public Methods
    // MARK: -

    @objc func handleTextDidBeginEditing(_ notification: Notification) {
        HKDebug.deactivateCategory("handleTextDidBeginEditing()")
        HKDebug.print("--- begins ---", category: "handleTextDidBeginEditing()")

        guard let sender = notification.object as? UIView else {
          HKDebug.print("--- quits ---", category: "handleTextDidBeginEditing()")
            return
        }
    
        if textFieldsAndViews.contains(sender) {
          
            HKDebug.print("sender saved into instance variable activeEditableField for later...", category: "handleTextDidBeginEditing()")
            activeEditableField = sender
          
            // UITextView receives TextEditingDidBeginNotification after
            // keyboardWillShow. So we are going to do scrolling into view here
            // if sender is a UITextView
          
            if isUITextView(sender) {
              
                HKDebug.print("sender is a UITextView, scrolling if necessary...", category: "handleTextDidBeginEditing()")
              
                if keepActiveFieldInView && cgKeyboardFrame != nil {
                  scrollActiveFieldIntoViewIfNecessary()
                } else {
                  HKDebug.print("cgKeyboardFrame is nil -OR- keepActiveFieldInView set to false, scrolling skipped", category: "handleTextDidBeginEditing()")
                }
            }

        } else {
            HKDebug.print("sender \(sender) is not registered with this manager, ignoring this notification", category: "handleTextDidBeginEditing()")
        }
 
        HKDebug.print("--- ends ---", category: "handleTextDidBeginEditing()")

    }
 
    @objc func handleTextDidEndEditing(_ notification: Notification) {
        HKDebug.deactivateCategory("handleTextDidEndEditing()")
        HKDebug.print("--- begins ---", category: "handleTextDidEndEditing()")

        activeEditableField = nil
        HKDebug.print("activeEditableField set to nil", category: "handleTextDidEndEditing()")

        HKDebug.print("--- ends ---", category: "handleTextDidEndEditing()")
    }
  
    // MARK: - Private Methods
    // MARK: -
  
    private func adjustInsetsForKeyboard(_ show: Bool, notification: Notification) {
    
        HKDebug.deactivateCategory("adjustInsetsForKeyboard()")
      
        guard
          let userInfo = notification.userInfo,
          let keyboardFrame =
          userInfo [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
          let scrollView = ownerView as? UIScrollView,
          let outermostView = outermostView
        else {
            return
        }
    
        HKDebug.print("----- begins -----", category: "adjustInsetsForKeyboard()")
      
        if show {
          
          // ----- show -----
          
          HKDebug.print("keyboard will be showing:", category: "adjustInsetsForKeyboard()")
          
          let keyboardHeightReceived = keyboardFrame.cgRectValue.height
          var adjustmentHeight = CGFloat(0.0)
          
          HKDebug.print("keyboardHeightReceived = \(keyboardHeightReceived)", category: "adjustInsetsForKeyboard()")

          if outermostView.isPortrait() {
            HKDebug.print("We are in portrait mode, maxPortraitKeyboardHeight is \(maxPortraitKeyboardHeight)", category: "adjustInsetsForKeyboard()")
            if keyboardHeightReceived > maxPortraitKeyboardHeight {
              maxPortraitKeyboardHeight = keyboardHeightReceived
              HKDebug.print("keyboardHeightReceived (\(maxPortraitKeyboardHeight)) set as new maxPortraitKeyboardHeight", category: "adjustInsetsForKeyboard()")
            }
            adjustmentHeight = maxPortraitKeyboardHeight
          } else {
            HKDebug.print("We are in landscape mode, maxLandscapeKeyboardHeight is \(maxLandscapeKeyboardHeight)", category: "adjustInsetsForKeyboard()")
            if keyboardHeightReceived > maxLandscapeKeyboardHeight {
              maxLandscapeKeyboardHeight = keyboardHeightReceived
              HKDebug.print("keyboardHeightReceived (\(keyboardHeightReceived)) set as new maxLandscapeKeyboardHeight", category: "adjustInsetsForKeyboard()")
            }
            adjustmentHeight = maxLandscapeKeyboardHeight
          }
                
          HKDebug.print("adjustmentHeight is \(adjustmentHeight)", category: "adjustInsetsForKeyboard()")
          scrollView.contentInset.bottom += adjustmentHeight
          scrollView.verticalScrollIndicatorInsets.bottom += adjustmentHeight
          
          cgKeyboardFrame = keyboardFrame.cgRectValue
          HKDebug.print("keyboard frame saved in instance variable cgKeyboardFrame", category: "adjustInsetsForKeyboard()")
          
          // activeEditableField will be set to a value if a UITextField got
          // input focus for the first time or if the keyboard was dismissed
          // on a UITextView without losing input focus
          
          if activeEditableField != nil {
            
            HKDebug.print("activeEditableField is not nil, scroll if necessary...", category: "adjustInsetsForKeyboard()")
            if keepActiveFieldInView {
                scrollActiveFieldIntoViewIfNecessary()
            }
            
          }
          
        } else {
          
          // ----- hide -----
          
          HKDebug.print("keyboard will be hiding:", category: "adjustInsetsForKeyboard()")
          scrollView.contentInset.bottom = 0.0
          scrollView.verticalScrollIndicatorInsets.bottom = 0.0
        }

        HKDebug.print("scrollView.contentInset.bottom set to \(scrollView.contentInset.bottom)", category: "adjustInsetsForKeyboard()")
        HKDebug.print("scrollView.verticalScrollIndicatorInsets.bottom set to \(scrollView.verticalScrollIndicatorInsets.bottom)", category: "adjustInsetsForKeyboard()")
        
        HKDebug.print("----- ends -----", category: "adjustInsetsForKeyboard()")
    }
  
    private func scrollActiveFieldIntoViewIfNecessary() {

        HKDebug.deactivateCategory("scrollActiveField...()")
        HKDebug.print("--- begins ---", category: "scrollActiveField...()")
        guard let scrollView = ownerView as? UIScrollView,
              let cgKeyboardFrame = cgKeyboardFrame,
              let activeEditableField = activeEditableField
        else {
            HKDebug.print("cyKeybaordFrame is nil or activeEditableField is nil", category: "scrollActiveField...()")
            HKDebug.print("--- quits ---", category: "scrollActiveField...()")
            return
        }
      
        let fieldFrame = activeEditableField.frame

        HKDebug.print("activeField.frame = \(fieldFrame)", category: "scrollActiveField...()")

        let fieldFrameToScreen = CGRect(x: fieldFrame.minX - scrollView.contentOffset.x, y: fieldFrame.minY - scrollView.contentOffset.y, width: fieldFrame.width, height: fieldFrame.height)

        HKDebug.print("fieldFrameToScreen = \(fieldFrameToScreen)", category: "scrollActiveField...()")
      
        // if the top of the active field is above the top edge, simply
        // scroll it down
      
        if fieldFrameToScreen.minY < EDITABLE_FIELD_TOP_MARGIN {
            // scroll down
          
          let scrollDelta = abs(fieldFrameToScreen.minY) + EDITABLE_FIELD_TOP_MARGIN
          
          scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y - scrollDelta), animated: true)
          
          HKDebug.print("scrollDelta used to scroll downn field into view = \(scrollDelta)", category: "scrollActiveField...()")
            
        } else {
          
            // scroll up if behind keyboard
      
            HKDebug.print("cgkeyboardFrame = \(cgKeyboardFrame)", category: "scrollActiveField...()")
              
            let autocompleteBarHeight = cgKeyboardFrame.height * 0.25
              
            HKDebug.print("autocompleteBarHeight calculated to \(autocompleteBarHeight)", category: "scrollActiveField...()")

            let keyboardFrameCorrected = CGRect(x: cgKeyboardFrame.minX, y: cgKeyboardFrame.minY - autocompleteBarHeight, width: cgKeyboardFrame.width, height: cgKeyboardFrame.height)

            HKDebug.print("keyboardFrameCorrected = \(keyboardFrameCorrected)", category: "scrollActiveField...()")

            HKDebug.print("intesected? = \(String(describing: fieldFrameToScreen.intersects(keyboardFrameCorrected)))", category: "scrollActiveField...()")
           
            // see if the editable field is at least partially hidden by
            // the keyboard

            if fieldFrameToScreen.intersects(keyboardFrameCorrected) {
             
               let scrollDelta = fieldFrameToScreen.minY - keyboardFrameCorrected.minY + fieldFrameToScreen.height + EDITABLE_FIELD_BOTTOM_MARGIN
               
               scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + scrollDelta ), animated: true)

               HKDebug.print("scrollDelta used to scroll field up into view = \(scrollDelta)", category: "scrollActiveField...()")
            }
        }
        HKDebug.print("--- ends ---", category: "scrollActiveField...()")
    }
  
    // MARK: - Notification Handlers
    // MARK: -

    @objc func keyboardWillHide(_ notification: Notification) {

        HKDebug.deactivateCategory("keyboardWillHide()")
        
        HKDebug.print("--------- begins -----------", category: "keyboardWillHide()")

        if (!keyboardWasShowing) {
          HKDebug.print("*** Notification ignored - keyboard was already hidden", category: "keyboardWillHide()")
        } else {
          HKDebug.print("keyboardWasShowing = \(keyboardWasShowing) ... proceed", category: "keyboardWillHide()")
          keyboardWasShowing = false
          cgKeyboardFrame = nil
          adjustInsetsForKeyboard(false, notification: notification)
        }
        HKDebug.print("--------- ends -------------", category: "keyboardWillHide()")
    }
  
    @objc func keyboardWillShow(_ notification: Notification) {

        HKDebug.deactivateCategory("keyboardWillShow()")
        
        HKDebug.print("--------- begins -----------", category: "keyboardWillShow()")
      
        if (keyboardWasShowing) {
          HKDebug.print("*** Notification ignored - keyboard was already showing", category: "keyboardWillShow()")
          
          if activeEditableField != nil && cgKeyboardFrame != nil && keepActiveFieldInView {
              HKDebug.print("*** Notification ignored - but let's see if we need to scroll another active text field into view...", category: "keyboardWillShow()")
              scrollActiveFieldIntoViewIfNecessary()
          }
          
        } else {
          HKDebug.print("keyboardWasShowing = \(keyboardWasShowing) ... proceed", category: "keyboardWillShow()")
          keyboardWasShowing = true
          adjustInsetsForKeyboard(true, notification: notification)
        }
        
        HKDebug.print("--------- ends -------------", category: "keyboardWillShow()")
    }

}
