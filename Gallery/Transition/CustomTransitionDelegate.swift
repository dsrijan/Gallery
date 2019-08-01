//
//  CustomTransitionDelegate.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        print("presenting")
        let presenting = PresentingTransitionAnimator()
        return presenting
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("dismissing")
        let dismissing = DismissTransitionAnimator()
        return dismissing
        
    }
    
}
