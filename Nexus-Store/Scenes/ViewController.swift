//
//  ViewController.swift
//  Nexus-Store
//
//  Created by ayman on 17/10/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func ayman() {
        let vc = HomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = ProfileViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func mostafa() {
        
        let vc = CategoryViewController(nibName: K.categoryNibID, bundle: nil)
         vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func khater() {
        self.navigationController?.pushViewController(CartViewController(), animated: true)
        
    }
    @IBAction func ahmed() {
        let vc = WelcomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

