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
    var id: Int? = 0
    let paymentVM = PaymentViewModel()
    let customerID = UserDefaults.standard.value(forKey: "customerID")

    // for testing
    var totalAmount: Double = 0.0
    var convertPrice = ConvertPrice()
//    let authorization = "sandbox_8h3qzxnj_76tbywh3qkq2yw2k"
//    var braintreeAPIClient:BTAPIClient!
//    var payPalNativeCheckoutClient: BTPayPalNativeCheckoutClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewSetup()
        self.PaymentTable.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
        self.totalPriceAmount()
    }

    func totalPriceAmount() {
        guard let customerID = customerID as? Int else {
            return
        }

        paymentVM.draftOrder.customerDraftOrder(customerID: customerID) { result in
            switch result {
            case .success(let draftOrder):
                if let totalPrice = Double(draftOrder.totalPrice) {
                    self.totalAmount = totalPrice
           //         print(self.totalAmount)
                    DispatchQueue.main.async {
                        let price = self.convertPrice.convertPrice(price: self.totalAmount)
                        if self.convertPrice.getSelectedCurrency() == true {
                            self.TotalAmountLabel.text = "\(price) $"
                        }else{
                            self.TotalAmountLabel.text = "\(price) EGP"
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching draft order: \(error)")
            }
        }
    }

    func TableViewSetup(){
        //
        PaymentTable.delegate = self
        PaymentTable.dataSource = self
        PaymentTable.register(UINib(nibName: "PaymentTableViewCell", bundle:nil), forCellReuseIdentifier: "PaymentTableViewCell")
    }

    @IBAction func PayButtonClicked(_ sender: Any) {
        paymentVM.draftOrder.customerDraftOrder(customerID: customerID as! Int) { result in
            switch result{
            case .success(let order):
                self.id = order.id
                print("order id is : \(self.id ?? 0)")
            case .failure(_):
                print("Error")
            }
        }
   //     presentPaymentController()
        if selectedPayment?.row == 0{
            let alert = UIAlertController(title: "Cash On Delivery", message: "Are You Sure You Want To Pay Cash On Delivery?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                let alert = UIAlertController(title: "Successful Process!", message: "The Order Will Be Sent To Your Address, Thanks For Dealing With Us!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                    self.paymentVM.updatePaymentOfDraftOrder(draft_order_id: self.id ?? 0, paymentPending: true) { result in
                        if let result = result {
                            self.paymentVM.deleteFullDraftOrder(customerID: self.customerID as! Int) { error in
                                print(error.localizedDescription)
                            }
                        }
                    }
                    self.navigateToRoot()
                }))
                self.present(alert, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else if selectedPayment?.row == 1{
      //      self.paypalCheckout(amount: totalAmount)
        }else if selectedPayment?.row == 2{
            self.presentPaymentController()
        }
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

            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }

        func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
            controller.dismiss(animated: true) {
            //    self.showAlert(title: "Payment Successful", message: "Thank you for your purchase.")
                let alert = UIAlertController(title: "Payment Successful", message: "Thank you for your purchase.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.paymentVM.updatePaymentOfDraftOrder(draft_order_id: self.id ?? 0, paymentPending: false) { result in
                        if let result = result {
                            self.paymentVM.deleteFullDraftOrder(customerID: self.customerID as! Int) { error in
                                print(error.localizedDescription)
                            }
                        }
                    }
                    self.navigateToRoot()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToRoot(){
   /*     if let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as? SceneDelegate {
       //     let nav = UINavigationController(rootViewController: NexusTabBarController())
            self.navigationController?.popToRootViewController(animated: true)
       //     sceneDelegate.window!.rootViewController = nav
        }*/
        if let tabBarController = self.tabBarController {
            // 2. Get the navigation controller associated with the specific tab.
            if let nav = tabBarController.viewControllers?[0] as? UINavigationController {
                // 3. Pop to the root view controller of the specific tab.
                nav.popToRootViewController(animated: true)
            }
        }
    }
    
    /*
    func paypalCheckout(amount: Double) {
        self.braintreeAPIClient = BTAPIClient(authorization: authorization)
        let payPalDriver = BTPayPalClient(apiClient: braintreeAPIClient!)
 /*       let request = BTPayPalNativeCheckoutRequest(amount: "\(amount)")
        request.currencyCode = "USD"
        payPalNativeCheckoutClient.tokenize(request) { payPalNativeCheckoutNonce, error in
            if let payPalNativeCheckoutNonce = payPalNativeCheckoutNonce {
                // send payPalNativeCheckoutNonce.nonce to server
                print("Ashraf")
            } else {
                // handle error
                print("Ayman")
            }
        }*/
        let request = BTPayPalCheckoutRequest(amount: "\(amount)")
        request.currencyCode = "USD"
        let payPalClient = BTPayPalClient(apiClient: self.braintreeAPIClient)
        let vaultRequest = BTPayPalVaultRequest()
        payPalClient.tokenize(request) { (tokenizedPayPalAccount, error) in
            print(tokenizedPayPalAccount ?? "nil")
        }
   /*     if ApplicationUserManger.shared.getSelectedCurrency(){
            request.currencyCode = "USD"
        }else{
            request.currencyCode = "EGP"
        }*/
        var err:Error?
        payPalDriver.tokenize(request) { [weak self] (tokenizedPayPalAccount, error) in
            if tokenizedPayPalAccount != nil {
                print("log el mon")
            } else if let error = error {
                err = error
                print(String(describing: error))
            }
            if err == nil{
          //      let orders = CoreDataManager.shared.fetchDataFromCart()
          //      self!.ViewModel.postOrdersToApi(cartArray: orders)
                let alert = UIAlertController(title: "Successfull Payment!", message: "Thanks For Dealing With Us", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Go Shopping", style: .default) { _ in
                    // Navigate to the Home view controller
                    let home = NexusTabBarController()
                    self?.navigationController?.pushViewController(home, animated: true)
                })
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func presentDropInUI() {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: authorization, request: request) { (controller, result, error) in
            if let error = error {
                // Handle error
                print("Braintree error: \(error.localizedDescription)")
            } else if result?.isCancelled == true {
                // Handle user cancellation
            } else if let nonce = result?.paymentMethod?.nonce {
                // Nonce is available, send it to your server for further processing
                self.sendPaymentNonceToServer(nonce)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }*/
}

