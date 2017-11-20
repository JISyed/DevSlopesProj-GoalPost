//
//  GoalsViewController.swift
//  goal-post-app
//
//  Created by Jibran Syed on 10/21/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit
import CoreData

class GoalsViewController: UIViewController 
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightUndoBanner: NSLayoutConstraint!
    
    let defaultHeightUndoBanner : CGFloat = 50.0
    let deltaHeightUndoBannerInSec : TimeInterval = 0.5
    let lifetimeUndoBannerInSec: TimeInterval = 6.0
    
    var goals: [Goal] = []
    var lastDeletedGoal: GoalData?
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.heightUndoBanner.constant = 0.0
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) 
    {
        super.viewWillAppear(animated)
        
        self.fetchGoalsFromCoreData()
        
        tableView.reloadData()
    }
    
    
    
    
    func fetchGoalsFromCoreData()
    {
        self.fetch { (success) in
            if success
            {
                // Are there any goals?
                if self.goals.count >= 1
                {
                    self.tableView.isHidden = false
                }
                else
                {
                    self.tableView.isHidden = true
                }
            }
        }
    }
    
    
    
    
    @IBAction func onAddGoalBtnPressed(_ sender: Any) 
    {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: STYBD_ID_CREATE_GOAL_VC) else {return}
        
        // Hide the undo banner
        self.lastDeletedGoal = nil
        self.heightUndoBanner.constant = 0.0
        
        presentDetail(createGoalVC)
    }
    
    
    
    @IBAction func onUndoRemoveBtnPressed(_ sender: Any) 
    {
        self.recoverDeletedGoal { (success) in
            if success
            {
                print("Undo success!")
                self.fetchGoalsFromCoreData()
                if self.goals.count >= 1
                {
                    self.tableView.isHidden = false
                }
                else
                {
                    self.tableView.isHidden = true
                }
                self.tableView.reloadData()
            }
            else
            {
                print("Undo failed!")
            }
        }
    }
    
    
    

}



// Table code

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int 
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_ID_GOAL_CELL) as? GoalCell else {return UITableViewCell()}
        
        
        let goal = self.goals[indexPath.row]
        cell.configureCell(goal: goal)
        
        return cell
    }
    
    
    // Allows table cells to be editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
    {
        return true
    }
    
    // No edit icons (unswiped)
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle 
    {
        return UITableViewCellEditingStyle.none
    }
    
    // Add swipe actions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? 
    {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchGoalsFromCoreData()   // Reload
            tableView.deleteRows(at: [indexPath], with: .automatic) // automatic animation
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.incrementProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic) // Reload this row only
        }
        addAction.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        
        
        return [deleteAction, addAction]
    }
    
}




// Core Data Loading
extension GoalsViewController
{
    func fetch(onComplete: @escaping CompletionHandler)
    {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            print("ERROR: Could not get appDelegate reference for loading Goals data")
            onComplete(false)
            return
        }
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do
        {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched goals")
            onComplete(true)
        }
        catch
        {
            debugPrint("Could not fetch goal: \(error.localizedDescription)")
            onComplete(false)
        }
    }
    
    
    func removeGoal(atIndexPath indexPath: IndexPath)
    {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            print("ERROR: Could not get appDelegate reference for removing Goals")
            return
        }
        
        
        // Clone goal data and stach it for later
        let undoableGoal = GoalData(fromGoalEntity: self.goals[indexPath.row])
        self.lastDeletedGoal = undoableGoal
        
        
        managedContext.delete(self.goals[indexPath.row])
        
        do
        {
            try managedContext.save()
            print("Successfully removed goal")
            
            // Show undo banner
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: self.deltaHeightUndoBannerInSec, animations: { 
                self.heightUndoBanner.constant = self.defaultHeightUndoBanner
                self.view.layoutIfNeeded()
            })
            
            
            // Schedule a future event to automatically close the undo banner
            Timer.scheduledTimer(withTimeInterval: self.lifetimeUndoBannerInSec, repeats: false, block: { (timer) in
                // Hide the undo banner
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: self.deltaHeightUndoBannerInSec, animations: { 
                    self.heightUndoBanner.constant = 0.0
                    self.view.layoutIfNeeded()
                })
            })
            
        }
        catch
        {
            debugPrint("Could not delete goal: \(error.localizedDescription)")
            print("Failed to removed goal")
            
            // Remove clone becasue deletion failed
            self.lastDeletedGoal = nil
        }
    }
    
    
    func incrementProgress(atIndexPath indexPath: IndexPath)
    {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            print("ERROR: Could not get appDelegate reference for changing Goal progress")
            return
        }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue
        {
            chosenGoal.goalProgress += 1
        }
        else
        {
            return
        }
        
        do
        {
            try managedContext.save()
            print("Sucessfully set progress")   // Remove print statements when submitting to app store
        }
        catch
        {
            debugPrint("Could not set progress \(error.localizedDescription)")
        }
    }
    
    
    
    func recoverDeletedGoal(onComplete: @escaping CompletionHandler)
    {
        guard let goalToRecover = self.lastDeletedGoal else {
            debugPrint("Could not undo deleted goal: There was no deletion to undo!")
            onComplete(false)
            return
        }
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            debugPrint("ERROR: Could not get appDelegate reference! (For goal deletion recovery)")
            onComplete(false)
            return 
        }
        
        
        // Make a new goal and put the recovered goal data into it
        var recoveredGoal = Goal(context: managedContext)
        goalToRecover.setGoalEntity(goalToSet: &recoveredGoal)
        self.lastDeletedGoal = nil
        
        // Pass this object into persistent storage
        do 
        {
            try managedContext.save()
            print("Successfully undone deleted goal!")
            
            // Hide undo banner
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: self.deltaHeightUndoBannerInSec, animations: { 
                self.heightUndoBanner.constant = 0.0
                self.view.layoutIfNeeded()
            })
            
            onComplete(true)
        }
        catch
        {
            debugPrint("Could not undo: \(error.localizedDescription)")
            onComplete(false)
        }
        
    }
    
    
    
    
    
    
    
}










