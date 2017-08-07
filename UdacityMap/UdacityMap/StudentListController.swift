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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNavigationItem.titleView = getCustomTitle()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        logOutUser(navigationController: navigationController)
    }

    @IBAction func refreshAction(_ sender: Any) {
    }
}

extension StudentListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.studentCell) as! StudentCell
        cell.studentNameLabel.text = studentsList[indexPath.row].fullName
        cell.separatorInset.left = 30 + cell.iconImage.bounds.size.width
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        launchSafari(studentsURL: studentsList[indexPath.row].mediaURL, studentsFullName: studentsList[indexPath.row].fullName, navigationController: navigationController)
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
}
