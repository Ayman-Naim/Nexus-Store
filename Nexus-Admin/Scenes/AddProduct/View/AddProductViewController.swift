//
//  AddProductViewController.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var VendorTitle: UITextField!
    @IBOutlet weak var ProductTitle: UITextField!
    @IBOutlet weak var ProductType: UITextField!
    @IBOutlet weak var ProductDescription: UITextField!
    var viewModel :AddProductVM = AddProductVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    

    @IBAction func AddButtonClicked(_ sender: Any) {
        guard let title = ProductTitle.text ,!title.isEmpty,
              let type  = ProductType.text ,!type.isEmpty,
              let description  = ProductDescription.text ,!description.isEmpty,
              let vendor  = VendorTitle.text ,!vendor.isEmpty
        else{
            Alert.show(on: self, title: "Add Product", message: "All fileds must be not empty")
            return
        }
        viewModel.AddProduct(title: title, type: type, Descriotion: description, vendor: vendor)
        self.dismiss(animated: true)
    }
   

}
