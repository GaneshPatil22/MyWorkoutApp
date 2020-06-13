//
//  WorkoutViewController.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/10/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutViewController: UIViewController {

    @IBOutlet weak var userWorkoutTableView: UITableView!

    let realm = try! Realm()
    lazy var userWorkoutList: Results<UserWorkoutModuleModel> = {
        print("Calulating user workout list")
        return self.realm.objects(UserWorkoutModuleModel.self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddWorkoutRoutinePopUp))

        userWorkoutTableView.dataSource = self
        userWorkoutTableView.delegate = self
        userWorkoutTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        userWorkoutTableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Workout view will appear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userWorkoutTableView.reloadDataWithText(noDataText: NO_WORKOUT_PLAN_PRESENT)
        print("Workout view did appear")
    }

    @objc func showAddWorkoutRoutinePopUp() {
        let titlePopUp: UIAlertController = UIAlertController(title: "Workout Title", message: nil, preferredStyle: .alert)
        let titleTextView: UITextField = UITextField()
        titleTextView.frame = CGRect(x: 10, y: 50, width: 250, height: 40)
        titleTextView.placeholder = "Title"
        titlePopUp.view.addSubview(titleTextView)

        let height: NSLayoutConstraint = NSLayoutConstraint(item: titlePopUp.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        titlePopUp.view.addConstraint(height)

        let saveQuesAction = UIAlertAction(title: "Save", style: .default){ action in
            if titleTextView.text == "" {
                self.showAddWorkoutRoutinePopUp()
            } else {
                self.saveUserWorkout(title: titleTextView.text ?? "")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        titlePopUp.addAction(saveQuesAction)
        titlePopUp.addAction(cancelAction)

        self.present(titlePopUp, animated: true, completion: nil)
    }

    func saveUserWorkout(title: String) {
        let userWorkout = UserWorkoutModuleModel()
        userWorkout.id = userWorkout.IncrementaID()
        userWorkout.title = title
        
        try! realm.write() {
            realm.add(userWorkout)
            for day in DEFAULT_DAY_ARRAY {
                let dayRoutine = UserDayRoutineModel()
                dayRoutine.id = dayRoutine.IncrementaID()
                dayRoutine.isWorkoutDay = -1
                dayRoutine.title = day
                dayRoutine.userWorkoutPlanId = userWorkout.id
                realm.add(dayRoutine)
            }
            userWorkoutTableView.reloadDataWithText(noDataText: NO_WORKOUT_PLAN_PRESENT)
        }
    }
}

extension WorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userWorkoutList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = userWorkoutList[indexPath.row].title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserWorkoutDetailViewController()
        vc.workoutId = userWorkoutList[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
