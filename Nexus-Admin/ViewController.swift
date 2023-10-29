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
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func khater(_ sender: Any) {
        let nav = UINavigationController(rootViewController: ProductDetailsViewController())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    @IBAction func mostafa(_ sender: Any) {
        let brandViewModel = BrandProductViewModel(brandId: 413225648364)
        let vc = BrandProductsViewController()
        vc.brandProductDelegation = brandViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ahmed(_ sender: Any) {
    }
}

