//
//  ShoppingItemTableViewCell.swift
//  GroceryList
//
//  Created by Jonathan on 1/14/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class ShoppingItemTableViewCell: UITableViewCell {
    @IBOutlet weak var shoppingItemName: UILabel!
    @IBOutlet weak var shoppingItemGroup: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
