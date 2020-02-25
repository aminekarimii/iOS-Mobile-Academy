//
//  TableViewController.swift
//  Login Checker
//
//  Created by Amine on 2/20/20.
//  Copyright © 2020 USER. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage


class CustCell: UITableViewCell {
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageview: UIImageView!
}

struct Person {
    let name:String
    let age: Int
    let image:UIImage
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var employees : [employee] = []
    
    let url = URL(string: BASE_URL)!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call api from AF lib
        getDataFromApi()
         
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! CustCell
        cell.label.text = employees[indexPath.row].employee_name
        cell.label2.text = employees[indexPath.row].employee_salary
        
        AF.request(employees[indexPath.row].profile_image).responseImage{ response in
            if case .success(let image) = response.result {
                cell.imageview.image = image
            }
        }
        return cell
    }
    
    func getDataFromApi(){
        AF.request(url, method: .get)
        .validate()
        .responseJSON { response in
            switch response.result {
                case .success(let value):
                    let jsonresult = JSON(value)["data"].arrayValue
                    self.employees = jsonresult.map{e in employee(json: e) }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.table.reloadData()
                    })
                //print(self.employees)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
