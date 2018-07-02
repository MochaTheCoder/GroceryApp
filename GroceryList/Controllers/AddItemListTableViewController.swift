//
//  AddItemListTableViewController.swift
//  GroceryList
//
//  Created by Jonathan on 1/14/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Alamofire

class AddItemListTableViewController: UITableViewController, UISearchBarDelegate  {
    @IBOutlet weak var searchController: UISearchBar!
    

    var itemsToAdd = [ShoppingItem]() // unfiltered items
    var filteredItems = [ShoppingItem]() // filtered items
    
    var selectedGroup : GroupModel?
    var _user: User?

    private func loadItems(){
//        guard let loadedItem1 = ShoppingItem(name : "Apple",group : "Self", crossedOff : false) else{
//            fatalError("Unabled to instantiate shopping shoppingItem1")
//        }
//        guard let loadedItem2 = ShoppingItem(name : "Orange",group : "Self", crossedOff : false) else{
//            fatalError("Unabled to instantiate shopping shoppingItem1")
//        }
//        guard let loadedItem3 = ShoppingItem(name : "Banana",group : "Self", crossedOff : false) else{
//            fatalError("Unabled to instantiate shopping shoppingItem1")
//        }
//
//        itemsToAdd += [loadedItem1,loadedItem2,loadedItem3]
//        filteredItems = itemsToAdd // copy unfiltered array
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadItems()
        self.title = selectedGroup?.name
        tableView.delegate = self
        tableView.dataSource = self
        
        self.searchController.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return filteredItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AddItemIdentifier"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddItemListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ShoppingListViewCell.")
        }
        
        cell.addItemName.text = filteredItems[indexPath.row].item_name
  
        return cell

    }
    
    
    //table cell clicked

     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Item added")
        // add this to shopping list
    }
    

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.filterData(searchBarText: "")
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        self.filteredItems.removeAll()
        self.filterData(searchBarText: searchText)
    }
    
    func filterData(searchBarText : String){
        if(searchBarText == ""){
            self.filteredItems = self.itemsToAdd
        }
        else if(searchBarText != ""){
            for item in self.itemsToAdd{
                if(item.item_name.contains(searchBarText)){
                    self.filteredItems.append(item)
                }
            }
        }

        self.tableView.reloadData()
    }
    

    
    @IBAction func newItem(_ sender: Any) {
        let alert = UIAlertController(title: "New Item",message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Item Name"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text!)")
            // save new item in database
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style:.cancel,handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addItem(item: NewItem){
        let headers: HTTPHeaders = [
            "Authorization" : _user!._accessCode!
        ]
        let url = Constants.API_URL + "Items/new"
        let parameters : [String : Any] = item.jsonRepresentation
        Alamofire.request(url,method:.post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString{ response in
            switch(response.result){
            case .success(let data):
                print(data)
                // item added to db
            case .failure(let error):
                // error
                print(error)
            }
        }
    }
    
 

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
