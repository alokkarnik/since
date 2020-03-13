//
//  DatePickerViewController.swift
//  Since
//
//  Created by Alok Karnik on 13/03/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit
import Foundation

class DatePickerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var activity: Activity?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        datePicker.datePickerMode = .date
        datePicker.center = view.center
        datePicker.maximumDate = Date()
    }
    @IBAction func datePicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        let nc = NotificationCenter.default
        if let something = activity{
            nc.post(name: NSNotification.Name(rawValue: "datePicked"), object: nil, userInfo: ["date" : strDate, "id":String(something.id)])
        } else {
            nc.post(name: NSNotification.Name(rawValue: "datePicked"), object: nil, userInfo: ["date" : strDate])
        }

       dismiss(animated: true, completion: nil)

}
}
