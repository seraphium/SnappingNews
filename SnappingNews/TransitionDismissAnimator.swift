//
//  TransitionAnimator.swift
//  TransitionTest
//
//  Created by Jackie Zhang on 16/9/30.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit


class TransitionDismissAnimator :NSObject, UIViewControllerAnimatedTransitioning {
    
    let animateDuration : CGFloat = 1.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(animateDuration)
    }

    //MARK: - main animation logic
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = transitionContext.viewController(forKey:UITransitionContextViewControllerKey.from)
        {
            let initRect = transitionContext.initialFrame(for: fromVC)
            let finalRect = initRect.offsetBy(dx: 0, dy: UIScreen.main.bounds.size.height)
            
            transitionContext.containerView.addSubview(toVC.view)
            transitionContext.containerView.sendSubview(toBack: toVC.view)
            
            //animation logic
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: {
                    fromVC.view.frame = finalRect
                
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
                 
            })
            
        }
        
        
    }
}
