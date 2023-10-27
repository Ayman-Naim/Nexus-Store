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
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                // show account sign up
                strongSelf.showSignUpButton(emai: email, password: password)
                return
            }
            print("You have signed in")
      //      strongSelf.label.isHidden = true
            strongSelf.emailField.isHidden = true
            strongSelf.passwordField.isHidden = true
     //       strongSelf.button.isHidden = true
            
        })
        
        let nav = UINavigationController(rootViewController: NexusTabBarController())
        nav.modalPresentationStyle = .fullScreen
        let tabBar = NexusTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        //nav.isNavigationBarHidden = true
        self.present(tabBar, animated: true)
    }
    
    func showSignUpButton(emai: String, password: String){
        let alert = UIAlertController(title: "Create Account", message: "Please Create Account First!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            let signupVC = SignUpViewController()
            //signupVC.modalPresentationStyle = .fullScreen
            self.present(signupVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        let signupVC = SignUpViewController()
        //signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true)
    }
    
}
