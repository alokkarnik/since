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
    var activity: Activity!
    var storageController = ActivityStorageController()

    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var occurrenceTableView: UITableView!

    private var editMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        activityLabel.text = activity.title
        updateDaysSinceLabel()

        setupTableView()
        setupNavigationController()
    }

    @objc private func editActivity() {
        editMode = true

        navigationItem.rightBarButtonItems = getNavigationItemsForEditMode()
        occurrenceTableView.reloadData()
    }

    @objc private func saveChanges() {
        editMode = false

        let alertView = UIAlertController(title: "Save changes?", message: "This action is not reversible", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            (_: UIAlertAction!) in
            self.activity.saveUpdates()
            self.storageController.update(activity: self.activity, date: nil)
            self.updateDaysSinceLabel()

            self.navigationItem.rightBarButtonItems = self.getNavigationItemsForNormal()
            self.occurrenceTableView.reloadData()
        }))

        navigationController?.present(alertView, animated: true, completion: nil)
    }

    @objc private func cancelChanges() {
        editMode = false

        activity.resetUpdates()
        navigationItem.rightBarButtonItems = getNavigationItemsForNormal()
        occurrenceTableView.reloadData()
    }

    @objc private func deleteActivity() {
        let alertView = UIAlertController(title: "Delete activity?", message: "This action is not reversible", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            (_: UIAlertAction!) in
            self.storageController.delete(activity: self.activity)
            self.navigationController?.popViewController(animated: true)
        }))

        navigationController?.present(alertView, animated: true, completion: nil)
    }

    private func updateDaysSinceLabel() {
        daysLabel.text = "\(activity.daysSinceLastOccurence)"
    }
}

extension ActivityDetailViewController {
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.hexColour(hexValue: 0xEEB357, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .black

        navigationItem.rightBarButtonItems = getNavigationItemsForNormal()
    }

    private func setupTableView() {
        occurrenceTableView.delegate = self
        occurrenceTableView.dataSource = self

        tableViewContainer.layer.cornerRadius = 30
        tableViewContainer.clipsToBounds = true

        // Setup shadow
        tableViewContainer.layer.shadowOffset = .zero
        tableViewContainer.layer.shadowRadius = 10
        tableViewContainer.layer.shadowColor = UIColor.black.cgColor
        tableViewContainer.layer.shadowOpacity = 1

        occurrenceTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        occurrenceTableView.tableFooterView = UIView()
        occurrenceTableView.separatorStyle = .none
        occurrenceTableView.backgroundColor = UIColor.hexColour(hexValue: 0xE5E5E5, alpha: 1)
    }

    private func getNavigationItemsForNormal() -> [UIBarButtonItem] {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editActivity))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteActivity))
        deleteButton.tintColor = .red
        return [editButton, deleteButton]
    }

    private func getNavigationItemsForEditMode() -> [UIBarButtonItem] {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChanges))
        cancelButton.tintColor = .red
        return [saveButton, cancelButton]
    }
}

extension ActivityDetailViewController: PreviousDateCellProtocol {
    func removeDate(cell: PreviousDateTableViewCell) {
        let indexPath = occurrenceTableView.indexPath(for: cell)!
        activity.pastOccurencesToDisplay.remove(at: indexPath.row)
        occurrenceTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension ActivityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        activity.pastOccurencesToDisplay.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = occurrenceTableView.dequeueReusableCell(withIdentifier: "previousDateTableViewCell") as! PreviousDateTableViewCell
        cell.delegate = self
        cell.editMode = editMode

        let isFirstCell: Bool = indexPath.row == 0 ? true : false
        let isOnlyCell = activity.pastOccurencesToDisplay.count == 1 ? true : false

        if indexPath.row < activity.pastOccurencesToDisplay.count - 1 {
            cell.setupWith(associatedDate: activity.pastOccurencesToDisplay[indexPath.row], andPreviousDate: activity.pastOccurencesToDisplay[indexPath.row + 1], isFirstCell: isFirstCell, isOnlyCell: isOnlyCell)
        } else {
            cell.setupWith(associatedDate: activity.pastOccurencesToDisplay[indexPath.row], andPreviousDate: nil, isFirstCell: isFirstCell, isOnlyCell: isOnlyCell)
        }

        return cell
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        return "   Past Occurrences"
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 40
    }
}
