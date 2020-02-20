//
//  TableViewController.swift
//  Login Checker
//
//  Created by Amine on 2/20/20.
//  Copyright © 2020 USER. All rights reserved.
//

import Foundation
import UIKit

class CustCell: UITableViewCell {
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label: UILabel!
    
}

struct Person {
    let name:String
    let age: Int
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let names = [Person(name: "Amine 1", age: 21), Person(name: "Amine 2", age: 87), Person(name: "Amine 2", age: 5)]
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! CustCell
        cell.label.text = names[indexPath.row].name
        cell.label2.text = String(names[indexPath.row].age)
        return cell
    }
}
