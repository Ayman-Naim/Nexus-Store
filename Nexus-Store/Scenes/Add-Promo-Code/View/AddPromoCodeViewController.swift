//
//  AddPromoCodeViewController.swift
//  Nexus-Store
//
//  Created by Khater on 20/10/2023.
//

import UIKit
import Lottie

class AddPromoCodeViewController: UIViewController {
    
    @IBOutlet weak var addCopouns: UIButton!
    
    @IBOutlet weak var ContinuePayment: UIButton!
    @IBOutlet weak var showOrders: UIButton!
    @IBOutlet weak var promoCodeTextField: CustomTextField!
    @IBOutlet weak var promoCodeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var promoDiscountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    let myView : LottieAnimationView = .init()
    
    //MARK: - Take form Last Screen
    var orderPrice = 200.00
    var usesCoupon = false

    //MARK: - Discount Code Dummy
    var discountCode = DiscountCode(id: 17022107484396, priceRuleID: 1525907194092, code: "SUMMERSALE10OFF", usageCount: 0, createdAt: "2023-10-30T03:56:31-04:00", updatedAt: "2023-10-30T03:56:31-04:00")
    
    
    var addPromoCodeViewModel:AddPromoCodeViewModel?
    var priceRule:PriceRule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Promo Code"
        promoCodeTextField.delegate = self
    }
    
    
    
   //MARK: - Fire TO Use Copouns
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        
        if usesCoupon == false{
            usesDiscountOFCoupons()
            usesCoupon = true
        }else{
            resetAmountData()
            usesCoupon = false
        }
        

    }
    
    
    
    //MARK: - Reset Amount For Total Amount
    func resetAmountData(){
        
        promoCodeTextField.text = ""
        amountLabel.text = "$\(orderPrice)"
        promoDiscountLabel.text = "$0"
        totalPriceLabel.text =  "$\(orderPrice)"
        
    }
    
    
    
    
    //MARK: - Fire To Use Copuns
    func usesDiscountOFCoupons(){
        stateOfButton(isEnable: false)
        
        //Take theis Paramter From Ayman
   
        addPromoCodeViewModel?.fetchDataOfPriceRule(priceRuleID: discountCode.priceRuleID)
        addPromoCodeViewModel?.bindPriceRuleFromApi = { [weak self] in
            
            DispatchQueue.main.async {
                //Change it To Coupoun
             //   self?.addCopouns.titleLabel?.text = self?.discountCode.code
                self?.promoCodeTextField.text = self?.discountCode.code

            }
          //  self?.addCopouns.titleLabel?.text  = self?.discountCode.code
            self?.priceRule = self?.addPromoCodeViewModel?.retrivePriceRule()
            self?.addPromoCodeViewModel?.checkUsageOfCoponusAvaliable(Handel: { checkAvalibality in
                if checkAvalibality{
                    DispatchQueue.main.async {
                        self?.promoDiscountLabel.text = "$\(self?.addPromoCodeViewModel?.discountAmount() ?? "-0.0")"
                        self?.totalPriceLabel.text = "$\(self?.addPromoCodeViewModel?.returnAmountAfterDiscount(orderPrice: self?.amountLabel.text, dicountPrice:self?.promoDiscountLabel.text) ?? "-0.0")"
                        self?.luanchSavingAnimation()
                    }
                }else{
                    Alert.show(on: self!, title: "Coupon Invalid", message: "Coupon usage limit has been reached")
                }
            })
            self?.stateOfButton(isEnable: true)
            
            
        }
    }
    
    
    //MARK: - Show all Orders to purchase
    @IBAction func showOrdersButtonPressed(_ sender: UIButton) {
        self.present(ProductsOrderSheetTVC.sheet(), animated: true)
       
    }
    
    
    //MARK: - Go To Payment after user Decreament usage Copouns
    @IBAction func continueToPaymentButtonPressed(_ sender: UIButton) {
        //Take Data From Ayman Not Dummy from Text
        if usesCoupon{ self.addPromoCodeViewModel?.updatePriceRuleLimit(priceRuleID:discountCode.priceRuleID)}
        self.navigationController?.pushViewController(PayMethodViewController(), animated: true)
    }
    
}



// MARK: - UITextField Delegate
extension AddPromoCodeViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.endEditing(true)
//    }
    
    func stateOfButton(isEnable:Bool){
        addCopouns.isEnabled = isEnable
        showOrders.isEnabled = isEnable
        ContinuePayment.isEnabled = isEnable
       
    }
}



//MARK: - Animation
extension AddPromoCodeViewController{
    func luanchSavingAnimation(){
        myView.animation = .named("SaveMoney")
        myView.loopMode = .loop
        myView.frame = CGRect(x: 0, y: 0, width: 600, height: 250)
        myView.center = CGPointMake(myView.frame.maxX/1.25, myView.frame.height/0.16)
        myView.center = view.center
        view.addSubview(myView)
        myView.contentMode = .scaleAspectFit
        myView.backgroundColor = .clear
        myView.play()
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(setSavingAnimation), userInfo: nil, repeats: false)
    }
    
    
    @objc func setSavingAnimation(){
        myView.removeFromSuperview()
    }
}
