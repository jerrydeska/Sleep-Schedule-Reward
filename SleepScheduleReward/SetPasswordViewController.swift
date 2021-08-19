//
//  SetPasswordViewController.swift
//  SleepScheduleReward
//
//  Created by Jerry Deska on 09/04/21.
//

import UIKit

protocol SetPasswordDelegate {
    func setPassword(password: String)
}

class SetPasswordViewController: UIViewController {
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordRe: UITextField!
    @IBOutlet weak var warningText: UILabel!
    var delegate: SetPasswordDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Set Password"
    }
    
    @IBAction func setNewPassClicked(_ sender: Any) {
        if newPassword.text != newPasswordRe.text {
            warningText.text = "Password do not match!"
        } else if newPassword.text == "" || newPasswordRe.text == "" {
            warningText.text = "Field cannot be empty!"
        } else {
            delegate?.setPassword(password: newPassword.text!)
        }
    }
    
}
