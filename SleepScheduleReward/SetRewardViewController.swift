//
//  SetRewardViewController.swift
//  SleepScheduleReward
//
//  Created by Jerry Deska on 10/04/21.
//

import UIKit

protocol SetRewardDelegate {
    func setReward(rewardName: String, rewardPoint: Int, indexToEdit: Int)
}

class SetRewardViewController: UIViewController {
    @IBOutlet weak var rewardNameTextField: UITextField!
    @IBOutlet weak var rewardPointsTextField: UITextField!
    @IBOutlet weak var warningText: UILabel!
    var editedName = ""
    var editedPoint = 0
    var indexToEdit = -1
    var delegate: SetRewardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Set Reward"
        if editedName != "" {
            rewardNameTextField.text = editedName
            rewardPointsTextField.text = String(editedPoint)
        }
    }
    
    @IBAction func setRewardClicked(_ sender: Any) {
        if rewardNameTextField.text == "" || rewardPointsTextField.text == "" {
            warningText.text = "Field cannot be empty!"
        } else {
            let rewardName = rewardNameTextField.text!
            let rewardPoints = Int(rewardPointsTextField.text!)!
            delegate?.setReward(rewardName: rewardName, rewardPoint: rewardPoints, indexToEdit: indexToEdit)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
