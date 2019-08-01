//
//  PresentingTransitionAnimator.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class PresentingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // This method can called only in case of interactive transitions
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = self.transitionDuration(using: transitionContext)
      
        let snapshotView = toViewController.view.resizableSnapshotView(from: toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        snapshotView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        snapshotView?.center = fromViewController.view.center
        containerView.addSubview(snapshotView!)
        
        // hide the detail view until the snapshot is being animated
        toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0, options: [],
                       animations: { () -> Void in
                        snapshotView?.transform = CGAffineTransform.identity
        }, completion: { (finished) -> Void in
            snapshotView?.removeFromSuperview()
            toViewController.view.alpha = 1.0
            transitionContext.completeTransition(finished)
        })
    }
    
}

