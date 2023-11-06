//
//  AddPromoCodeViewController.swift
//  Nexus-Admin
//
//  Created by Khater on 04/11/2023.
//

import UIKit

class AddPromoCodeViewController: UIViewController {
    
    private let viewModel = AddPromoCodeViewModel()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var discountTitleTextField: UITextField!
    @IBOutlet weak var startAtDatePicker: UIDatePicker!
    @IBOutlet weak var endAtDatePicker: UIDatePicker!
    @IBOutlet weak var discountAmountTextField: UITextField!
    @IBOutlet weak var discountTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var usageLimitTextField: UITextField!
    @IBOutlet weak var promoCodeTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Promo Code"
        
        bindViewModel()
    }
    
    
    // MARK: - IBActions
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard
            let discountTitle = discountTitleTextField.text, !discountTitle.isEmpty,
            let promoCode = promoCodeTextField.text, !promoCode.isEmpty,
            let amount = discountAmountTextField.text, !amount.isEmpty,
            let usageLimit = usageLimitTextField.text, !usageLimit.isEmpty
        else {
            Alert.show(on: self, title: "Faild", message: "Fields can't be empyt, Please fill all fields")
            return
        }
        
        
        viewModel.addPromoCode(discountTitle: discountTitle,
                               promoCode: promoCode,
                               amount: amount,
                               type: discountTypeSegmentControl.selectedSegmentIndex,
                               usageLimit: usageLimit,
                               startAt: startAtDatePicker.date,
                               endAt: endAtDatePicker.date)
    }
    
    
    // MARK: - Functions
    private func bindViewModel() {
        viewModel.navigate = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.errorAlert = { [weak self] title, message in
            guard let self = self else { return }
            Alert.show(on: self, title: title, message: message)
        }
    }
}
