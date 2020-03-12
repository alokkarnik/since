//
//  ViewController.swift
//  Since
//
//  Created by Alok Karnik on 02/01/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    var activityData: [Activity]? = nil
    var storageController = ActivityStorageController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)

        activityData = storageController.getAllActivities()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: addButton.bounds.height + 50))
        addButton.layer.cornerRadius = addButton.bounds.size.width/2
        addButton.clipsToBounds = true
        addButton.titleLabel?.textAlignment = .center
    }
    
    func reloadData() {
        activityData = storageController.getAllActivities()
        tableView.reloadData()
    }
    
    func showDatePickerAlertController(activity: Activity) {
        let activityAlertController = UIAlertController(title: "Select date", message: nil, preferredStyle: .actionSheet)
        
        activityAlertController.addAction(UIAlertAction(title: "Today", style: .default, handler: { _ in
            self.updateDateOccuredForAction(date: Date(), activity: activity)
        }))
        
        activityAlertController.addAction(UIAlertAction(title: "Custom", style: .default, handler: { _ in
            // Open calendar
        }))
        
        activityAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(activityAlertController, animated: true, completion: nil)
    }
    
    func updateDateOccuredForAction(date: Date, activity: Activity) {
        storageController.update(activity: activity, date: date)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SinceCell") as! TableViewCell
        
        if let activity = activityData?[indexPath.row] {
            cell.activityLabel.text = activity.title
            cell.sinceLabel.text = String(activity.daysSinceLastOccurence) + " days"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let allActivities = activityData else {
            return 0
        }
        return allActivities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let activity = activityData?[indexPath.row] {
            showDatePickerAlertController(activity: activity)
        }
    }
}

