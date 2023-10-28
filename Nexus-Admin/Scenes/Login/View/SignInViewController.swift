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
        /* if let contentData = UserDefaults.standard.object(forKey: "Admin4") as? Data,
         let content = try? JSONDecoder().decode(adminModel.self, from: contentData) {
         var vcc = ViewController()
         vcc.title = "new"
         self.navigationController?.pushViewController(vcc, animated: true)
         
         }*/
        viewModel.getAllData { result,error in
          
            print(result!.email!)
        }
      
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
        
        login(email: email, pass: password)
        
    }
    
    
    func login(email:String,pass:String){
        BaseUrl.AdminEmail = email
        viewModel.Login { result in
            switch result{
            case.success(let data):
                print(data)
                if data?.count==1{
                    if (data?.first?.email == email){
                        //print("Debug: Loged in ")
                        guard let adminData = data?.first else{return}
                        if let contentData = try? JSONEncoder().encode(adminData) {
                            
                            UserDefaults.standard.set(contentData, forKey: "Admin4")
                            print("Debug: Loged in ")
                        }
                        if let contentData = UserDefaults.standard.object(forKey: "Admin4") as? Data,
                           let content = try? JSONDecoder().decode(adminModel.self, from: contentData) {
                            
                            print("Debug:\(content)")
                        }
                        
                    }
                }
                
            case.failure(let error):
                let alert = UIAlertController(title: "the user or password is incorrect", message: "no user with this data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
}
