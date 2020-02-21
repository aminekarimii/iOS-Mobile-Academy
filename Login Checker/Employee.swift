//
//  Employee.swift
//  Login Checker
//
//  Created by USER on 2/21/20.
//  Copyright © 2020 USER. All rights reserved.


import Foundation

struct employee {
    var id:String
    var employee_name:String
    var employee_salary:String
    var employee_age:String
    var profile_image:String
}


extension employee {
    init?(json: [String: String]) {
        guard let id = json["id"],
            let employee_name = json["employee_name"],
            let employee_salary = json["employee_salary"],
            let employee_age = json["employee_age"],
            let profile_image = json["profile_image"]
        else {
            return nil
        }

        self.id = id
        self.employee_name = employee_name
        self.employee_salary = employee_salary
        self.employee_age = employee_age
        self.profile_image = profile_image
    }
}
