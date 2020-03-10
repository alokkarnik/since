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

    @IBOutlet weak var activityInputView: UIView!
    
    @IBOutlet weak var activityTitleTextField: UITextField!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var insertActivity: UIButton!
    
    var activityData: [Activity]? = nil
    var storageController = ActivityStorageController()

    @IBAction func add(_ sender: Any) {
         showAddActivityView()
     }

     func showAddActivityView() {
         addButton.isHidden = true
         activityInputView.isHidden = false
         tableViewBottomConstraint.isActive = false
         activityTitleTextField.becomeFirstResponder()
     }

     func showDefaultView() {
         addButton.isHidden = false
         activityInputView.isHidden = true
         tableViewBottomConstraint.isActive = true
     }
    
     @IBAction func insertActivity(_ sender: Any) {
         if let activityTitle = activityTitleTextField.text {
             storageController.insertActivity(activityTitle: activityTitle)
             
             addButton.isHidden = false
             activityInputView.isHidden = true
             tableViewBottomConstraint.isActive = true
             reloadData()
             dismissKeyboard()
         }
     }

    func reloadData() {
        activityData = storageController.getAllActivities()
        tableView.reloadData()
    }
}


extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false
        activityInputView.isHidden = true

        activityData = storageController.getAllActivities()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTaped))
        view.addGestureRecognizer(tap)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: addButton.bounds.height + 50))
        addButton.layer.cornerRadius = addButton.bounds.size.width/2
        addButton.clipsToBounds = true
        addButton.titleLabel?.textAlignment = .center
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func screenTaped() {
        dismissKeyboard()
        showDefaultView()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
}

