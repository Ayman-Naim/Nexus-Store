//
//  SignUpViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let fbViewModel = FireBaseSignUPViewModel()
    var customer = SignUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpButton(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else{
            print("Missing Field Data") // alert
            let alert = UIAlertController(title: "Missing Field Data", message: "Please Enter Data in The Missing Fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        fbViewModel.createAccount(email: email, password: password)
        fbViewModel.create(email: email) { result in
            switch result{
            case .success(let customer):
                print("debug1 \(customer)")
          //      self.customer = customer
                
            case .failure(let error):
                print(error)
                
                
            }
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
        let signinVC = SignInViewController()
        //signupVC.modalPresentationStyle = .fullScreen
        self.present(signinVC, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
