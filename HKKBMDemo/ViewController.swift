//
//  ViewController.swift
//  HKKBMDemo
//
//  Created by Harrison Kong on 1/11/20.
//  Copyright © 2020 skyRoute66. All rights reserved.
//

import UIKit
import AVFoundation

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

    @IBOutlet weak var boat: UIImageView!
    @IBOutlet weak var boatBox: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    
//    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
//    @IBOutlet weak var pinchGestureRecognizer: UIPinchGestureRecognizer!
//    @IBOutlet weak var rotationGestureRecognizer: UIRotationGestureRecognizer!
    
    // MARK: - IB Actions
    // MARK: -
    
    @IBAction func deviceRotationToggled(_ sender: UISwitch) {
        kbManager?.dismissDuringDeviceRotation = sender.isOn
        
        if !sender.isOn && !segueSwitch.isOn {
            segueSwitch.isOn = true
        }
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
        }
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
//        zRecognizer.require(toFail: pinchGestureRecognizer)
//        zRecognizer.require(toFail: rotationGestureRecognizer)
//        tapGestureRecognizer.require(toFail: zRecognizer)
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
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        kbManager?.viewWillTransition()
    }
    
    // MARK: - Overridden Methods
    // MARK: -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    private func makeAudioPlayer(resourceName: String) -> AVAudioPlayer {
        let url = Bundle.main.url(forResource: resourceName, withExtension: "mp3")
        var player = AVAudioPlayer()
        do {
            try player = AVAudioPlayer(contentsOf: url!)
            player.prepareToPlay()
        } catch {
            print("Unable to load audio resource \(url!): \(error.localizedDescription)")
        }
        return player
    }
}

