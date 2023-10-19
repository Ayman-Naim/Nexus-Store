//
//  AddAddressViewController.swift
//  Nexus-Store
//
//  Created by Khater on 19/10/2023.
//

import UIKit

class AddAddressViewController: UIViewController {
    
    
    private let addAddressView = AddAddressView()

    override func loadView() {
        super.loadView()
        self.view = addAddressView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Address"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    
}
