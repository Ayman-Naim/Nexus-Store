//
//  NetworkManger.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import UIKit


class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var viewModel = AdminLoginVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contentData = UserDefaults.standard.object(forKey: "Admin") as? Data,
           let content = try? JSONDecoder().decode(adminModel.self, from: contentData) {
            print(content)
            var vcc = AddProductViewController()
            vcc.title = "new"
            self.navigationController?.pushViewController(vcc, animated: true)
            
        }
    
       
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
        
       
        viewModel.LoginAuth(userEmail: email, pass: password) { result in
            switch result{
            case .success(let result):
                print("login is ok ")
            case .failure(_):
                let alert = UIAlertController(title: "the user or password is incorrect", message: "no user with this data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        
    }
}
