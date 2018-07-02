//
//  ShoppingListTableViewController.swift
//  GroceryList
//
//  Created by Jonathan on 1/14/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// controls the data into the shoppingitemlisttable view cells
class ShoppingListTableViewController: UITableViewController {
    // segue values
    var filter : GroupModel? // grabbing group filter from filters controller
    var _user: User?
    

    private enum SectionType : Int{
        case SHOPPING_ITEM = 0
        case CROSSED_ITEM = 1
        
    }
    
    private struct itemSection{
        var sectionName: String
        var sectionItems : [ShoppingItem]
    }
    
    private var itemsList = [itemSection]()
    
    var shoppingItems = [ShoppingItem]()
    var crossedItems = [ShoppingItem]()

    private func loadShoppingItems(item: JSON){ // will call api .. based on the filters set
        print(item)
        guard let shoppingItem = ShoppingItem(json: item)else{
            fatalError("Unabled to instantiate shopping shoppingItem")
        }
        shoppingItems.append(shoppingItem)

    }
    
    private func loadCrossedShoppingItems(item: JSON){ // will call api .. based on the filters set
        

        guard let shoppingItem = ShoppingItem(json: item)else{
            fatalError("Unabled to instantiate shopping shoppingItem")
        }
        if(crossedItems.count < 1){
            addDeleteCrossedButton(item: shoppingItem, reloadingTable: false)
        }
        crossedItems.append(shoppingItem)
    }
    
    // Function to add a filler for the table row section for delete all button
    private func addDeleteCrossedButton(item: ShoppingItem, reloadingTable: Bool){
        var fillerItem = item
        fillerItem.item_uid = "fakeuid"
        crossedItems.append(fillerItem)
        
        if(reloadingTable){
            self.itemsList[SectionType.CROSSED_ITEM.rawValue].sectionItems.append(fillerItem)
        }
        
    }
    
    private func getUserInfo(){
        let headers: HTTPHeaders = [
            "Authorization" : _user!._accessCode!
        ]
                let url = Constants.API_URL + "User"
                Alamofire.request(url,method:.get,parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
                    switch response.result {
                    case .success(let data):
                        if(response.response?.statusCode == 200 ){
                            let responseJSON = JSON(data)
                            self._user?._userName = responseJSON["user_name"].stringValue
                            self._user?._userId = responseJSON["user_uid"].stringValue

                        }
                        else {
                            print(response)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }
    
    private func getShoppingItems(){
        //shoppingItems.removeAll()
        var filterValue = ""
        if(self.filter != nil){
            filterValue = (self.filter?.group_uid)!
        }
        let headers: HTTPHeaders = [
            "Authorization" : _user!._accessCode!
        ]
        let url = Constants.API_URL + "Items/" + filterValue
        Alamofire.request(url,method:.get,parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            switch response.result {
            case .success(let data):
                if(response.response?.statusCode == 200 ){
                    let responseJSON = JSON(data)
                    for (index,item) in responseJSON{
                        if(!item["crossed_off"].boolValue){
                            self.loadShoppingItems(item: item)
                        }
                        if(item["crossed_off"].boolValue){
                            self.loadCrossedShoppingItems(item:item)
                        }
                        
                    }
                    let shoppingSection = itemSection(sectionName: "Shopping List", sectionItems: self.shoppingItems)
                    let crossedSection = itemSection(sectionName: "Crossed Off", sectionItems: self.crossedItems)
                    self.itemsList.append(shoppingSection)
                    self.itemsList.append(crossedSection)
                    self.tableView.reloadData()
                }
                else {
                    print(response)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func crossItem(item : ShoppingItem){
        let parameters : [String:Any] = item.jsonRepresentation
        let headers: HTTPHeaders = [
            "Authorization" : _user!._accessCode!
        ]
        let url = Constants.API_URL + "Items/cross"
        Alamofire.request(url,method:.post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString{ response in
            switch(response.result){
            case .success(let data):
                
                if(self.crossedItems.count < 1){
                    self.addDeleteCrossedButton(item: item, reloadingTable: true)
                }
                
                self.itemsList[SectionType.CROSSED_ITEM.rawValue].sectionItems.append(item)
                self.itemsList[SectionType.SHOPPING_ITEM.rawValue].sectionItems = self.itemsList[SectionType.SHOPPING_ITEM.rawValue].sectionItems.filter{$0.item_uid != item.item_uid}
                
                self.tableView.reloadData()
            case .failure(let error):
                // error
                print(error)
                }
            }
    }
    
    private func uncrossItem(item : ShoppingItem){
        let parameters : [String:Any] = item.jsonRepresentation
        let headers: HTTPHeaders = [
            "Authorization" : _user!._accessCode!
        ]
        let url = Constants.API_URL + "Items/uncross"
        Alamofire.request(url,method:.post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString{ response in
            switch(response.result){
            case .success(let data):
                self.itemsList[SectionType.SHOPPING_ITEM.rawValue].sectionItems.append(item) // move to shopping list
                // filter out the new uncrossed item in the crossed list
                self.itemsList[SectionType.CROSSED_ITEM.rawValue].sectionItems =  self.itemsList[SectionType.CROSSED_ITEM.rawValue].sectionItems.filter{$0.item_uid != item.item_uid}

                self.tableView.reloadData()
            case .failure(let error):
                // error
                print(error)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if(filter != nil){
            self.title = filter?.name
        }
        
        //loadShoppingItems()
        
        getUserInfo()
        getShoppingItems()
        //print(shoppingItems)
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    

    
    
    // section name
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == SectionType.CROSSED_ITEM.rawValue){
            if(self.itemsList[section].sectionItems.count < 2){
                return ""
            }
        }
        return itemsList[section].sectionName
    }
    // number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemsList.count

    }

    // number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if crossed list has no more elements except the button, remove the delete all button
        if(itemsList[SectionType.CROSSED_ITEM.rawValue].sectionItems.count  == 1 && section == SectionType.CROSSED_ITEM.rawValue){ // if only the filler is there
            return 0
        }
        return itemsList[section].sectionItems.count
    
    }

    // cell data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let shoppingItem = itemsList[indexPath.section].sectionItems[indexPath.row]
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: shoppingItem.item_name)
        

            let cellIdentifier = "ShoppingItemIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShoppingItemTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ShoppingListViewCell.")
            }

            cell.shoppingItemName.attributedText = attributeString
            cell.shoppingItemGroup.text = shoppingItem.group_name

        

        
        if(indexPath.section == SectionType.CROSSED_ITEM.hashValue){
            if(indexPath.row == 0) // FIRST ELement in crossed_Off
            {
                let cellIdentifier = "DeleteCrossedItemsIdentifier"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DeleteCrossedItemsTableViewCell  else {
                    fatalError("The dequeued cell is not an instance of ShoppingListViewCell.")
                }
                
                cell.deleteCrossedItemsButton.text = "Delete Crossed Off Items"
                return cell
            }
            
            let cellIdentifier = "ShoppingItemIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShoppingItemTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ShoppingListViewCell.")
            }
            
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.shoppingItemName.attributedText = attributeString
            cell.shoppingItemGroup.text = shoppingItem.group_name
            return cell
        }
        return cell
    }
    
    //table cell clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let shoppingItem = itemsList[indexPath.section].sectionItems[indexPath.row]
        switch(indexPath.section){
        case SectionType.SHOPPING_ITEM.rawValue:
            crossItem(item: shoppingItem)
        case SectionType.CROSSED_ITEM.rawValue:
            if(indexPath.row == 0){ // delete uncrossed button
                print("hello")
            }else{
                uncrossItem(item: shoppingItem)
            }
        default:
            print("Error")
        }

    }
    
    @IBAction func groupsSegue(_ sender: Any) {
        performSegue(withIdentifier: "selectGroupSegue", sender: nil)
    }
    
    @IBAction func newItemSegue(_ sender: Any) {
        
        if(self.filter == nil){
        performSegue(withIdentifier: "selectNewItemSegue", sender: nil)
        }
        if(self.filter != nil){
            performSegue(withIdentifier: "selectNewItemWithGroupSegue", sender: nil)
        }
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectNewItemSegue") {
            let navVC = segue.destination as! UINavigationController
            let tableVC = navVC.viewControllers.first as! FilterControllerTableViewController
            tableVC.nextDestination = SegueDestinations.newItem
            tableVC._user = self._user
            
        }
        if (segue.identifier == "selectNewItemWithGroupSegue") {
            let navVC = segue.destination as! UINavigationController
            let tableVC = navVC.viewControllers.first as! AddItemListTableViewController
            tableVC.selectedGroup = filter
        }
        if (segue.identifier == "selectGroupSegue") {
            let navVC = segue.destination as! UINavigationController
            let tableVC = navVC.viewControllers.first as! FilterControllerTableViewController
            tableVC.nextDestination = SegueDestinations.selectGroup
            tableVC._user = self._user

        }
    }
    



}
