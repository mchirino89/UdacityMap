//
//  StudentListController.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 29/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit

class StudentListController: UIViewController {

    @IBOutlet weak var studentListTableView: UITableView!
    @IBOutlet weak var viewNavigationItem: UINavigationItem!
    @IBOutlet weak var waitingVisualEffect: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNavigationItem.titleView = getCustomTitle()
        NotificationCenter.default.addObserver(forName: updateStudentNotification, object: nil, queue: nil, using: studentUpdate)
        setWaitingView(isOn: true, waitingVisualEffect: waitingVisualEffect, view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func studentUpdate(notification: Notification) -> Void {
        guard let userInfo = notification.userInfo,
            let isWaitingOn  = userInfo["isWaitingOn"] as? Bool else {
                print("No userInfo found in notification")
                return
        }
        if isWaitingOn {
            setWaitingView(isOn: true, waitingVisualEffect: waitingVisualEffect, view: view)
        } else {
            studentListTableView.reloadData()
            studentListTableView.reloadSections(IndexSet(integer: 0), with: .middle)
            removeWaitingView(waitingVisualEffect: waitingVisualEffect, view: view)
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        logOutUser(navigationController: navigationController)
    }

    @IBAction func refreshAction(_ sender: Any) {
        NotificationCenter.default.post(name: updateStudentNotification, object: nil, userInfo: nil)
    }
}

extension StudentListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDataSource.sharedInstance.studentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.studentCell) as! StudentCell
        cell.studentNameLabel.text = StudentDataSource.sharedInstance.studentData[indexPath.row].fullName
        if cell.studentNameLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            cell.studentNameLabel.font = UIFont(name: Constants.UIElements.noNameProvidedFont, size: 17)
            cell.studentNameLabel.text = "No name provided"
        } else {
            cell.studentNameLabel.font = UIFont(name: Constants.UIElements.nameProvidedFont, size: 17)
        }
        cell.separatorInset.left = 30 + cell.iconImage.bounds.size.width
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        launchSafari(studentsURL: StudentDataSource.sharedInstance.studentData[indexPath.row].mediaURL, studentsFullName: StudentDataSource.sharedInstance.studentData[indexPath.row].fullName, navigationController: navigationController)
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
}
