//
//  EmployeeData+CoreDataProperties.swift
//  Login Checker
//
//  Created by Amine on 2/28/20.
//  Copyright © 2020 USER. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeData> {
        return NSFetchRequest<EmployeeData>(entityName: "EmployeeData")
    }

    @NSManaged public var employee_age: Int32
    @NSManaged public var employee_name: String?
    @NSManaged public var employee_salary: Int32
    @NSManaged public var id: Int32
    @NSManaged public var profile_image: String?

}
