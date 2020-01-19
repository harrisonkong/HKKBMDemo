//
//  SegueTestViewController.swift
//  HKKBMDemo
//
//  Created by Harrison Kong on 1/13/20.
//  Copyright © 2020 skyRoute66. All rights reserved.
//

import UIKit

class SegueTestViewController: UIViewController {
    
    // MARK: - IB Outlets
    // MARK: -
    
    @IBOutlet weak var logoImage: UIImageView!
    
    // MARK: - IB Actions
    // MARK: -
    
    @IBAction func tappedAnywhere(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
