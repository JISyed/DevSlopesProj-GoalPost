//
//  FinishGoalViewController.swift
//  goal-post-app
//
//  Created by Jibran Syed on 10/21/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var btnCreateGoal: UIButton!
    @IBOutlet weak var textFieldPoints: UITextField!
    
    
    var goalDesciption: String!
    var goalType: GoalType!
    
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.btnCreateGoal.bindToKeyboard()
        textFieldPoints.delegate = self
    }
    
    
    
    func initData(description: String, type: GoalType)
    {
        self.goalDesciption = description
        self.goalType = type
    }
    
    
    
    
    func save(onComplete: @escaping CompletionHandler)
    {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            debugPrint("ERROR: Could not get appDelegate reference!")
            onComplete(false)
            return 
        }
        
        // Create Goal from Core Data, and pass in the Managed Object Context
        let goal = Goal(context: managedContext)
        goal.goalDescription = goalDesciption
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(textFieldPoints.text!)!
        goal.goalProgress = Int32(0)
        
        // Pass this object into persistent storage
        do 
        {
            try managedContext.save()
            print("Successfully saved new goal!")
            onComplete(true)
        }
        catch
        {
            debugPrint("Could not save: \(error.localizedDescription)")
            onComplete(false)
        }
    }
    
    
    
    
    @IBAction func onCreateGoalBtnPressed(_ sender: Any) 
    {
        // Pass data into Core Data Goal model
        
        // But only if the user defined the number of points to reach goal
        if textFieldPoints.text != ""
        {
            self.save { (success) in
                if success
                {
                    self.dismiss(animated: true, completion: nil)    // Dismiss to main VC (GoalsVC)
                }
            }
        }
    }
    
    
    @IBAction func onBackBtnPressed(_ sender: Any) 
    {
        dismissDetail()
    }
    
    
    
    
}
