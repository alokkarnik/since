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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
