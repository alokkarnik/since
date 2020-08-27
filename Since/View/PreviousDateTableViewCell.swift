//
//  PreviousDateTableViewCell.swift
//  Since
//
//  Created by Alok Karnik on 23/08/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

protocol PreviousDateCellProtocol: AnyObject {
    func removeDate(cell: PreviousDateTableViewCell)
}

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

    var editMode: Bool = false

    weak var delegate: PreviousDateCellProtocol?

    override func layoutSubviews() {
        super.layoutSubviews()
        if !editMode {
            cancelButtonWidthConstraint.constant = 0
        }
    }

    func setupWith(associatedDate: Date, andPreviousDate previousDate: Date?, isFirstCell: Bool = false, isOnlyCell: Bool = false) {
        dateLabel.text = formattedDate(date: associatedDate)

        if let previousDate = previousDate {
            daysSinceLabel.isHidden = false
            daysSinceLabel.text = "\(abs(associatedDate.differenceInDaysFrom(previousDate))) days"
        } else {
            daysSinceLabel.isHidden = true
            lowerVerticalView.isHidden = true
            lowerHorizontalView.isHidden = true
            middleVerticalView.isHidden = true
            dateLabelLowerConstraint.constant = 30
        }

        if editMode {
            showEditMode()
        }

        if isFirstCell {
            applyStyleForFirstCell()
        }

        if isOnlyCell {
            applyStyleForSingeCell()
        }
    }

    override func prepareForReuse() {
        showAllDifferenceViews()
        dateLabelLowerConstraint.constant = 60
        dateLabelUpperConstraint.constant = 20
    }

    @IBAction func deleteDate(_: Any) {
        if let delegate = delegate {
            delegate.removeDate(cell: self)
        }
    }
}

extension PreviousDateTableViewCell {
    private func showEditMode() {
        cancelButtonWidthConstraint.constant = 30
        hideAllDifferenceViews()
        daysSinceLabel.isHidden = true
    }

    private func applyStyleForFirstCell() {
        upperVerticalView.isHidden = true
    }

    private func applyStyleForSingeCell() {
        hideAllDifferenceViews()
        dateLabelLowerConstraint.constant = 30
        dateLabelUpperConstraint.constant = 30
    }

    private func hideAllDifferenceViews() {
        upperVerticalView.isHidden = true
        upperHorizontalView.isHidden = true
        middleVerticalView.isHidden = true
        lowerVerticalView.isHidden = true
        lowerHorizontalView.isHidden = true
    }

    private func showAllDifferenceViews() {
        upperVerticalView.isHidden = false
        upperHorizontalView.isHidden = false
        middleVerticalView.isHidden = false
        lowerVerticalView.isHidden = false
        lowerHorizontalView.isHidden = false
    }

    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, yyyy"

        return dateFormatter.string(from: date)
    }
}
