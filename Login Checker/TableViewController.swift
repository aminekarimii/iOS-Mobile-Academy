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
    let image:UIImage
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var employees : [employee] = []
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = URLSession.shared
        let url = URL(string: BASE_URL)!
        
        let task = session.dataTask(with: url) { data, response, error in

            if error != nil || data == nil {
                print("Client error!")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }

            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            do {
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    for case let result in (json["data"] as? [[String: String]])! {
                        if let emp = employee(json: result) {
                            self.employees.append(emp)
                        }
                    }
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    print(self.employees)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
    
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! CustCell
        cell.label.text = employees[indexPath.row].employee_name
        cell.label2.text = employees[indexPath.row].employee_salary
    
        return cell
    }
}
