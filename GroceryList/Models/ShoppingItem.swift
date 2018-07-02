//
//  ShoppingItemModel.swift
//  GroceryList
//
//  Created by Jonathan on 1/14/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit // needed to allow global access to model
import SwiftyJSON // for json

struct ShoppingItem {
    var item_uid : String
    var user_uid : String
    var item_name : String
    var item_price : Decimal?
    var stats_type: Int
    var group_uid: String
    var group_name: String

    var crossed_off : Bool
    
    //MARK: Initialization
    

    
    init?(json: JSON)  {
        self.item_uid = json["item_uid"].stringValue
        self.user_uid = json["user_uid"].stringValue
        self.item_name = json["item_name"].stringValue
        self.item_price = Decimal(json["item_price"].doubleValue)
        self.stats_type = json["stats_type"].intValue
        self.group_uid = json["group_uid"].stringValue
        self.group_name = json["group_name"].stringValue
        self.crossed_off = json["crossed_off"].boolValue
    }
    
    var jsonRepresentation : [String : Any]{
        return [
            "item_uid" : self.item_uid,
            "user_uid" : self.user_uid,
            "item_name" : self.item_name,
            "item_price" : self.item_price,
            "stats_type" : self.stats_type,
            "group_uid" : self.group_uid,
            "group_name" : self.group_name,
            "crossed_off" : self.crossed_off]
    }
    
  
    
    
    /*
    func getLabel(labelType : LabelType) -> UILabel{
        // CGRectMake has been deprecated - and should be let, not var
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        
        // you will probably want to set the font (remember to use Dynamic Type!)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)

        label.textColor = .black
        switch labelType {
        case .name:
            label.text = self.name
        case .group:
            label.text = self.group
        case .price:
            label.text = self.price.description // decimal to string
        }
        return label
    
    
    }
 
    
    enum LabelType{
        case name
        case price
        case group
    }
 */
}
