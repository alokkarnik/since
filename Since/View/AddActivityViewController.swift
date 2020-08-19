//
//  AddActivityViewController.swift
//  Since
//
//  Created by Alok Karnik on 11/03/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {
    @IBOutlet var addActivityTextField: UITextField!
    @IBOutlet var updateDateButton: UIButton!
    @IBOutlet var addActivity: UIButton!
    @IBOutlet var dateButton: UIButton!

    var storageController = ActivityStorageController()

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        addActivityTextField.becomeFirstResponder()
        addActivityTextField.autocorrectionType = .no
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(datePicked), name: NSNotification.Name(rawValue: "datePicked"), object: nil)

        view.backgroundColor = .clear

        let screenTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTaped))
        view.addGestureRecognizer(screenTapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }

    @IBAction func addActivityButtonTapped(_: Any) {
        if let title = addActivityTextField.text, title.count > 0 {
            let date = dateButton.titleLabel?.text?.toDate() ?? Date()
            storageController.insertActivity(activityTitle: title, date: date)
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func dateButtonTapped(_: Any) {
        let datePickerVC = storyboard?.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerViewController
        present(datePickerVC, animated: true, completion: nil)
    }

    @objc func datePicked(notification: NSNotification) {
        let userInfo: [String: String] = notification.userInfo as! [String: String]
        if let date = userInfo["date"]?.toDate() {
            dateButton.setTitle(date.toString(), for: .normal)
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize
            }
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    @objc func screenTaped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
