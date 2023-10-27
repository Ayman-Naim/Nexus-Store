//
//  SignInViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit


class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func singInButtonPressed(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else{
            print("Missing Field Data") // alert
            let alert = UIAlertController(title: "Missing Field Data", message: "Please Enter Data in The Missing Fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        }
        
    }

