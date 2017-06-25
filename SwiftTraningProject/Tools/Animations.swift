//
//  Animations.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/9.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation


let kAnimDuration = 0.3

class Animations: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    //參數宣告
    var transitioningType = FadeTransitioningType.FadeVCTransitioningPresent
    
//TODO: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        self.transitioningType = .FadeVCTransitioningPresent
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        self.transitioningType = .FadeVCTransitioningDismiss
        
        return self
    }

//TODO: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        let duration = kAnimDuration
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        switch self.transitioningType {
        case FadeTransitioningType.FadeVCTransitioningPresent:
            let toViewController = transitionContext.viewController(forKey: .to)
          
            let finalFrame = transitionContext.finalFrame(for: toViewController!)
            
            toViewController!.view.frame = finalFrame
            toViewController!.view.alpha = 0.0
            let containerView = transitionContext.containerView
            containerView.addSubview((toViewController!.view)!)
        
            UIView.animate(withDuration: kAnimDuration, animations: { 
                 toViewController!.view.alpha = 1.0
            }, completion: { (Bool) in
                transitionContext.completeTransition(true)
            })
            
            break
        case FadeTransitioningType.FadeVCTransitioningDismiss:
            let fromViewController = transitionContext.viewController(forKey: .from)
            
            UIView.animate(withDuration: kAnimDuration, animations: { 
                 fromViewController!.view.alpha = 0.0
            }, completion: { (Bool) in
                fromViewController!.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
            
            break
        }
    }
}
