//
//  SignInWithAccount.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 27/10/2023.
//

import Foundation
import FirebaseAuth

class FireBaseSignInViewModel{
    /*
    func signInWithAccount(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                // Check for errors during sign-in
                if let error = error {
                    // Handle sign-in error
                    print("Sign-in error: \(error.localizedDescription)")
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
            self.present(tabBar, animated: true)

            }
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
    }*/
}

