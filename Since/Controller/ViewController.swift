//
//  ViewController.swift
//  Since
//
//  Created by Alok Karnik on 02/01/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var activityData: [Activity]? = nil
    var storageController = ActivityStorageController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false

        activityData = storageController.getAllActivities()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView = UIView()
    }

}


extension  ViewController {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SinceCell") as! TableViewCell
        
        if let activity = activityData?[indexPath.row] {
            cell.activityLabel.text = activity.title
            cell.sinceLabel.text = String(activity.daysSinceLastDone) + " days"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let allActivities = activityData else {
            return 0
        }
        
        return allActivities.count
    }
    
    @IBAction func add(_ sender: Any) {
        storageController.insertActivity(activityTitle: "someActivity \(activityData?.count ?? 0)")
        activityData = storageController.getAllActivities()

        tableView.reloadData()
    }

}
