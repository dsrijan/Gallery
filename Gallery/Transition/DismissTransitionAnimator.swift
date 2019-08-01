//
//  DismissTransitionAnimator.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class DismissTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // This method can only called incase of interactive transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.frame, afterScreenUpdates: true, withCapInsets: .zero)
        snapshotView?.center = toViewController.view.center
        containerView.addSubview(snapshotView!)
        
        fromViewController.view.alpha = 0.0
        
        let toViewControllerSnapshotView = toViewController.view.resizableSnapshotView(from: toViewController.view.frame, afterScreenUpdates: true, withCapInsets: .zero)
        containerView.insertSubview(toViewControllerSnapshotView!, belowSubview: snapshotView!)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            snapshotView?.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            snapshotView?.alpha = 0.0
        }) { (finished) -> Void in
            toViewControllerSnapshotView?.removeFromSuperview()
            snapshotView?.removeFromSuperview()
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }    }
}
