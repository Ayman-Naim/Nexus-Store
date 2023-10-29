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
    @IBOutlet weak var toggleImage: UIImageView!
    @IBOutlet weak var checkboxImage: UIImageView!
    
//    var isRememberMeSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add a tap gesture recognizer to the toggleImage
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        toggleImage.isUserInteractionEnabled = true
        toggleImage.addGestureRecognizer(tapGestureRecognizer)
        
 /*       // Load the "Remember Me" preference from UserDefaults
        isRememberMeSelected = UserDefaults.standard.bool(forKey: "RememberMe")
        updateRememberMeUI()*/
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

 /*       if isRememberMeSelected {
            // Save the email and password to UserDefaults
            UserDefaults.standard.set(email, forKey: "UserEmail")
            UserDefaults.standard.set(password, forKey: "UserPassword")
        } else {
            // If "Remember Me" is not selected, clear any saved data
            UserDefaults.standard.removeObject(forKey: "UserEmail")
            UserDefaults.standard.removeObject(forKey: "UserPassword")
        }
        UserDefaults.standard.synchronize()*/
    }
    
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        let signupVC = SignUpViewController()
        //signupVC.modalPresentationStyle = .fullScreen
    //    self.present(signupVC, animated: true)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        if passwordField.isSecureTextEntry {
            toggleImage.image = UIImage(named: "eye") // Show the open eye image
        } else {
            toggleImage.image = UIImage(named: "eyee") // Show the crossed eye image
        }
    }
    
    /*
    @IBAction func checkboxImageTapped(_ sender: UITapGestureRecognizer) {
        isRememberMeSelected.toggle() // Toggle the "Remember Me" state

        // Update the UI to reflect the new state
        updateRememberMeUI()

        // Save the "Remember Me" preference to UserDefaults
        UserDefaults.standard.set(isRememberMeSelected, forKey: "RememberMe")
        UserDefaults.standard.synchronize()
    }
    
    func updateRememberMeUI() {
        if isRememberMeSelected {
            checkboxImage.image = UIImage(named: "checkbox-2")
        } else {
            checkboxImage.image = UIImage(named: "checkbox-1")
        }
    }
    */
}
