//
//  UserWorkoutModuleModel.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/12/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import Foundation
import RealmSwift

class UserWorkoutModuleModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""

    func IncrementaID() -> Int {
        let realm = try! Realm()
        if let retNext = realm.objects(UserWorkoutModuleModel.self).sorted(byKeyPath: "id").last?.id {
            return retNext + 1
        } else {
            return 1
        }
    }
}
