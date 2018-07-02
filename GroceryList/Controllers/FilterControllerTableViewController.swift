//
//  FilterControllerTableViewController.swift
//  GroceryList
//
//  Created by Jonathan on 1/28/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class FilterControllerTableViewController: UITableViewController {
    
    var filterItems = [GroupModel]()
    var _selectedFilter : GroupModel?
    var nextDestination : SegueDestinations?
    var _user: User?
    
    
    private func loadGroups(group: JSON){
        print(group)
//        guard let group1 = GroupModel(name : "Self") else{
//            fatalError("Unabled to instantiate shopping shoppingItem1")
//        }
//        guard let group2 = GroupModel(name : "Home") else{
//            fatalError("Unabled to instantiate shopping shoppingItem2")
//        }
//        guard let group3 = GroupModel(name : "Office") else{
//            fatalError("Unabled to instantiate shopping shoppingItem3")
//        }
        guard let group = GroupModel(name: group["group_name"].stringValue,group_uid : group["group_uid"].stringValue)else{
            fatalError("Unabled to instantiate shopping shoppingItem")
        }
        
        filterItems.append(group)
        
    }
    
    private func getGroups(){
        let headers: HTTPHeaders = [
            "Authorization" : _user!._accessCode!
        ]
        let url = Constants.API_URL + "groups"
        Alamofire.request(url,method:.get,parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            switch response.result {
            case .success(let data):
                if(response.response?.statusCode == 200 ){
                    let responseJSON = JSON(data)
                    for (index,group) in responseJSON{
                        var helpme = group["group_uid"]
                        self.loadGroups(group: group)
                    }
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        getGroups()
        //loadGroups()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        if(self.nextDestination == SegueDestinations.newItem){
            self.navigationItem.rightBarButtonItem = nil // remove default when selecting group for new item
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterItems.count + 2 // extra for logout button
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == filterItems.count  ){ // disabled cell
            let cellIdentifier = "DisabledCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilterCellTableViewCell  else {
                fatalError("The dequeued cell is not an instance of FilterCellTableViewCell.")
            }
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        if(indexPath.row == filterItems.count + 1){ // logout Button
            let cellIdentifier = "FilterGroupIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilterCellTableViewCell  else {
                fatalError("The dequeued cell is not an instance of FilterCellTableViewCell.")
            }
            cell.groupName.text = "Logout"
            return cell
        }
        
        let cellIdentifier = "FilterGroupIdentifier"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilterCellTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FilterCellTableViewCell.")
        }
        let filterItem = filterItems[indexPath.row]
        
        cell.groupName.text = filterItem.name
        //cell.groupStatus.setBackgroundImage(UIImage(named: "box"), for: UIControlState.normal)
//        cell.groupStatus.setBackgroundImage(UIImage(named: "checkBox"), for: UIControlState.normal)
        
        
        return cell
    }
    
    @IBAction func back(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.row == (filterItems.count + 1)){ // las    t element = logout button
            // logout
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
            return;
        }
        
        print(filterItems.count + 1,indexPath.row)
       
        //print(filterItems[indexPath.row].name)
        if(self.nextDestination == SegueDestinations.selectGroup){
            // delete this from shopping list
            self._selectedFilter = filterItems[indexPath.row] // passing selected group
            performSegue(withIdentifier: "applyFiltersSegue", sender: nil)
        }
        if(self.nextDestination == SegueDestinations.newItem){
            // delete this from shopping list
            self._selectedFilter = filterItems[indexPath.row] // passing selected group
            performSegue(withIdentifier: "newItemsSegue", sender: nil)
            
        }
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "applyFiltersSegue") {
            let vc = segue.destination as! ShoppingListTableViewController
            vc.filter = self._selectedFilter
            vc._user = self._user
        }
    
        
       
        if (segue.identifier == "newItemsSegue") {
            let vc = segue.destination as! AddItemListTableViewController
            vc.selectedGroup = self._selectedFilter
            vc._user = self._user
        }
        
        

    }
    @IBAction func defaultShoppingList(_ sender: Any) {
        self._selectedFilter = nil // apply default filters
        performSegue(withIdentifier: "applyFiltersSegue", sender: nil)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
