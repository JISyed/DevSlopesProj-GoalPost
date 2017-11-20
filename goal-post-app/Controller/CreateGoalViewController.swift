//
//  CreateGoalViewController.swift
//  goal-post-app
//
//  Created by Jibran Syed on 10/21/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class CreateGoalViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var textViewNewGoal: UITextView!
    @IBOutlet weak var btnShortTerm: UIButton!
    @IBOutlet weak var btnLongTerm: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    
    private(set) public var goalType: GoalType = .shortTerm
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnNext.bindToKeyboard()   // Will move up with keyboard
        self.textViewNewGoal.delegate = self
        
        
        self.setGoalType(newGoalType: .shortTerm)
    }
    
    
    
    
    func setGoalType(newGoalType: GoalType)
    {
        self.goalType = newGoalType
        
        switch self.goalType 
        {
        case .longTerm:
            self.btnLongTerm.setSelectedColor()
            self.btnShortTerm.setDeselectedColor()
            break
        case .shortTerm:
            self.btnShortTerm.setSelectedColor()
            self.btnLongTerm.setDeselectedColor()
            break
        }
    }
    

    @IBAction func onNextBenPressed(_ sender: Any) 
    {
        if textViewNewGoal.text != "" && textViewNewGoal.text != "What is your goal?"
        {
            guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: STYBD_ID_FINISH_GOAL_VC) as? FinishGoalViewController else {return}
            
            finishGoalVC.initData(description: self.textViewNewGoal.text!, type: self.goalType)
            
            //presentDetail(finishGoalVC)
            presentingViewController?.presentSecondaryDetail(finishGoalVC)  // Dismiss this VC and present the new VC at the same time
        }
    }
    
    @IBAction func onShortTermBtnPressed(_ sender: Any) 
    {
        self.setGoalType(newGoalType: .shortTerm)
    }
    
    @IBAction func onLongTermBtnPressed(_ sender: Any) 
    {
        self.setGoalType(newGoalType: .longTerm)
    }
    
    
    @IBAction func onBackBtnPressed(_ sender: Any) 
    {
        dismissDetail()
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textViewNewGoal.text = ""
        self.textViewNewGoal.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    
}
