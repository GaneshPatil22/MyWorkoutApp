//
//  WatchViewController.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/10/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit
import RealmSwift

class WatchViewController: UIViewController {

    @IBOutlet weak var userTimerTableView: UITableView!

    let userTimerIdentifier: String = "UserTimerTableViewCell"

    let realm = try! Realm()
    lazy var userTimers: Results<UserTimerModel> = { self.realm.objects(UserTimerModel.self) }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Watch view did load")
        view.backgroundColor = .blue

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTimerClock))

        userTimerTableView.delegate = self
        userTimerTableView.dataSource = self
        userTimerTableView.register(UINib(nibName: userTimerIdentifier, bundle: nil), forCellReuseIdentifier: userTimerIdentifier)
        userTimerTableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userTimerTableView.reloadDataWithText(noDataText: NO_HIT_TIMER_PRESENT)
    }

    @objc func addTimerClock() {
        let vc = AddNewTimerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func removeUserTimer(id: Int) {

        do {
            let realm = try Realm()

            let object = realm.objects(UserTimerModel.self).filter("id = %@", id).first

            try! realm.write {
                if let obj = object {
                    realm.delete(obj)
                    print(userTimers)
                    userTimerTableView.reloadDataWithText(noDataText: NO_HIT_TIMER_PRESENT)
                }
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
}

extension WatchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.userTimerIdentifier, for: indexPath) as! UserTimerTableViewCell
        cell.setUpView(model: userTimers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StopWatchViewController()
        vc.model = userTimers[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete action ...")
            self.removeUserTimer(id: self.userTimers[indexPath.row].id)
            success(true)
        })
        deleteAction.image = UIImage(named: "hammer")
        deleteAction.backgroundColor = .red
    
        return UISwipeActionsConfiguration(actions: [modifyAction, deleteAction])
    }
}
