//
//  GroceryList
//
//  Created by Jonathan on 6/11/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import Foundation

struct NewItem{
    var item_name : String
    var group_uid : String
    var item_price : String
    
    init?(item_name: String, group_uid: String, item_price: String)  {
        self.item_name = item_name
        self.group_uid = group_uid
        self.item_price = item_price
    }
    
    var jsonRepresentation : [String : Any]{
        return [
            "item_name" : self.item_name,
            "group_uid" : self.group_uid,
            "item_price" : self.item_price]
    }
    
}
