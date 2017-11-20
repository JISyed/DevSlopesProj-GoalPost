//
//  GoalCell.swift
//  goal-post-app
//
//  Created by Jibran Syed on 10/21/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell 
{
    @IBOutlet weak var lblGoalDesc: UILabel!
    @IBOutlet weak var lblGoalType: UILabel!
    @IBOutlet weak var lblGoalProgressNumber: UILabel!
    @IBOutlet weak var viewCompletionCover: UIView!
    
    
    
    func configureCell(goal: Goal)
    {
        self.lblGoalDesc.text = goal.goalDescription
        self.lblGoalType.text = goal.goalType
        self.lblGoalProgressNumber.text = String(describing: goal.goalProgress)
        
        if goal.goalProgress == goal.goalCompletionValue
        {
            self.viewCompletionCover.isHidden = false
        }
        else
        {
            self.viewCompletionCover.isHidden = true
        }
    }
    
    
    
}
