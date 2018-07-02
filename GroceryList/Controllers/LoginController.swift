//
//  ViewController.swift
//  GroceryList
//
//  Created by Jonathan on 8/13/17.
//  Copyright © 2017 Jonathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginController: UIViewController {
    var _user = User()


    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func loginAction(_ sender: UIButton) {

//        var url = "https://httpbin.org/get"
//        Alamofire.request(url,method:.get,parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{
//            response in
//            switch response.result{
//            case .success:
//                print(response)
//                break
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//         url = "https://httpbin.org/post"
//        Alamofire.request(url,method:.post,parameters: ["foo": "bar"], encoding: JSONEncoding.default, headers: nil).responseJSON{
//            response in
//            switch response.result{
//            case .success:
//                print(response)
//                break
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        let url = Constants.BASE_URL + "token"
        let params: Parameters = [
            "grant_type" : "password",
            "username" : "FirstUser",
            "password" : "aaAA1!"
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, headers: headers)
            .responseJSON{ response in
                
                switch response.result {
                case .success(let data):
                    let loginData = JSON(data)
                    self._user._accessCode = "bearer " + loginData["access_token"].stringValue
                    
                    if response.response?.statusCode == 200 {
                        // login success
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                    else {
                        print("not 200")
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginSegue") {
            let navVC = segue.destination as! UINavigationController
            let tableVC = navVC.viewControllers.first as! ShoppingListTableViewController
            tableVC._user = self._user
        }
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        print("HELLO!")
        
    }
    
    

}

