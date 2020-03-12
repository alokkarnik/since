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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addActivityTextField.becomeFirstResponder()
        view.backgroundColor = .clear
        
        let screenTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTaped))
        view.addGestureRecognizer(screenTapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func addActivityButtonTapped(_ sender: Any) {
        if let title = addActivityTextField.text {
            storageController.insertActivity(activityTitle: title, date: Date())
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        
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
