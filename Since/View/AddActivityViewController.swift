//
//  AddActivityViewController.swift
//  Since
//
//  Created by Alok Karnik on 11/03/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {
    
    @IBOutlet weak var addActivityTextField: UITextField!
    @IBOutlet weak var updateDateButton: UIButton!
    @IBOutlet weak var addActivity: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
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
    
    @IBAction func addActivityButtonTapped(_ sender: Any) {
        if let title = addActivityTextField.text {
            let date = dateButton.titleLabel?.text?.toDate() ?? Date()
            storageController.insertActivity(activityTitle: title, date: date)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        let datePickerVC = storyboard?.instantiateViewController(identifier: "DatePickerVC") as! DatePickerViewController
        present(datePickerVC, animated: true, completion: nil)
    }
    
    @objc func datePicked(notification:NSNotification) {
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        if let date = userInfo["date"]?.toDate() {
            dateButton.setTitle(date.toString(), for: .normal)
        }
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
    
    @objc func screenTaped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
