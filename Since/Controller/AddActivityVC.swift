//
//  AddActivityVC.swift
//  Since
//
//  Created by Alok Karnik on 28/08/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class AddActivityVC: UIViewController {
    @IBOutlet var activityNameTextView: UITextView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var activityDatePicker: UIDatePicker!
    @IBOutlet var inputContainerView: UIView!

    var storageController = ActivityStorageController()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        activityNameTextView.inputAccessoryView = nil
        inputContainerView.layer.cornerRadius = 20.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        if #available(iOS 13.4, *) {
            activityDatePicker.preferredDatePickerStyle = .wheels
        }
        activityNameTextView.delegate = self
        activityNameTextView.text = "Activity name"
        activityNameTextView.textColor = .darkGray
        saveButton.isEnabled = false
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func cancelButtonTapped(_: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_: Any) {
        if let title = activityNameTextView.text, title.count > 0 {
            let date = activityDatePicker.date
            storageController.insertActivity(activityTitle: title, date: date)
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height - inputContainerView.frame.origin.y
            }
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

extension AddActivityVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Activity name" {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 || textView.text == "Activity name" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Activity name"
            textView.textColor = .lightGray
            saveButton.isEnabled = false
        }
    }
}
