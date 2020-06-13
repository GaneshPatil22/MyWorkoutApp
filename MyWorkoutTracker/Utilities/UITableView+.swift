//
//  UITableView+.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/12/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit
extension UITableView {

    func reloadDataWithText(noDataText: String = "No Data Available") {
        self.reloadData()

        if self.numberOfSections > 0 {
            showNoDataExistLabel(labelText: noDataText)
            for section in 0..<self.numberOfSections {
                if self.numberOfRows(inSection: section) > 0 {
                    hideNoDataExistLabel()
                    return
                }
            }
        } else {
            showNoDataExistLabel(labelText: noDataText)
        }
    }
    
    func showNoDataExistLabel(labelText: String) {
        if self.viewWithTag(1111) == nil {
            let noDataLabel = UILabel()
            noDataLabel.textAlignment = .center
            noDataLabel.text = labelText
            noDataLabel.textColor = .black
            noDataLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
            noDataLabel.tag = 1111
            noDataLabel.numberOfLines = 0
            noDataLabel.center = self.center
            self.backgroundView = noDataLabel
        }
    }
    
    func hideNoDataExistLabel() {
        if self.viewWithTag(1111) != nil {
            self.backgroundView = nil
        }
    }
}
