//
//  Employee.swift
//  Login Checker
//
//  Created by USER on 2/21/20.
//  Copyright © 2020 USER. All rights reserved.


import Foundation
import SwiftyJSON

struct employee {
    var id:String
    var employee_name:String
    var employee_salary:String
    var employee_age:String
    var profile_image:String
}


extension employee {
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.employee_name = json["employee_name"].stringValue
        self.employee_salary = json["employee_salary"].stringValue
        self.employee_age = json["employee_age"].stringValue
        self.profile_image = "https://picsum.photos/200/200"
    }
}
