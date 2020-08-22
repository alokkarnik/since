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
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(activity.pastOccurences[indexPath.row])"
        return cell
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        return "Past"
    }
}
