//
//  UserWorkoutDetailViewController.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/12/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit
import RealmSwift

class UserWorkoutDetailViewController: UIViewController {

    @IBOutlet weak var daysTableView: UITableView!
    
    var daysList: Results<UserDayRoutineModel>?
    var workoutId: Int?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        
        daysTableView.dataSource = self
        daysTableView.delegate = self
        daysTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        daysTableView.tableFooterView = UIView()
    }
    
    func setUpData() {
        guard let id = workoutId else { return }
        daysList = realm.objects(UserDayRoutineModel.self).filter("userWorkoutPlanId = %@", id)
    }
    
    func markDay(isWorkoutDay: Int, for id: Int?) {
        if let dayId = id {
            let day = realm.objects(UserDayRoutineModel.self).filter("id = %@", dayId)

            if let workout = day.first {
                try! realm.write {
                    workout.isWorkoutDay = isWorkoutDay
                }
            }
        }
        daysTableView.reloadDataWithText()
    }
}

extension UserWorkoutDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = daysList?[indexPath.row].title ?? ""
        let isWorkoutDay = daysList?[indexPath.row].isWorkoutDay ?? -1
        if isWorkoutDay == -1 {
        } else {
            cell.backgroundColor = isWorkoutDay == 1 ? UIColor.red : UIColor.blue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
         let markAsWorkout = UIContextualAction(style: .normal, title:  "Workout Day", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.markDay(isWorkoutDay: 1, for: self.daysList?[indexPath.row].id)
             success(true)
         })
         markAsWorkout.backgroundColor = .red
     
         return UISwipeActionsConfiguration(actions: [markAsWorkout])
     }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markAsRest = UIContextualAction(style: .normal, title:  "Rest Day", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.markDay(isWorkoutDay: 0, for: self.daysList?[indexPath.row].id)
            success(true)
        })
        markAsRest.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [markAsRest])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isWorkoutDay = daysList?[indexPath.row].isWorkoutDay
        if isWorkoutDay == -1 {
            let alert = UIAlertController(title: "Select Day Type", message: nil, preferredStyle: .alert)
            let workoutAction = UIAlertAction(title: "Workout", style: .cancel) { _ in
                self.markDay(isWorkoutDay: 1, for: self.daysList?[indexPath.row].id)
            }
            let restAction = UIAlertAction(title: "Rest", style: .default) { (_) in
                self.markDay(isWorkoutDay: 0, for: self.daysList?[indexPath.row].id)
            }
            alert.addAction(workoutAction)
            alert.addAction(restAction)
            self.present(alert, animated: true, completion: nil)
        } else if isWorkoutDay == 0 {
            let alert = UIAlertController(title: "Rest Day", message: "Take Good Rest its your rest day...", preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(OkAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            //GoTo Workout plan
            let alert = UIAlertController(title: "In Progress", message: nil, preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(OkAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
