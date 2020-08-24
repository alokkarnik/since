//
//  ActivityDetailViewController.swift
//  Since
//
//  Created by Alok Karnik on 20/08/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    @IBOutlet var tableViewContainer: UIView!
    private var activity: Activity!

    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var occurrenceTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewContainer.layer.cornerRadius = 30
        tableViewContainer.clipsToBounds = true
        tableViewContainer.layer.shadowOffset = .zero
        tableViewContainer.layer.shadowRadius = 10
        tableViewContainer.layer.shadowColor = UIColor.black.cgColor
        tableViewContainer.layer.shadowOpacity = 1
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.hexColour(hexValue: 0xEEB357, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .black

        daysLabel.text = "\(activity.daysSinceLastOccurence)"
        activityLabel.text = activity.title
        occurrenceTableView.delegate = self
        occurrenceTableView.dataSource = self

        occurrenceTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        occurrenceTableView.tableFooterView = UIView()
        occurrenceTableView.separatorStyle = .none
    }

    func setupWithActivity(_ activityToUpdate: Activity) {
        activity = activityToUpdate
    }
}

extension ActivityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        activity.pastOccurences.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = occurrenceTableView.dequeueReusableCell(withIdentifier: "previousDateTableViewCell") as! PreviousDateTableViewCell
        var isFirstCell = false
        if indexPath.row == 0 {
            isFirstCell = true
        }

        var isOnlyCell = false
        if activity.pastOccurences.count == 1 {
            isOnlyCell = true
        }
        if indexPath.row < activity.pastOccurences.count - 1 {
            cell.setupWith(associatedDate: activity.pastOccurences[indexPath.row], andPreviousDate: activity.pastOccurences[indexPath.row + 1], isFirstCell: isFirstCell, isOnlyCell: isOnlyCell)
        } else {
            cell.setupWith(associatedDate: activity.pastOccurences[indexPath.row], andPreviousDate: nil, isFirstCell: isFirstCell, isOnlyCell: isOnlyCell)
        }
        return cell
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        return "Past"
    }
}
