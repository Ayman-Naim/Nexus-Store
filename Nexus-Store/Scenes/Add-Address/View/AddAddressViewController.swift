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
        navigationController?.popViewController(animated: true)
        delegate?.didAddNewAddress((name, city, address))
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
            
        default:
            textField.endEditing(true)
            return true
        }
    }
}
