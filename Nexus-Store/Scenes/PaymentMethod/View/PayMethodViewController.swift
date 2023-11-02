//
//  PayMethodViewController.swift
//  Nexus-Store
//
//  Created by ayman on 20/10/2023.
//

import UIKit
import PassKit
import BraintreeCore
import BraintreePayPal

class PayMethodViewController: UIViewController {

    @IBOutlet weak var PaymentTable: UITableView!
    @IBOutlet weak var TotalAmountLabel: UILabel!
    var selectedPayment:IndexPath?
    
    // for testing
    var totalAmount: Double = 250.0
    let authorization = "sandbox_8h3qzxnj_76tbywh3qkq2yw2k"
    var braintreeAPIClient:BTAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewSetup()
        self.PaymentTable.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
        TotalAmountLabel.text = "\(totalAmount) $"
    }


    func TableViewSetup(){
        //
        PaymentTable.delegate = self
        PaymentTable.dataSource = self
        PaymentTable.register(UINib(nibName: "PaymentTableViewCell", bundle:nil), forCellReuseIdentifier: "PaymentTableViewCell")
    }

    @IBAction func PayButtonClicked(_ sender: Any) {
        //
        presentPaymentController()
    }
}

extension PayMethodViewController:UITableViewDelegate,UITableViewDataSource, PKPaymentAuthorizationViewControllerDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.row{
        case 0:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
            cell.PayMethodName.text = "Cash on Delivey"
            cell.PaymMethodLogo.image = UIImage(named: "Wallet")
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
            cell.PayMethodName.text = "PayPal"
            cell.PaymMethodLogo.image = UIImage(named: "Paypal-Logo")
            return cell
        case 2 :
            let cell =  tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
            cell.PayMethodName.text = "Apple Pay"
            cell.PaymMethodLogo.image = UIImage(named: "ApplePay")
            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
            cell.PayMethodName.text = "Cash on Delivey"
            cell.PaymMethodLogo.image = UIImage(named: "Paypal-Logo")
            return cell
            
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0,2:
            print("0, 2")
        case 1:
            print("1")
        default:
            print("Thanks")
        }
        if selectedPayment != nil {
            guard let previusSelectedcell  = tableView.cellForRow(at: selectedPayment!) as? PaymentTableViewCell else{return}
            
            previusSelectedcell.checkedBox.image = UIImage(named: "unchecked")
            guard let cell = tableView.cellForRow(at: indexPath) as? PaymentTableViewCell else {
                return}
            
            cell.checkedBox.image = UIImage(named: "checked")
            selectedPayment = indexPath
        }else{
            selectedPayment = indexPath
            guard let cell = tableView.cellForRow(at: indexPath) as? PaymentTableViewCell else {
                return}
            
            cell.checkedBox.image = UIImage(named: "checked")
            
        }
    }
    
    private var paymentRequest: PKPaymentRequest {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.Nexus-Store"
            request.supportedNetworks = [.visa, .masterCard, .amex] // Include the supported card networks
            request.supportedCountries = ["US"] // Include supported countries
            request.merchantCapabilities = .capability3DS
            request.countryCode = "US" // Set the country code
            request.currencyCode = "USD" // Set the currency code
            let amount = NSDecimalNumber(value: totalAmount)
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Total", amount: amount)]
            return request
        }

        private func presentPaymentController() {
            let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            if let controller = controller {
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }

        func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

            let alert = UIAlertController(title: "Payment Successful", message: "Thank you for your purchase.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            }))
            controller.present(alert, animated: true, completion: nil)
        }

        func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
            controller.dismiss(animated: true) {
            //    self.showAlert(title: "Payment Successful", message: "Thank you for your purchase.")
                
            }
        }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

