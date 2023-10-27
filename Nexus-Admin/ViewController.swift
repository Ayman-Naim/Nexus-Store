//
//  ViewController.swift
//  Nexus-Admin
//
//  Created by ayman on 23/10/2023.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func ayman(_ sender: Any) {
        let vc = SignInViewController()
        let nav1 = UINavigationController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
    }
    @IBAction func khater(_ sender: Any) {
    }
    
    @IBAction func mostafa(_ sender: Any) {
    }
    
    @IBAction func ahmed(_ sender: Any) {
    }
}

