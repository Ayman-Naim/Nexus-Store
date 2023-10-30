//
//  AddProductViewController.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import UIKit

class AddProductViewController: UIViewController {
    
    var MenuItemArray : [String] = []
    var menuItemsArray: [UIAction] = []
    
    
    @IBOutlet weak var VendorDropDown: UIButton!
    @IBOutlet weak var TypeSegment: UISegmentedControl!
    @IBOutlet weak var ProductTitle: UITextField!
    @IBOutlet weak var ProductCategory: UISegmentedControl!
    @IBOutlet weak var ProductDescription: UITextField!
    
    
    var viewModel :AddProductVM = AddProductVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVendorDropDown()
        setupTypeSegmentControl()
    }
    
    
    
    @IBAction func AddButtonClicked(_ sender: Any) {
        guard let title = ProductTitle.text ,!title.isEmpty,
              let type  = TypeSegment.titleForSegment(at:TypeSegment.selectedSegmentIndex) ,!type.isEmpty,
              let description  = ProductDescription.text ,!description.isEmpty,
              let vendor  = VendorDropDown.currentTitle,!vendor.isEmpty,
              let category = ProductCategory.titleForSegment(at: ProductCategory.selectedSegmentIndex), !category.isEmpty
        else{
            Alert.show(on: self, title: "Add Product", message: "All fileds must be not empty")
            return
        }
        
        viewModel.AddProduct(title: title, type: type, Descriotion: description, vendor: vendor,category:category){
            result in
            switch result {
            case.success(let product):
                print(product)
                self.navigationController?.popViewController(animated: true)
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func setupVendorDropDown(){
        let optionClosure =  { (action:UIAction) in
            self.settitle(action: action)
        }
        
        viewModel.getBrands { result in
            switch result{
            case .success(let brands):
                self.MenuItemArray =  brands.compactMap{$0.title}
                for itemTitle in self.MenuItemArray {
                    
                    let action  = UIAction(title: itemTitle, handler:optionClosure)
                    self.menuItemsArray.append(action)
                }
                self.menuItemsArray.first?.state = .on
                self.VendorDropDown.menu = UIMenu(children:self.menuItemsArray)
                
                self.VendorDropDown.showsMenuAsPrimaryAction = true
                self.VendorDropDown.changesSelectionAsPrimaryAction = true
                
                
                
            case.failure(let error):
                Alert.show(on: self, title: "get brands", message: error.localizedDescription)
            }
        }
    }
    
    func setupTypeSegmentControl() {
        TypeSegment.removeAllSegments()
        for index in ProductType.allCases.indices {
            TypeSegment.insertSegment(withTitle: ProductType.allCases[index].rawValue, at: index, animated: true)
        }
        TypeSegment.selectedSegmentIndex = 0
    }
    
    func  settitle(action: UIAction) {
        self.VendorDropDown.titleLabel?.text = action.title
    }
    
}

