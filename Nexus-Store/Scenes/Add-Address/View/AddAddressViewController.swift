//
//  AddAddressViewController.swift
//  Nexus-Store
//
//  Created by Khater on 19/10/2023.
//

import UIKit


protocol AddAddressDelegate: AnyObject {
    func didAddNewAddress(_ address: (name: String, city: String, address: String))
}


class AddAddressViewController: UIViewController {
    
    private let addAddressView = AddAddressView()
    weak var delegate: AddAddressDelegate?
    private var viewModel :AddAddressVM = AddAddressVM()
    override func loadView() {
        super.loadView()
        self.view = addAddressView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Address"
        
        setupElements()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setupElements() {
        addAddressView.nameTextField.delegate = self
        addAddressView.cityTextField.delegate = self
        addAddressView.addressTextField.delegate = self
        
        addAddressView.addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    
    @objc private func addButtonPressed() {
        guard
            let name = addAddressView.nameTextField.text, !name.isEmpty,
            let city = addAddressView.cityTextField.text, !city.isEmpty,
            let address = addAddressView.addressTextField.text, !address.isEmpty,
            let phone = addAddressView.PhoneTextField.text ,!phone.isEmpty
        else {
            Alert.show(on: self, title: "Address", message: "All fileds must be not empty")
            return
        }
        viewModel.addAdress(name: name, city: city, adddress: address, Phone: phone) { result in
            switch result{
            case .success(let data ):
                
                
                guard let address1 = data.customer_address?.address1 ,
                      let city1 = data.customer_address?.city,
                      let name1 = data.customer_address?.name
                else {
                    return
                }
                self.delegate?.didAddNewAddress((name1 , city1, address1 ))
                self.navigationController?.popViewController(animated: true)
               
            case.failure(let error):
                    Alert.show(on: self, title: "Add Adress Error", message: "these Addtess Data Already found please change the details or go back to adress list ")
                
                return
            }
        }
       
    }
    
    deinit {
        print("AddAddressViewController deinit")
    }
}


// MARK: - UITextField Delegate
extension AddAddressViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case addAddressView.nameTextField:
            addAddressView.cityTextField.becomeFirstResponder()
            return false
            
        case addAddressView.cityTextField:
            addAddressView.addressTextField.becomeFirstResponder()
            return false
        case addAddressView.addressTextField:
            addAddressView.PhoneTextField.becomeFirstResponder()
            return false
        default:
            textField.endEditing(true)
            return true
        }
    }
}
