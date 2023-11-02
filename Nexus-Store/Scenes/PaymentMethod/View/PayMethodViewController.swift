//
//  PayMethodViewController.swift
//  Nexus-Store
//
//  Created by ayman on 20/10/2023.
//

import UIKit
import PassKit

class PayMethodViewController: UIViewController {

    @IBOutlet weak var PaymentTable: UITableView!
    @IBOutlet weak var TotalAmountLabel: UILabel!
    var selectedPayment:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewSetup()
        self.PaymentTable.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
    }


    func TableViewSetup(){
        //
        PaymentTable.delegate = self
        PaymentTable.dataSource = self
        PaymentTable.register(UINib(nibName: "PaymentTableViewCell", bundle:nil), forCellReuseIdentifier: "PaymentTableViewCell")
    }

    @IBAction func PayButtonClicked(_ sender: Any) {
        //
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
            request.merchantIdentifier = "merchant.com.shopifyApp.ITI"
            request.supportedNetworks = [.visa, .masterCard, .quicPay]
            request.supportedCountries = ["US", "EG", "QA", "AE", "SA"]
            request.merchantCapabilities = .capability3DS
            
            request.countryCode = "EG"
            request.currencyCode = "EGP"
            
     //       finalTotalCost = UserDefaultsHelper.shared.getFinalTotalCost()
     //       let roundedCost = Double(String(format:"%.2f", finalTotalCost)) ?? 1.00
   //         let _ = (finalTotalCost * 100).rounded() / 100
   //         let amount = NSDecimalNumber(value: roundedCost)
   //         request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Order Cost", amount: amount)]
            
            return request
        }
    
    private func presentPaymentController() {
            let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            if controller != nil {
                controller!.delegate = self
                self.present(controller!, animated: true) {
                    print("Completed Order")
                }
            }
        }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
    //        self.finalTotalCost = 0.0
            // TODO: - Get currency Symbol and add it after final cost on label
   //         self.totalLabel.text = "\(0.0) EGP"
            //viewModel.decreaseVariantCountByOrderAmount()
   //         self.viewModel.postOrder()
    //        self.playAnimation()
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult.init(status: .success, errors: nil))
    }
    
}

