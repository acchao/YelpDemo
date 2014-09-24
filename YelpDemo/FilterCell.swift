//
//  FilterCell.swift
//  YelpDemo
//
//  Created by Andrew Chao on 9/23/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

protocol FilterCellDelegate {
    func filterCellSwitchClicked(filterCell: FilterCell)
}

class FilterCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!

    var delegate: FilterCellDelegate!

    var section: Int = 0
    var row: Int = 0

    @IBAction func onSwitchChanged(sender: AnyObject) {
        delegate.filterCellSwitchClicked(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
