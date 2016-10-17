//
//  TransitionAnimator.swift
//  TransitionTest
//
//  Created by Jackie Zhang on 16/9/30.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit


class TransitionAnimator :NSObject, UIViewControllerAnimatedTransitioning {
    
    let animateDuration : CGFloat = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(animateDuration)
    }

    //MARK: - main animation logic
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {
            let finalRect = transitionContext.finalFrame(for: toVC)
          //  toVC.view.frame = CGRect(x: finalRect.midX - 5.0, y: finalRect.midY - 5.0, width: 5.0, height: 5.0)
            toVC.view.frame = finalRect.offsetBy(dx: 0, dy: UIScreen.main.bounds.size.height)
         //   toVC.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
         //   toVC.view.transform = CGAffineTransform(rotationAngle: -180.0)
            transitionContext.containerView.addSubview(toVC.view)
            //animation logic
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: {
                   // toVC.view.transform = CGAffineTransform.identity
                    toVC.view.frame = finalRect
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
                 
            })
            
        }
        
        
    }
}
