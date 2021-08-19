//
//  ViewController.swift
//  SleepScheduleReward
//
//  Created by Jerry Deska on 08/04/21.
//

import UserNotifications
import UIKit

// create struct alarm
struct Alarm {
    var alarmName:String
    var alarmTime:Date
    
    init(alarmName: String, alarmTime: Date) {
        self.alarmName = alarmName
        self.alarmTime = alarmTime
    }
}

// create struct reward
struct Reward {
    var rewardName:String
    var rewardPoint:Int
    
    init(rewardName: String, rewardPoint: Int) {
        self.rewardName = rewardName
        self.rewardPoint = rewardPoint
    }
}

// create custom redeemButton so it can contain multiple value to pass on later
class RedeemButton: UIButton {
    var rewardName: String = ""
    var rewardPoint: Int = 0
}

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addReward: UIBarButtonItem!
    @IBOutlet weak var setPassword: UIBarButtonItem!
    let myPointsLabel = UILabel()
    var myPoints:Int = 0
    var arrayAlarm:[Alarm] = [Alarm(alarmName: "Wake Up", alarmTime: Date()), Alarm(alarmName: "Sleep", alarmTime: Date())]
    var arrayReward:[Reward] = []
    var password:String?
    var indexToEdit:Int = -1
    var isEdited = false
    let WakeUpSwitch = UISwitch()
    let SleepSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sleep Schedule"
        tableView.delegate = self
        tableView.dataSource = self
        
        // making a label for storing points
        myPointsLabel.text = "My Points: \(myPoints)"
        myPointsLabel.frame = CGRect(x: 16, y: 0, width: view.frame.size.width, height: 20)
        
        // making a view for myPointsLabel
        let tableHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
        tableHeader.addSubview(myPointsLabel)
        
        // insert previous view to table header
        tableView.tableHeaderView = tableHeader
        
        // ask for permission to send notification
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, err) in
            if granted {
                print("Granted")
            }
        }
        
        // setting up default alarm time
        var wakeUpComponents = DateComponents()
        var sleepComponents = DateComponents()
        wakeUpComponents.hour = 6
        sleepComponents.hour = 22
        let wakeUpHour = Calendar.current.date(from: wakeUpComponents)
        let sleepHour = Calendar.current.date(from: sleepComponents)
        arrayAlarm[0].alarmTime = wakeUpHour!
        arrayAlarm[1].alarmTime = sleepHour!
    }
    
    @IBAction func addRewardClicked(_ sender: Any) {
        if isEdited {
            isEdited = false
        }
        goToNextSegue(identifier: "setRewardViewController")
    }
    
    @IBAction func setPasswordClicked(_ sender: Any) {
        if password == nil {
            self.performSegue(withIdentifier: "setPasswordViewController", sender: nil)
        } else {
            // creating alert controller
            let alert = UIAlertController(title: "Password Required", message: "Enter password", preferredStyle: UIAlertController.Style.alert)
            
            // add text field
            alert.addTextField { (fieldPassword) in
                fieldPassword.placeholder = "Password"
                fieldPassword.isSecureTextEntry = true
            }
            
            // add action to alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler: {action in
                if alert.textFields?[0].text == self.password {
                    self.performSegue(withIdentifier: "setPasswordViewController", sender: nil)
                }
            }))
            
            // show alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func goToNextSegue(identifier: String) {
        if password == nil {
            // creating alert controller
            let alert = UIAlertController(title: "Password Required", message: "You need to create a password first.", preferredStyle: UIAlertController.Style.alert)
            
            // add action to alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Set up password", style: UIAlertAction.Style.default, handler: {action in
                self.performSegue(withIdentifier: "setPasswordViewController", sender: nil)
            }))
            
            // show alert
            self.present(alert, animated: true, completion: nil)
        } else {
            // creating alert controller
            let alert = UIAlertController(title: "Password Required", message: "Enter password", preferredStyle: UIAlertController.Style.alert)
            
            // add text field
            alert.addTextField { (fieldPassword) in
                fieldPassword.placeholder = "Password"
                fieldPassword.isSecureTextEntry = true
            }
            
            // add action to alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler: {action in
                if alert.textFields?[0].text == self.password {
                    self.performSegue(withIdentifier: identifier, sender: nil)
                }
            }))
            
            // show alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // prepare data to pass
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setPasswordViewController" {
            let setPasswordVC = segue.destination as! SetPasswordViewController
            setPasswordVC.delegate = self
        } else if segue.identifier == "setAlarmViewController" {
            let setAlarmVC = segue.destination as! SetAlarmViewController
            setAlarmVC.nameString = arrayAlarm[self.indexToEdit].alarmName
            setAlarmVC.indexToEdit = self.indexToEdit
            setAlarmVC.delegate = self
        } else if segue.identifier == "setRewardViewController" {
            let setRewardVC = segue.destination as! SetRewardViewController
            if isEdited {
                setRewardVC.editedName = arrayReward[indexToEdit].rewardName
                setRewardVC.editedPoint = arrayReward[indexToEdit].rewardPoint
            }
            setRewardVC.indexToEdit = self.indexToEdit
            setRewardVC.delegate = self
        }
    }
    
    // do something when notification got clicked
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            myPoints += 100
            myPointsLabel.text = "My Points: \(myPoints)"
        }
        completionHandler()
    }
    
    // show the notification even when the app is opened
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([UNNotificationPresentationOptions.sound, UNNotificationPresentationOptions.banner])
    }
}

extension ViewController: UITableViewDelegate {
    // func if the table cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
        
    }
    
    // func for giving title to header in section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Alarm"
        } else {
            return "Reward"
        }
    }
}

extension ViewController: UITableViewDataSource {
    // set number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // set number of row in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayAlarm.count
        } else {
            return arrayReward.count
        }
    }
    
    // set data that will be displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        // fill cell for each section with data
        if indexPath.section == 0 {
            if arrayAlarm[indexPath.row].alarmName == "Wake Up" {
                cell.textLabel?.text = formatter.string(from: arrayAlarm[indexPath.row].alarmTime)
                cell.detailTextLabel?.text = arrayAlarm[indexPath.row].alarmName
                cell.accessoryView = WakeUpSwitch
                WakeUpSwitch.addTarget(self, action: #selector(wakeUpSwitchClicked(_:)), for: .valueChanged)
            } else {
                cell.textLabel?.text = formatter.string(from: arrayAlarm[indexPath.row].alarmTime)
                cell.detailTextLabel?.text = arrayAlarm[indexPath.row].alarmName
                cell.accessoryView = SleepSwitch
                SleepSwitch.addTarget(self, action: #selector(sleepSwitchClicked(_:)), for: .valueChanged)
            }
        } else {
            cell.textLabel?.text = arrayReward[indexPath.row].rewardName
            cell.detailTextLabel?.text = String(arrayReward[indexPath.row].rewardPoint)
            
            let redeemButton = RedeemButton()
            redeemButton.rewardName = arrayReward[indexPath.row].rewardName
            redeemButton.rewardPoint = arrayReward[indexPath.row].rewardPoint
            redeemButton.frame = CGRect(x: 0, y: 0, width: 70, height: 50)
            redeemButton.setTitle("Redeem", for: .normal)
            redeemButton.setTitleColor(.systemBlue, for: .normal)
            redeemButton.addTarget(self, action: #selector(redeemButtonClicked(_:)), for: .touchUpInside)
            cell.accessoryView = redeemButton
        }
        
        return cell
    }
    
    // func when wake up switch is clicked
    @objc func wakeUpSwitchClicked(_ sender: UISwitch) {
        if sender.isOn {
            print("Wake Up ON")
            // get current notification center
            let center = UNUserNotificationCenter.current()

            // set notification content
            let content = UNMutableNotificationContent()
            content.title = "Alarm"
            content.body = "Time to Wake Up"
            content.sound = .default

            // set trigger for notification
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.arrayAlarm[0].alarmTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // make notification request and add it to notification center
            let request = UNNotificationRequest(identifier: "Wake Up", content: content, trigger: trigger)
            center.add(request)

        } else {
            print("Wake Up OFF")
            let center = UNUserNotificationCenter.current()
            
            // remove pending notification with specific identifier
            center.removePendingNotificationRequests(withIdentifiers: ["Wake Up"])
        }
    }
    
    // func when sleep switch is clicked
    @objc func sleepSwitchClicked(_ sender: UISwitch) {
        if sender.isOn {
            print("Sleep ON")
            let center = UNUserNotificationCenter.current()

            let content = UNMutableNotificationContent()
            content.title = "Alarm"
            content.body = "Time to Sleep"
            content.sound = .default

            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.arrayAlarm[1].alarmTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "Sleep", content: content, trigger: trigger)

            center.add(request)
        } else {
            print("Sleep OFF")
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ["Sleep"])
        }
    }
    
    // func when redeem button is clicked
    @objc func redeemButtonClicked(_ sender: RedeemButton) {
        print(myPoints)
        if sender.rewardPoint <= myPoints {
            // creating alert controller
            let alert = UIAlertController(title: "Password Required", message: "Enter password", preferredStyle: UIAlertController.Style.alert)
            
            alert.addTextField { (fieldPassword) in
                fieldPassword.placeholder = "Password"
                fieldPassword.isSecureTextEntry = true
            }
            
            // add action to alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler: {action in
                if alert.textFields?[0].text == self.password {
                    self.myPoints -= sender.rewardPoint
                    self.myPointsLabel.text = "My Points: \(self.myPoints)"
                    alert.dismiss(animated: true, completion: nil)
                    self.redeemSuccessful(rewardName: sender.rewardName, rewardPoint: sender.rewardPoint)
                }
            }))
            
            // show alert
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Not Enough Points", message: "You don't have enough points to get this reward", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func redeemSuccessful(rewardName: String, rewardPoint: Int) {
        let alert = UIAlertController(title: "Redeem Successful!", message: "\"\(rewardName)\" for \(rewardPoint) points has been redeemed successfuly!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // func when tableView swiped at the end, depends on reading direction
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // make edit button
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            if indexPath.section == 0 {
                self.indexToEdit = indexPath.row
                self.goToNextSegue(identifier: "setAlarmViewController")
            } else {
                self.isEdited = true
                self.indexToEdit = indexPath.row
                self.goToNextSegue(identifier: "setRewardViewController")
            }
            // reset slide state
            actionPerformed(true)
        }
        
        //make delete button
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            if self.password == nil {
                // creating alert controller
                let alert = UIAlertController(title: "Password Required", message: "You need to create a password first.", preferredStyle: UIAlertController.Style.alert)
                
                // add action to alert
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Set up password", style: UIAlertAction.Style.default, handler: {action in
                    self.performSegue(withIdentifier: "setPasswordViewController", sender: nil)
                }))
                
                // show alert
                self.present(alert, animated: true, completion: nil)
            } else {
                // creating alert controller
                let alert = UIAlertController(title: "Password Required", message: "Enter password", preferredStyle: UIAlertController.Style.alert)
                
                // add text field
                alert.addTextField { (fieldPassword) in
                    fieldPassword.placeholder = "Password"
                    fieldPassword.isSecureTextEntry = true
                }
                
                // add action to alert
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler: {action in
                    if alert.textFields?[0].text == self.password {
                        self.arrayReward.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                }))
                
                // show alert
                self.present(alert, animated: true, completion: nil)
            }
            actionPerformed(true)
        }
        
        // set the swipe action configuration
        if indexPath.section == 0 {
            return UISwipeActionsConfiguration(actions: [edit])
        } else {
            return UISwipeActionsConfiguration(actions: [edit, delete])
        }
    }
}

extension ViewController: SetPasswordDelegate {
    func setPassword(password: String) {
        self.navigationController?.popToRootViewController(animated: true)
        self.password = password
        
        // creating alert controller
        let alert = UIAlertController(title: "Password Set!", message: "Password has successfully been set!", preferredStyle: UIAlertController.Style.alert)
        
        // add action to alert
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: SetTimePickedDelegate {
    func setTimePicked(indexToEdit: Int, timePickedComplete: Date) {
        self.arrayAlarm[indexToEdit].alarmTime = timePickedComplete
        // reload table view data so the data in table view gets updated
        self.tableView.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
        if indexToEdit == 0 {
            self.WakeUpSwitch.setOn(false, animated: true)
        } else {
            self.SleepSwitch.setOn(false, animated: true)
        }
        self.indexToEdit = -1
    }
}

extension ViewController: SetRewardDelegate {
    func setReward(rewardName: String, rewardPoint: Int, indexToEdit: Int) {
        if isEdited {
            self.arrayReward[indexToEdit].rewardName = rewardName
            self.arrayReward[indexToEdit].rewardPoint = rewardPoint
            self.indexToEdit = -1
            self.isEdited = false
        } else {
            self.arrayReward.append(Reward(rewardName: rewardName, rewardPoint: rewardPoint))
        }
        self.tableView.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
    }
}
