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
import SDWebImage
import CoreData


class CustCell: UITableViewCell {
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageview: UIImageView!
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var employees : [EmployeeData]? = nil
    
    var deleteemployeeIndexPath : NSIndexPath? = nil
    
    let fetchRequest = NSFetchRequest<EmployeeData>(entityName: "EmployeeData")
    
    var fetchedResultsController:NSFetchedResultsController<EmployeeData>!
    
    var dataController:DataController = DataController(modelName: "Model")

    let url = URL(string: BASE_URL)!
    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        employees = try! dataController.viewContext.fetch(fetchRequest)
        
        dataController.load()
        
        // Check if data exist in Core, else call it from Api
        refreshData()
        
        self.setupFetchedResultsController()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        if let indexPath = table.indexPathForSelectedRow {
            table.deselectRow(at: indexPath, animated: false)
            table.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    // MARK: tableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees!.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteemployeeIndexPath = indexPath as NSIndexPath
            let empToDelete = employees![indexPath.row]
            confirmDelete(employeeToDelete:empToDelete)
            
        default: () // Unsupported
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! CustCell
        cell.label.text = employees![indexPath.row].employee_name
        cell.label2.text = String(employees![indexPath.row].id)
        cell.imageview.sd_setImage(with: URL(string: employees![indexPath.row].profile_image!))
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            if let indexPath = table.indexPathForSelectedRow {
                vc.employee = fetchedResultsController.object(at: indexPath)
                vc.dataController = dataController
            }
        }
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<EmployeeData> = EmployeeData.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "employee_name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    
    
    func modelDataIntoEmployee(e:JSON) -> EmployeeData{
        let employee = EmployeeData(context: dataController.viewContext)
        employee.id = Int32(e["id"].intValue)
        employee.employee_name = e["employee_name"].stringValue
        employee.employee_salary = Int32(e["employee_salary"].intValue)
        employee.employee_age = Int32(e["employee_age"].intValue)
        employee.profile_image = "https://i.picsum.photos/id/\(Int(e["id"].stringValue)!*11)/200/200.jpg"
        return employee
    }
    
    func refreshData(){
        print("db objects count: \(checkCoreData())")
        if checkCoreData() == 0{
            getDataFromApiAndSaveit()
        }else {
            getDataFromCore()
        }
    }
    
    
    func getDataFromCore(){
        do {
            try dataController.viewContext.fetch(fetchRequest)
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
        }
    }
    
    func checkCoreData() -> Int{
        // create a NSFetchRequest to retrieve all Person objects
        
        // let predicate =NSPredicate(format: "employee == %@", employee)
        // fetchRequest.predicate = predicate
        
        // use the NSManagedObjectContext to execute the NSFetchRequest
        do {
            let results = try dataController.viewContext.fetch(fetchRequest)
            return results.count
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
        }
        return 0
    }
    
    func confirmDelete(employeeToDelete: EmployeeData){
        let alert = UIAlertController(title: "Delete Employee", message: "Are you sure you want to permanently delete \(employeeToDelete.employee_name!) ?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDelete)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDelete(alertAction:))
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDelete(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteemployeeIndexPath {
            
            table.beginUpdates()
            
            employees!.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            //table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            table.deleteRows(at: [(indexPath as IndexPath)], with: .automatic)
            
            deleteemployeeIndexPath = nil
            
            table.endUpdates()
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        deleteemployeeIndexPath = nil
    }
    
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}


extension TableViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.table.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            self.table.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            self.table.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            self.table.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: self.table.insertSections(indexSet, with: .fade)
        case .delete: self.table.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.table.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.table.endUpdates()
    }
}
