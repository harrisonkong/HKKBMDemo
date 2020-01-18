//
//  ViewController.swift
//  HKKBMDemo
//
//  Created by Harrison Kong on 1/11/20.
//  Copyright © 2020 skyRoute66. All rights reserved.
//

//  Dependencies
//  -----------------------------------------------------------------
//  HKDebug
//  HKUIButton
//  HKUIKeyboardManager             >= 1.0.0
//  HKUIViewUtilities               >= 1.0.0

import UIKit
import AVFoundation
import HKUIKeyboardManager

class ViewController: UIViewController {
    
    // MARK: - Properties
    // MARK: -

    private var heightConstraint : NSLayoutConstraint?
    var kbManager : HKUIKeyboardManagerScrollable?
    var bellPlayer : AVAudioPlayer?
    var zPlayer: AVAudioPlayer?
    private let zRecognizer = ZGestureRecognizer()
    
    // MARK: - IB Outlets
    // MARK: -
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segueSwitch: UISwitch!
    @IBOutlet weak var deviceRotationSwitch: UISwitch!
    @IBOutlet weak var segueTestButton: UIButton!
    
    @IBOutlet weak var boat: UIImageView!
    @IBOutlet weak var boatBox: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
        
    // MARK: - IB Actions
    // MARK: -
    
    @IBAction func deviceRotationToggled(_ sender: UISwitch) {
        kbManager?.dismissDuringDeviceRotation = sender.isOn
        
        if !sender.isOn && !segueSwitch.isOn {
            segueSwitch.isOn = true
            kbManager?.dismissDuringSegue = true
        }
        
        segueTestButton.isEnabled = sender.isOn

    }

    @IBAction func handleCustomGesture(_ sender: UIGestureRecognizer) {
        flashZ()
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: boatBox)
                
        if let boat = recognizer.view {
            
            var newX = boat.center.x + translation.x
            
            if newX < boat.frame.width / 2.0 {
                newX = boat.frame.width / 2.0
            }

            if newX > boatBox.frame.width - boat.frame.width / 2.0 {
                newX = boatBox.frame.width - boat.frame.width / 2.0
            }

            var newY = boat.center.y + translation.y
            
            if newY < boat.frame.height / 2.0 {
                newY = boat.frame.height / 2.0
            }

            if newY > boatBox.frame.height - boat.frame.height / 2.0 {
                newY = boatBox.frame.height - boat.frame.height / 2.0
            }
            
            boat.center = CGPoint(x: newX, y: newY)
        }
        recognizer.setTranslation(CGPoint.zero, in: view)
    }

    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        
        if let helm = recognizer.view {
          helm.transform = helm.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
          recognizer.scale = 1
        }
    }

    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        
        if let helm = recognizer.view {
          helm.transform = helm.transform.rotated(by: recognizer.rotation)
          recognizer.rotation = 0
        }
    }
 
    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        self.bellPlayer?.play()
    }
    
    @IBAction func panGesturesToggled(_ sender: UISwitch) {
        kbManager?.dismissOnPanGestures = sender.isOn
    }
    
    @IBAction func pinchGesturesToggle(_ sender: UISwitch) {
        kbManager?.dismissOnPinchGestures = sender.isOn
    }
    
    @IBAction func rotationGesturesToggled(_ sender: UISwitch) {
        kbManager?.dismissOnRotationGestures = sender.isOn
    }
    
    @IBAction func scrollActiveFieldToggled(_ sender: UISwitch) {
        kbManager?.keepActiveFieldInView = sender.isOn
    }
    
    @IBAction func segueToggled(_ sender: UISwitch) {
        kbManager?.dismissDuringSegue = sender.isOn
        
        if !sender.isOn && !deviceRotationSwitch.isOn {
            deviceRotationSwitch.isOn = true
            kbManager?.dismissDuringDeviceRotation = true
        }

        segueTestButton.isEnabled = true
    }
    
    @IBAction func tapGesturesToggled(_ sender: UISwitch) {
        kbManager?.dismissOnTapGestures = sender.isOn
    }
    
    // MARK: - Lifecycle
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = .orange
        scrollView.backgroundColor = .blue

        bellPlayer = makeAudioPlayer(resourceName: "ship-bell")
        zPlayer = makeAudioPlayer(resourceName: "scratch")
                
        kbManager = HKUIKeyboardManagerScrollable(ownerView: scrollView, outermostView: view)
        kbManager?.dismissDuringDeviceRotation = false
        kbManager?.registerEditableField(nameTextField)
        kbManager?.registerEditableField(journalTextView)
        
        // add custom Z gesture recognizer
        
        zRecognizer.addTarget(self, action: #selector(handleCustomGesture(_:)))
        kbManager?.registerCustomGestureRecognizer(zRecognizer)

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
        
        segueSwitch.isOn = true  // must dismiss on segue if device rotates
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        kbManager?.viewWillTransition()
    }
    
    // MARK: - Overridden Methods
    // MARK: -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        kbManager?.preparingSegue()
    }
    
    // MARK: - Private Methods
    // MARK: -
    
    private func flashZ() {
        
        let side = view.shorterEdgeLength()
        
        let imageView = UIImageView(frame: CGRect(x: (view.frame.size.width - side) / 2.0, y: (view.frame.size.height - side) / 2.0, width: side, height: side))
        let image = UIImage(named: "z.png")
        imageView.image = image
        view.addSubview(imageView)
        
        self.zPlayer?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // remove it after a second
            imageView.removeFromSuperview()
        }
    }
    
    private func makeAudioPlayer(resourceName: String) -> AVAudioPlayer? {
        
        var player : AVAudioPlayer

        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "mp3")
            else { return nil }

        do {
            try player = AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            print("Unable to load audio resource \(url): \(error.localizedDescription)")
            return nil
        }

    }
}

// MARK: -
// MARK: -

extension ViewController : UIGestureRecognizerDelegate {
  
    // MARK: UIGestureRecognizerDelegate Protocol
  
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // only allow simultaneous rotate and pinch coming from the same view
        return gestureRecognizer.view == otherGestureRecognizer.view
        
    }
}
