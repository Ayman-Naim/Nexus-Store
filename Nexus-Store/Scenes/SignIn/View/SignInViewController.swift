//
//  SignInViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

class SignInViewController: UIViewController {

    @IBOutlet weak var googleImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var toggleImage: UIImageView!
    @IBOutlet weak var checkboxImage: UIImageView!
    
//    var isRememberMeSelected = false
    var signInVM = FireBaseSignInViewModel()
//    let customerID = UserDefaults.standard.value(forKey: "customerID")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add a tap gesture recognizer to the toggleImage
        let tapGestureRecognizerToggleEye = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        toggleImage.isUserInteractionEnabled = true
        toggleImage.addGestureRecognizer(tapGestureRecognizerToggleEye)
        
        //Add a tap gesture recognizer to google image
        let tapGestureRecognizerGoogle = UITapGestureRecognizer(target: self, action: #selector(signInWithGoogle))
        googleImage.isUserInteractionEnabled = true
        googleImage.addGestureRecognizer(tapGestureRecognizerGoogle)
        
 /*       // Load the "Remember Me" preference from UserDefaults
        isRememberMeSelected = UserDefaults.standard.bool(forKey: "RememberMe")
        updateRememberMeUI()*/
    }

    @IBAction func GuestModePressed(_ sender: Any) {
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as? SceneDelegate {
            let tabBar = NexusTabBarController()
            tabBar.navigationController?.isNavigationBarHidden = true
            sceneDelegate.window!.rootViewController = tabBar
            
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
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as? SceneDelegate {
                let tabBar = NexusTabBarController()
                tabBar.navigationController?.isNavigationBarHidden = true
                sceneDelegate.window!.rootViewController = tabBar
                
            }
 /*           let nav = UINavigationController(rootViewController: NexusTabBarController())
            nav.modalPresentationStyle = .fullScreen
            let tabBar = NexusTabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            //nav.isNavigationBarHidden = true*/
            if let user = Auth.auth().currentUser {
          //      let userId = user.uid
          //      UserDefaults.standard.set(userId, forKey: "customerID")
         //       print("User ID: \(userId)")
                print(user)
                let userEmail = user.email
                UserDefaults.standard.set(userEmail, forKey: "customerEmail")
                print("User Email: \(userEmail!)")
    //            UserDefaults.standard.set(self.customerID, forKey: "customerEmail")
                self.signInVM.getCustomerId(email: email) { result in
                    switch result {
                    case .success(let customerId):
                        let customerrId = customerId
                        
                        print("Customer ID: \(customerrId)")

                        if let customerID = UserDefaults.standard.value(forKey: "customerID") {
                            // Use the customerID
                            print("Customer ID: \(customerID)")
                        } else {
                            // Customer ID is not available in UserDefaults
                            print("Customer ID is not available")
                        }

                    case .failure(let error):
                        print("Failed to retrieve customer ID: \(error)")
                        // Handle the error as needed
                    }
                }
                
            }
      /*      self.signInVM.getCustomerId { result in
                switch result {
                case .success(let customerId):
                    print("Customer ID: \(customerId)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }*/
     //       self.present(tabBar, animated: true)

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
        self.signInVM.create(email: userEmail) { result in
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
        self.signInVM.getCustomerId(email: userEmail) { result in
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
