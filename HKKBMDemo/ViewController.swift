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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = .red
        scrollView.backgroundColor = .green

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("viewWillLayoutSubviews(): containerView.contentMinBox is \(scrollView.contentMinBox())")
        
        if heightConstraint != nil {
          heightConstraint?.constant = containerView.contentMinBox().height + 20
        }
        else {
          containerView.translatesAutoresizingMaskIntoConstraints = false
          heightConstraint = containerView.heightAnchor.constraint(equalToConstant: containerView.contentMinBox().height + 20)
            
          heightConstraint?.isActive = true
        }
        
//        scrollView.contentSize.height = scrollView.contentMinBox().height + 150

    }
}

