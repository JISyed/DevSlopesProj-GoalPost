//
//  GoalData.swift
//  goal-post-app
//
//  Created by Jibran Syed on 10/22/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation
import CoreData

class GoalData 
{
    var completionValue: Int32
    var progress: Int32
    var description: String?
    var type: String?
    
    init() 
    {
        self.completionValue = Int32(0)
        self.progress = Int32(0)
    }
    
    init(fromGoalEntity entity: Goal)
    {
        self.completionValue = entity.goalCompletionValue
        self.progress = entity.goalProgress
        self.description = entity.goalDescription
        self.type = entity.goalType
    }
    
    
    func setGoalEntity(goalToSet: inout Goal) 
    {
        goalToSet.goalCompletionValue = self.completionValue
        goalToSet.goalProgress = self.progress
        goalToSet.goalDescription = self.description
        goalToSet.goalType = self.type
        
    }
    
}
