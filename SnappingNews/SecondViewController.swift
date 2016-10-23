//
//  SecondViewController.swift
//  TransitionTest
//
//  Created by Jackie Zhang on 16/9/29.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

class SecondViewController : UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var webView: UIWebView!
    
    var panTransition : UIPercentDrivenInteractiveTransition?
    let transitionAnimator = TransitionAnimator()
    let dismissAnimator = TransitionDismissAnimator()
    
    var news : NewsItem?
    
    override func awakeFromNib() {
        self.transitioningDelegate = self
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.view.backgroundColor = UIColor.white
       // self.titleLabel.backgroundColor = UIColor.lightGray
       // self.titleLabel.alpha = 0.4
        
    }
    override func viewDidLoad()  {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(gesture:)))
        
        self.view.addGestureRecognizer(panGesture)
        self.view.layer.masksToBounds = true
        
        self.imageView.layer.zPosition = -1000
        
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all

            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNews()

    }

    func panGestureAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
      
        switch (gesture.state) {
        case .began:
            if abs(translation.x) > abs(translation.y) || translation.y < 0 {
                return
            }
            panTransition = UIPercentDrivenInteractiveTransition()
            self.dismiss(animated: true, completion: nil)
        case .changed :
            let percent = translation.y / 600 <= 1 ? (translation.y / 600) : 1
            panTransition?.update(percent)
        case .cancelled:
            panTransition?.cancel()
            panTransition = nil
        case .ended:
            panTransition?.finish()
            panTransition = nil
        default:
            panTransition?.finish()
        }
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissAnimator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        return self.panTransition
    }

    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
    
    @IBAction func dismissClicked(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
       //MARK: - main logic
    func initNews() {
        if let loadedNews = self.news {
            
            let url = URL(string: loadedNews.thumbnail_pic_s!)!
          //  self.titleLabel.text = loadedNews.title
            self.imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            
            if let webUrl = loadedNews.url {
                let request = URLRequest(url: URL(string: webUrl)!)
                self.webView.loadRequest(request)
            }
            
        }
        
   
    }
}

//MARK: - extension Customized CALayer corner radius
extension CALayer {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}
