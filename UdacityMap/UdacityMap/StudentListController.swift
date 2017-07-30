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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
    }

    @IBAction func refreshAction(_ sender: Any) {
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
    }
}

extension StudentListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Networking.Variables.studentCell) as! StudentCell
        cell.studentNameLabel.text = "Student \(indexPath.row + 1)"
        return cell
    }
    
}
