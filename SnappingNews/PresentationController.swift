//
//  PresentationController.swift
//  TransitionTest
//
//  Created by Jackie Zhang on 2016/10/5.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class PresentationController : UIPresentationController {
    
    var frameOffsetX : CGFloat = 10

    var frameOffsetY : CGFloat = 100
    
     var bgView: UIView!
     var blurView: UIVisualEffectView!
     var contView : UIView!
    
    weak var transitionCoordinator : UIViewControllerTransitionCoordinator!
    
    override func presentationTransitionWillBegin() {
        bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.white
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = (self.containerView?.bounds)!
        bgView.insertSubview(blurView, at: 0)
        
        self.contView = self.containerView
        self.contView.addSubview(presentingViewController.view)
        self.contView.addSubview(bgView)
        self.contView.addSubview(presentedViewController.view)
        
        self.bgView.alpha = 0.0
        transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator.animate(alongsideTransition: {context in
            
            self.bgView.alpha = 1.0
            self.presentingViewController.view.transform = self.presentingViewController.view.transform.scaledBy(x: 0.9, y: 0.9)
            }, completion: nil)
        
    }
    
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.bgView.removeFromSuperview()
        }
        
    }
    
    override func dismissalTransitionWillBegin() {
        self.transitionCoordinator = self.presentingViewController.transitionCoordinator;
        self.transitionCoordinator.animate(alongsideTransition: { context in
            
            self.bgView.alpha = 0.0
            self.presentingViewController.view.transform = CGAffineTransform.identity
            
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.bgView.removeFromSuperview()
            
        }
        
        UIApplication.shared.keyWindow?.addSubview(presentingViewController.view)
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect  {
        let frame1 :CGRect = (self.containerView?.bounds)!
        let frame2 = CGRect(x: frame1.origin.x + frameOffsetX, y: frame1.origin.y + frameOffsetY, width: frame1.size.width - 2 * frameOffsetX, height: frame1.size.height - 2 * frameOffsetY)
        
        return frame2
    }
    
    override var presentedView: UIView? {
        let view = self.presentedViewController.view
        view?.layer.cornerRadius = 8.0
        
        return view
        
        
    }
}
