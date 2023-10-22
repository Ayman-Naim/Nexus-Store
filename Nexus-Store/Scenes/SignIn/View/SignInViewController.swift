//
//  SignInViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func singInButtonPressed(_ sender: Any) {
        let nav = UINavigationController(rootViewController: NexusTabBarController())
        nav.modalPresentationStyle = .fullScreen
        let tabBar = NexusTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        //nav.isNavigationBarHidden = true
        self.present(tabBar, animated: true)
    }
    
    
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        let signupVC = SignUpViewController()
        //signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true)
    }
    
}
