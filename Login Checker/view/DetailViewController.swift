//
//  DetailViewController.swift
//  Login Checker
//
//  Created by Amine on 2/28/20.
//  Copyright © 2020 USER. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class DetailViewController: UIViewController{
    
    @IBOutlet weak var employeeImageView: UIImageView!
    @IBOutlet weak var employeeSalaryLab: UILabel!
    @IBOutlet weak var employeeNameLab: UILabel!
    @IBOutlet weak var emplyeeAgeLab: UILabel!
    
    var dataController:DataController!
    var employee: EmployeeData!
    
    override func viewDidLoad() {
           super.viewDidLoad()
        showEmployeeDetails(emp: employee)
       }
    
    func showEmployeeDetails(emp: EmployeeData){
        employeeNameLab.text = emp.employee_name
        employeeSalaryLab.text = String(emp.employee_salary)+"$"
        emplyeeAgeLab.text = String(emp.employee_age)+" yo"
        employeeImageView.sd_setImage(with: URL(string: emp.profile_image!))
    }
}
