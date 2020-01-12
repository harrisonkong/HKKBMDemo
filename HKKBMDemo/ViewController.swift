//
//  ViewController.swift
//  HKKBMDemo
//
//  Created by Harrison Kong on 1/11/20.
//  Copyright © 2020 skyRoute66. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var heightConstraint : NSLayoutConstraint?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segueSwitch: UISwitch!
    @IBOutlet weak var deviceRotationSwitch: UISwitch!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    
    var kbManager : HKUIKeyboardManagerScrollable?
    
    @IBAction func segueToggled(_ sender: UISwitch) {
        kbManager?.dismissDuringSegue = sender.isOn
        
        if !sender.isOn && !deviceRotationSwitch.isOn {
            deviceRotationSwitch.isOn = true
        }
    }
    
    @IBAction func deviceRotationToggled(_ sender: UISwitch) {
        kbManager?.dismissDuringDeviceRotation = sender.isOn
        
        if !sender.isOn && !segueSwitch.isOn {
            segueSwitch.isOn = true
        }
    }
    
    @IBAction func tapGesturesToggled(_ sender: UISwitch) {
        kbManager?.dismissOnTapGestures = sender.isOn
    }
    
    @IBAction func panGesturesToggled(_ sender: UISwitch) {
        kbManager?.dismissOnPanGestures = sender.isOn
    }
    
    @IBAction func rotationGesturesToggled(_ sender: UISwitch) {
        kbManager?.dismissOnRotationGestures = sender.isOn
    }
    
    @IBAction func pinchGesturesToggle(_ sender: UISwitch) {
        kbManager?.dismissOnPinchGestures = sender.isOn
    }
    
    @IBAction func scrollActiveFieldToggled(_ sender: UISwitch) {
        kbManager?.keepActiveFieldInView = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = .red
        scrollView.backgroundColor = .green

        kbManager = HKUIKeyboardManagerScrollable(ownerView: scrollView, outermostView: view)
        kbManager?.registerEditableField(nameTextField)
        kbManager?.registerEditableField(journalTextView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if heightConstraint != nil {
          heightConstraint?.constant = containerView.contentMinBox().height + 20
        }
        else {
          containerView.translatesAutoresizingMaskIntoConstraints = false
          heightConstraint = containerView.heightAnchor.constraint(equalToConstant: containerView.contentMinBox().height + 20)
            
          heightConstraint?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        kbManager?.viewWillTransition()
    }
}

