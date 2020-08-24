//
//  ViewController.swift
//  Since
//
//  Created by Alok Karnik on 02/01/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!

    var activityData: [Activity]?
    var storageController = ActivityStorageController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        activityData = storageController.getAllActivities()
        addButton.backgroundColor = UIColor.hexColour(hexValue: 0xEEB357, alpha: 1)
        addButton.titleLabel?.textColor = UIColor.hexColour(hexValue: 0xE9ECEE, alpha: 1)

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateDateForActivity), name: NSNotification.Name(rawValue: "datePicked"), object: nil)

        nc.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: addButton.frame.height + 30, right: 0)
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.clipsToBounds = true
        addButton.titleLabel?.textAlignment = .center
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
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
            self.showDatePicker(forActivity: activity)
        }))

        activityAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(activityAlertController, animated: true, completion: nil)
    }

    @objc func updateDateForActivity(notification: NSNotification) {
        let userInfo: [String: String] = notification.userInfo as! [String: String]
        if let id = userInfo["id"], let date = userInfo["date"]?.toDate() {
            if let activity = storageController.getActivity(withID: Int(id)!) {
                updateDateOccuredForAction(date: date, activity: activity)
            }
        }
    }

    func updateDateOccuredForAction(date: Date, activity: Activity) {
        storageController.update(activity: activity, date: date)
    }

    func showDatePicker(forActivity: Activity) {
        let datePickerVC = storyboard?.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerViewController
        datePickerVC.activity = forActivity
        present(datePickerVC, animated: true, completion: nil)
    }

    @objc func refresh() {
        activityData = storageController.getAllActivities()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SinceCell") as! TableViewCell
        cell.setSelected(false, animated: true)
        if let activity = activityData?[indexPath.row] {
            cell.activityLabel.text = activity.title
            cell.sinceLabel.text = String(activity.daysSinceLastOccurence)
        }

        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let allActivities = activityData else {
            return 0
        }
        return allActivities.count
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let activity = activityData?[indexPath.row] {
            showDatePickerAlertController(activity: activity)
        }
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let activity = activityData?[indexPath.row] {
            let alert = UIAlertController(title: "Delete activity", message: "This action cannot be reversed", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                self.delete(uiAlertAction: action, activity: activity)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
        }
    }

    func delete(uiAlertAction _: UIAlertAction, activity: Activity) {
        storageController.delete(activity: activity)
    }
}
