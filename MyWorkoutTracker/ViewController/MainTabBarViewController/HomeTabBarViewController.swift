//
//  HomeTabBarViewController.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/10/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
        setUpTabs()
//        defaultSetUp()
    }
    
    func setUpTabs() {
        let watchVC = WatchViewController()
        watchVC.title = "Watch"
        watchVC.tabBarItem = UITabBarItem(title: "Watch", image: nil, selectedImage: nil)
        
        let workoutVC = WorkoutViewController()
        workoutVC.title = "Workout"
        workoutVC.tabBarItem = UITabBarItem(title: "Workout", image: nil, selectedImage: nil)
        
        let controllers = [workoutVC, watchVC]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
    
    func defaultSetUp() {
        selectedIndex = 0
    }

}
