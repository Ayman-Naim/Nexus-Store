//
//  PayMethodViewController.swift
//  Nexus-Store
//
//  Created by ayman on 20/10/2023.
//

import UIKit
import BraintreeCore
import BraintreeApplePay
import BraintreePayPal

class PayMethodViewController: UIViewController {

    @IBOutlet weak var PaymentTable: UITableView!
    @IBOutlet weak var TotalAmountLabel: UILabel!
    let authorization = "sandbox_8h3qzxnj_76tbywh3qkq2yw2k"
    var braintreeAPIClient:BTAPIClient!
    
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
        if selectedPayment?.row == 0 {
            
        } else if selectedPayment?.row == 1 {
            let total = Double(TotalAmountLabel.text ?? "") ?? 0.0
      //      self.paypalCheckout(amount: total)
        } else {
            
        }
    }
}
extension PayMethodViewController:UITableViewDelegate,UITableViewDataSource{
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
        switch indexPath.row{
            case 0:
                print("Cash")
            case 1:
                print("paypal")
            case 2:
                print("apple")
            default:
                print("nothing")
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
/*
    func paypalCheckout(amount: Double) {
        self.braintreeAPIClient = BTAPIClient(authorization: authorization)
        let payPalDriver = BTPayPalClient(apiClient: braintreeAPIClient!)
        let request = BTPayPalCheckoutRequest(amount: "\(amount)")
   /*     if ApplicationUserManger.shared.getSelectedCurrency(){
            request.currencyCode = "USD"
        }else{
            request.currencyCode = "EGP"
        }*/
        var err:Error?
        payPalDriver.tokenize(request) { [weak self] (tokenizedPayPalAccount, error) in
            if tokenizedPayPalAccount != nil {
            } else if let error = error {
                err = error
                print("error is \(error)")
            }
            if err == nil{
          //      let orders = CoreDataManager.shared.fetchDataFromCart()
          //      self!.ViewModel.postOrdersToApi(cartArray: orders)
                let alert = UIAlertController(title: "Successfull Payment!", message: "Thanks For Dealing With Us", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Go Shopping", style: .default) { _ in
                    // Navigate to the Home view controller
                    let home = HomeViewController()
                    self?.navigationController?.pushViewController(home, animated: true)
                })
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }*/
}
