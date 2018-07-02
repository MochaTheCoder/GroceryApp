//
//  GroupModel.swift
//  GroceryList
//
//  Created by Jonathan on 1/28/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit // needed to allow global access to model


class GroupModel{
    var name: String
    var group_uid: String
    init?(name: String, group_uid : String) {
        if name.isEmpty{
            return nil
        }
        self.name = name
        self.group_uid = group_uid
    }
}
