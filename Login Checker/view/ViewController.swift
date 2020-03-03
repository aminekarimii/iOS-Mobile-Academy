//
//  ViewController.swift
//  Login Checker
//
//  Created by USER on 2/19/20.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var mSwitch: UISwitch!
    @IBOutlet weak var userErrorLab: UILabel!
    @IBOutlet weak var passwordErrorLab: UILabel!

    
    var username:String = "1"
    var password : String = "1"
    let user_tag = "Username"
    let password_tag = "Password"
    let remember_user = "remember_user"
    
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: validate function
    @IBAction func validate(_ sender: Any) {
        print("textField: \(textField.text!)")
        
        if validateForm(){
            if mSwitch.isOn {
                 defaults.set(true, forKey: remember_user)
            }
            saveDataIntoUserDefault()
            showStoredData()
            performSegue(withIdentifier: "showWelcome", sender: nil)
        }
    }
    
    override var shouldAutorotate: Bool {
           return false
       }

    
    func checkUser(user: String, pwd:String) -> Bool {
        var result = false
        // test password
        if user == username && pwd == password {
            result = true
        }
        return result
    }
    
    
    func showStoredData(){
        if let rememberMeVal: Bool = defaults.bool(forKey: remember_user) {
            print ("user saved remember? : \(rememberMeVal)")
        }
    }
    
    func saveDataIntoUserDefault(){
        if let password = passwordField.text {
            let result : Bool = KeychainWrapper.standard.set(password, forKey: password_tag)
            print("pwd \(result)")
            self.view.endEditing(true)
        }
        if let user = textField.text {
            let result : Bool = KeychainWrapper.standard.set(user, forKey: user_tag)
            print("user \(result)")
            self.view.endEditing(true)
        }
    }
    
    func validateForm() -> Bool{
        var valid = true
        if let password = passwordField.text, password.isEmpty {
            passwordErrorLab.text = "Veuillez saisir le mot de passe"
            passwordErrorLab.isHidden = false
            valid = false
        }
        
        if let username = textField.text, username.isEmpty {
            userErrorLab.text = "Veuillez saisir le nom d'utilisateur"
            userErrorLab.isHidden = false
            valid = false
        }
        return valid
    }
    
}

