//
//  UIViewExt.swift
//  goal-post-app
//
//  Created by Jibran Syed on 10/21/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

extension UIView
{
    func bindToKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    @objc
    func keyboardWillChange(_ notification: NSNotification)
    {
        // Animation data for the Keyboard
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let startingFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endingFrame.origin.y - startingFrame.origin.y
        
        
        // Animate this view in sync with the keyboard animation
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: { 
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
    
    
}
