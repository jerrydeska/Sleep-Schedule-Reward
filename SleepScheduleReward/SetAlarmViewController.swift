//
//  SetAlarmViewController.swift
//  SleepScheduleReward
//
//  Created by Jerry Deska on 10/04/21.
//

import UIKit

protocol SetTimePickedDelegate {
    func setTimePicked(indexToEdit: Int, timePickedComplete: Date)
}

class SetAlarmViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    var nameString = ""
    var timePicked: Date?
    var timePickedString = ""
    var delegate: SetTimePickedDelegate?
    var indexToEdit = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Set Alarm"
        nameLabel.text = nameString
    }

    @IBAction func doneClicked(_ sender: Any) {
        timePicked = timePicker.date
        delegate?.setTimePicked(indexToEdit: self.indexToEdit, timePickedComplete: timePicked!)
    }
}
