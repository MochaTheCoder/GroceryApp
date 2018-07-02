//
//  FilterCellTableViewCell.swift
//  GroceryList
//
//  Created by Jonathan on 1/28/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class FilterCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var groupStatus: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
