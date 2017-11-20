//
//  UIViewControllerExt.swift
//  goal-post-app
//
//  Created by Jibran Syed on 10/21/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit


extension UIViewController
{
    // Override default transition animations
    
    func presentDetail(_ viewControllerToPresent: UIViewController)
    {
        let transition = CATransition()
        transition.duration = 0.3   // In seconds
        transition.type = kCATransitionPush // Slide over the old view controller like a Navigation Controller
        transition.subtype = kCATransitionFromRight // Slide from the right
        
        // Present next view with animation
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController)
    {
        let transition = CATransition()
        transition.duration = 0.3   // In seconds
        transition.type = kCATransitionPush // Slide over the old view controller like a Navigation Controller
        transition.subtype = kCATransitionFromRight // Slide from the right
        
        // Dismiss this view...
        guard let presentedVC = presentedViewController else { return }
        presentedVC.dismiss(animated: false) {
            // ...then immediately present the next view with animation
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil)
        }
        
    }
    
    
    func dismissDetail()
    {
        let transition = CATransition()
        transition.duration = 0.3   // In seconds
        transition.type = kCATransitionPush // Slide over the old view controller like a Navigation Controller
        transition.subtype = kCATransitionFromLeft // Slide from the left
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }    
}

