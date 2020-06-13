//
//  UserTimerTableViewCell.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/11/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit

class UserTimerTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpView(model: UserTimerModel) {
        titleLabel.text = model.title
        descriptionLabel.text = "WD: \(model.workoutDuration) RD: \(model.restDuration) \n NOE: \(model.totalNoOfExercise) RBS: \(model.restBetweenEachSet) NOS: \(model.noOfSet)"
    }
    
}
