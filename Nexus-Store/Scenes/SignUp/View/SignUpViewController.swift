//
//  SignUpViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

class SignUpViewController: UIViewController {

    @IBOutlet weak var googleImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var toggleImage: UIImageView!
    
    let fbViewModel = FireBaseSignUPViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add a tap gesture recognizer to the toggleImage
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        toggleImage.isUserInteractionEnabled = true
        toggleImage.addGestureRecognizer(tapGestureRecognizer)
        
        //Add a tap gesture recognizer to google image
        let tapGestureRecognizerGoogle = UITapGestureRecognizer(target: self, action: #selector(signInWithGoogle))
        googleImage.isUserInteractionEnabled = true
        googleImage.addGestureRecognizer(tapGestureRecognizerGoogle)
        
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
        let signinVC = SignInViewController()
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
    
    @objc func signInWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in

                if let error = error {
                    let alert = UIAlertController(title: "Error Trial To Sign In", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Create Account", style: .default, handler: { action in
                        let signupVC = SignUpViewController()
                        self.navigationController?.pushViewController(signupVC, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
              // At this point, our user is signed in
                if let result = result {
                    if let user = Auth.auth().currentUser {
                        let userEmail = user.email
                        UserDefaults.standard.set(userEmail, forKey: "customerEmail")
                        print("User Email: \(userEmail!)")
                        self.getCustomerIDFromAPI(userEmail: userEmail ?? ""){
                            if let sceneDelegate = UIApplication.shared.connectedScenes
                                .first!.delegate as? SceneDelegate {
                                let tabBar = NexusTabBarController()
                                tabBar.navigationController?.isNavigationBarHidden = true
                                sceneDelegate.window!.rootViewController = tabBar
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createGoogleAccount(userEmail: String, completion: @escaping () -> Void){
        self.fbViewModel.create(email: userEmail, password: passwordField.text ?? "") { result in
            completion()
            switch result {
            case .success(let customer):
                print("debug1 \(customer)")
                
            case .failure(let error):
                print("Create Google Account \(error)")
            }
        }
    }
    
    func getCustomerIDFromAPI(userEmail: String, completion: @escaping () -> Void){
        self.fbViewModel.getCustomerId(email: userEmail) { result in
            switch result {
            case .success(let customerId):
                let customerrId = customerId
                if customerId.customers.contains(where: { $0.email == userEmail
                }){
                    completion()
                    print("Customer ID: \(customerrId)")

                    if let customerID = UserDefaults.standard.value(forKey: "customerID") {
                        // Use the customerID
                        print("Customer ID: \(customerID)")
                    } else {
                        // Customer ID is not available in UserDefaults
                        print("Customer ID is not available")
                    }
                }else{
                    self.createGoogleAccount(userEmail: userEmail, completion: completion)
                }

            case .failure(let error):
                print("Failed to retrieve customer ID: \(error)")
            }
        }
    }
}
