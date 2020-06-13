//
//  StopWatchViewController.swift
//  MyWorkoutTracker
//
//  Created by MacMini 20 on 6/11/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit
import AVFoundation

class StopWatchViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var startOrRestartButton: UIButton!

    var seconds: Int = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer: Timer?
    var isTimerRunning: Bool = false //This will be used to make sure only one timer is created at a time.

    var model: UserTimerModel?

    // create a sound ID, in this case its the tweet sound.
    var systemSoundID: Int = 999

    enum Status: String {
        case workout = "Workout"
        case rest = "Rest"
        case restInSet = "Rest Between Set"
        case finish = "Congrates"
    }

    var status: Status = .workout
    var exerciseCount: (Int, Int) = (0, 0)
    var setCount: (Int, Int) = (0, 0)
    var statusLabelTitle: String = "Status: "
    var exerciseLabelTitle: String = "Exercise: "
    var setLabelTitle: String = "Set: "

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HIT Timer"
        setUpDefaultValue()
    }
    
    @objc func play() {
        if systemSoundID < 1352 {
            systemSoundID += 1
            print(systemSoundID)
            AudioServicesPlaySystemSound(SystemSoundID(systemSoundID))
        } else {
            print("Done")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    private func setUpDefaultValue() {
        seconds = model?.workoutDuration ?? 60
        exerciseCount = (1, model?.totalNoOfExercise ?? DEFAULT_USER_EXERCISE_COUNT)
        setCount = (1, model?.noOfSet ?? DEFAULT_USER_SET_COUNT)
        setUpView()
    }

    private func setUpView() {
        timeLabel.text = timeString(time: TimeInterval(seconds))
        statusLabel.text = statusLabelTitle + status.rawValue
        exerciseLabel.text = exerciseLabelTitle + "\(exerciseCount.0)/\(exerciseCount.1)"
        setLabel.text = setLabelTitle + "\(setCount.0)/\(setCount.1)"
    }

    @IBAction func startButtonAction(_ sender: Any) {
        startOrRestartButton.isUserInteractionEnabled = false
        startOrRestartButton.alpha = 0.5
        runTimer()
    }

    func runTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }

    @objc func updateTimer() {
        if seconds < 1 {
             updateViewAfterTimerGetsComplete()
             //Send alert to indicate "time's up!"
        } else {
             seconds -= 1
             timeLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func updateViewAfterTimerGetsComplete() {
        if exerciseCount.0 == exerciseCount.1 {
            if setCount.0 + 1 > setCount.1 {
                timer?.invalidate()
                timer = nil
                status = .finish
                setUpView()
            } else {
                seconds = model?.restBetweenEachSet ?? DEFAULT_USER_RBS_DURATION
                exerciseCount.0 = 0
                setCount.0 += 1
                status = .restInSet
                setUpView()
            }
        } else {
            switch status {
            case .rest, .restInSet:
                status = .workout
                seconds = model?.workoutDuration ?? DEFAULT_USER_WORKOUT_DURATION
                exerciseCount.0 += 1
                setUpView()
            case .workout:
                status = .rest
                seconds = model?.restDuration ?? DEFAULT_USER_REST_DURATION
                setUpView()
            case .finish:
                print("sadd")
            }
        }
    }

    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
