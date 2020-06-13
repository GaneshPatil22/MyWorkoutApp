//
//  UserTimerModel.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/10/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import Foundation
import RealmSwift

class UserTimerModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = DEFAULT_USER_TIMER_TITLE
    @objc dynamic var workoutDuration = DEFAULT_USER_WORKOUT_DURATION
    @objc dynamic var restDuration = DEFAULT_USER_REST_DURATION
    @objc dynamic var totalNoOfExercise = DEFAULT_USER_EXERCISE_COUNT
    @objc dynamic var restBetweenEachSet = DEFAULT_USER_RBS_DURATION
    @objc dynamic var noOfSet = DEFAULT_USER_SET_COUNT

     func IncrementaID() -> Int{
         let realm = try! Realm()
         if let retNext = realm.objects(UserTimerModel.self).sorted(byKeyPath: "id").last?.id {
             return retNext + 1
         }else{
             return 1
         }
     }
}
