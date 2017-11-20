//
//  UIButtonExt.swift
//  goal-post-app
//
//  Created by Jibran Syed on 10/21/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

extension UIButton
{
    func setSelectedColor()
    {
        self.backgroundColor = #colorLiteral(red: 0.3334308586, green: 0.7722371817, blue: 0.2873804979, alpha: 1)
    }
    
    
    func setDeselectedColor()
    {
        self.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.8666666667, blue: 0.6862745098, alpha: 1)
    }
}

