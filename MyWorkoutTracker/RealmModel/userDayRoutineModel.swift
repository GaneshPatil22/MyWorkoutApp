//
//  userDayRoutineModel.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/12/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import Foundation
import RealmSwift

class UserDayRoutineModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var isWorkoutDay: Int = -1
    @objc dynamic var userWorkoutPlanId: Int = -1
    
    func IncrementaID() -> Int {
        let realm = try! Realm()
        if let retNext = realm.objects(UserDayRoutineModel.self).sorted(byKeyPath: "id").last?.id {
            return retNext + 1
        } else {
            return 1
        }
    }
    
}
