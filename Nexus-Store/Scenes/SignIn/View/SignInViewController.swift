//
//  SignInViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit
import FirebaseAuth

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
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                // Check for errors during sign-in
                if let error = error {
                    // Handle sign-in error
                    print("Sign-in error: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Error Trial To Sign In", message: "Please Enter valid email and password or Create a new account!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Create Account", style: .default, handler: { action in
                        let signupVC = SignUpViewController()
                        self.navigationController?.pushViewController(signupVC, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            let nav = UINavigationController(rootViewController: NexusTabBarController())
            nav.modalPresentationStyle = .fullScreen
            let tabBar = NexusTabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            //nav.isNavigationBarHidden = true
            if let user = Auth.auth().currentUser {
                let userId = user.uid
                print("User ID: \(userId)")
            }
            if let customerID = UserDefaults.standard.string(forKey: "customerID") {
                // Use the customerID
                print("Customer ID: \(customerID)")
            } else {
                // Customer ID is not available in UserDefaults
                print("Customer ID is not available")
            }
            self.present(tabBar, animated: true)

            }
    }
    
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        let signupVC = SignUpViewController()
        //signupVC.modalPresentationStyle = .fullScreen
    //    self.present(signupVC, animated: true)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
}
