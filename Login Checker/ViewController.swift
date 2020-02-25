//
//  ViewController.swift
//  Login Checker
//
//  Created by USER on 2/19/20.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var myGradientView: UIView!
    
    var username:String = "1"
    var password : String = "1"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func validate(_ sender: Any) {
        print("textField: \(textField.text!)")

        if checkUser(user: textField.text!,pwd: passwordField.text! ) {
            performSegue(withIdentifier: "showWelcome", sender: nil)
        } else {
            resultLabel.text = "Login ou mot de passe errone"
            resultLabel.isHidden = false
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
    
    
    
}

