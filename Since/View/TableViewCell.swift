//
//  TableViewCell.swift
//  Since
//
//  Created by Alok Karnik on 02/01/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var sinceLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet var cellBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        selectionStyle = .none
        cellBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        cellBackgroundView.layer.shadowOpacity = 0.4
        cellBackgroundView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cellBackgroundView.layer.shadowRadius = 5
        
    }

    override func layoutSubviews() {
        cellBackgroundView.layer.cornerRadius = 15
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            cellBackgroundView.backgroundColor = UIColor.hexColour(hexValue: 0xEEB357, alpha: 1)
        } else {
            cellBackgroundView.backgroundColor = UIColor.hexColour(hexValue: 0xE9ECEE, alpha: 1)
        }
    }

}


extension UIColor {
    static func hexColour(hexValue:UInt32, alpha:CGFloat)->UIColor
    {
      let red = Double((hexValue & 0xFF0000) >> 16) / 255.0
      let green = Double((hexValue & 0xFF00) >> 8) / 255.0
      let blue = Double(hexValue & 0xFF) / 255.0
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }
}
