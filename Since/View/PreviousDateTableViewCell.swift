//
//  PreviousDateTableViewCell.swift
//  Since
//
//  Created by Alok Karnik on 23/08/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class PreviousDateTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var daysSinceLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!

    @IBOutlet var upperVerticalView: UIView!
    @IBOutlet var upperHorizontalView: UIView!
    @IBOutlet var middleVerticalView: UIView!
    @IBOutlet var lowerHorizontalView: UIView!
    @IBOutlet var lowerVerticalView: UIView!

    @IBOutlet var cancelButtonWidthConstraint: NSLayoutConstraint!

    @IBOutlet var dateLabelUpperConstraint: NSLayoutConstraint!
    @IBOutlet var dateLabelLowerConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cancelButtonWidthConstraint.constant = 0
    }

    func setupWith(associatedDate: Date, andPreviousDate previousDate: Date?, isFirstCell: Bool = false, isOnlyCell: Bool = false) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, yyyy"
        dateLabel.text = dateFormatter.string(from: associatedDate)
        if let previousDate = previousDate {
            daysSinceLabel.text = "\(abs(associatedDate.differenceInDaysFrom(previousDate))) days"
        } else {
            daysSinceLabel.text = ""
            lowerVerticalView.isHidden = true
            lowerHorizontalView.isHidden = true
            middleVerticalView.isHidden = true
            dateLabelLowerConstraint.constant = 30
        }

        if isFirstCell {
            upperVerticalView.isHidden = true
        }

        if isOnlyCell {
            upperVerticalView.isHidden = true
            upperHorizontalView.isHidden = true
            middleVerticalView.isHidden = true
            lowerVerticalView.isHidden = true
            lowerHorizontalView.isHidden = true
            dateLabelLowerConstraint.constant = 30
            dateLabelUpperConstraint.constant = 30
        }
    }

    override func prepareForReuse() {
        upperVerticalView.isHidden = false
        upperHorizontalView.isHidden = false
        middleVerticalView.isHidden = false
        lowerVerticalView.isHidden = false
        lowerHorizontalView.isHidden = false
        dateLabelLowerConstraint.constant = 60
        dateLabelUpperConstraint.constant = 20
    }
}
