//
//  AddAddressViewController.swift
//  Nexus-Store
//
//  Created by Khater on 19/10/2023.
//

import UIKit


protocol AddAddressDelegate: AnyObject {
    func didAddNewAddress()
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
        
        guard validatePhoneNumber(phone) else {
            Alert.show(on: self, title: "Phone number", message: "Invalid phone number")
            return
        }
        
        viewModel.addAdress(name: name, city: city, adddress: address, Phone: phone) { result in
            switch result{
            case .success(let data ):
                guard data.singleResult != nil else { return }
                self.delegate?.didAddNewAddress()
                self.navigationController?.popViewController(animated: true)
               
            case.failure(let error):
                    Alert.show(on: self, title: "Add Adress Error", message: "these Addtess Data Already found please change the details or go back to adress list ")
                
                return
            }
        }
        
        func validatePhoneNumber(_ phoneNumber: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,11}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            let arrString = Array(phoneNumber)
            return arrString.count > 2 && phoneNumber.first == "0" && arrString[1] == "1" && phoneTest.evaluate(with: phone)
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
