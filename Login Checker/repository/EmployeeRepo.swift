//
//  EmployeeRepo.swift
//  Login Checker
//
//  Created by Amine on 3/2/20.
//  Copyright © 2020 USER. All rights reserved.
//

import Foundation
import Alamofire


class EmployeeRepo{
    
    var dataController:DataController = DataController(modelName: Constants)
    
    func getDataFromApiAndSaveit(url:String){
        AF.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonresult = JSON(value)["data"].arrayValue
                    
                    self.employees = jsonresult.map{ json in
                        self.modelDataIntoEmployee(e: json)
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        //self.table.reloadData()
                        try? self.dataController.viewContext.save()
                    })
                case .failure(let error):
                    print(error)
                }
        }
    }
}
