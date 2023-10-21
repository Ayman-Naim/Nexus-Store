//
//  AddPromoCodeViewController.swift
//  Nexus-Store
//
//  Created by Khater on 20/10/2023.
//

import UIKit

class AddPromoCodeViewController: UIViewController {
    
    
    @IBOutlet weak var promoCodeTextField: CustomTextField!
    @IBOutlet weak var promoCodeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var promoDiscountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Promo Code"
        
        promoCodeTextField.delegate = self
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        guard let promoCode = promoCodeTextField.text, !promoCode.isEmpty else {
            return
        }
        
        promoCodeLabel.text = "#" + promoCode
    }
    
    @IBAction func showOrdersButtonPressed(_ sender: UIButton) {
        self.present(ProductsOrderSheetTVC.sheet(), animated: true)
    }
    
    @IBAction func continueToPaymentButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(PayMethodViewController(), animated: true)
    }
    
}


// MARK: - UITextField Delegate
extension AddPromoCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
