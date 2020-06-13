//
//  AddNewTimerViewController.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/10/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewTimerViewController: UIViewController {
    let realm = try! Realm()

    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var workoutDurationTextView: UITextField!
    @IBOutlet weak var restDurationTextView: UITextField!
    @IBOutlet weak var noOfExerciseTextView: UITextField!
    @IBOutlet weak var restBetweenSetTextView: UITextField!
    @IBOutlet weak var noOfSetTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Timer"
        view.backgroundColor = .purple

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUserTimer))
    }

    @objc func saveUserTimer() {
        let userTimer = UserTimerModel()
        userTimer.title = ((titleTextView.text ?? "") == "") ? DEFAULT_USER_TIMER_TITLE : titleTextView.text!
        userTimer.id = userTimer.IncrementaID()
        userTimer.workoutDuration = Int(workoutDurationTextView.text ?? "45") ?? DEFAULT_USER_WORKOUT_DURATION
        userTimer.restDuration = Int(restDurationTextView.text ?? "15") ?? DEFAULT_USER_REST_DURATION
        userTimer.totalNoOfExercise = Int(noOfExerciseTextView.text ?? "10") ?? DEFAULT_USER_EXERCISE_COUNT
        userTimer.restBetweenEachSet = Int(restBetweenSetTextView.text ?? "60") ?? DEFAULT_USER_RBS_DURATION
        userTimer.noOfSet = Int(noOfSetTextView.text ?? "1") ?? DEFAULT_USER_SET_COUNT

        try! realm.write() {
            realm.add(userTimer)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
