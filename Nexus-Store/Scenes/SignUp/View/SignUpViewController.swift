//
//  SignUpViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var googleImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var toggleImage: UIImageView!
    
    let fbViewModel = FireBaseSignUPViewModel()
    var customer = SignUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add a tap gesture recognizer to the toggleImage
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        toggleImage.isUserInteractionEnabled = true
        toggleImage.addGestureRecognizer(tapGestureRecognizer)
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
        // Add email and password regex validation here
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            return
        }
        
        if !isValidPassword(password) {
            showAlert(title: "Invalid Password", message: "Password must meet certain criteria")
            return
        }

        fbViewModel.createAccount(email: email, password: password)
        fbViewModel.create(email: email, password: password) { result in
            switch result {
            case .success(let customer):
                print("debug1 \(customer)")
                // Account created successfully, show a success alert
                self.showSuccessAlert()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
   //     let signinVC = SignInViewController()
        //signupVC.modalPresentationStyle = .fullScreen
   //     self.present(signinVC, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Function to check if email is valid using regex
        func isValidEmail(_ email: String) -> Bool {
            // You can use your preferred email validation regex
      //      let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }

        // Function to check if password meets certain criteria (e.g., length)
        func isValidPassword(_ password: String) -> Bool {
            // Add your password validation criteria here
            return password.count >= 6
        }

        // Function to show an alert
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        // Function to show a success alert
        func showSuccessAlert() {
            let alert = UIAlertController(title: "Account Created Successfully!", message: "What would you like to do?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default) { _ in
                // Navigate to the sign-in view controller
                let signinVC = SignInViewController()
                self.navigationController?.pushViewController(signinVC, animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    @objc func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        if passwordField.isSecureTextEntry {
            toggleImage.image = UIImage(named: "eye") // Show the open eye image
        } else {
            toggleImage.image = UIImage(named: "eyee") // Show the crossed eye image
        }
    }
}
