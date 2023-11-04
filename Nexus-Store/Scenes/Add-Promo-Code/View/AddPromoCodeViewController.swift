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
    var usesCoupon = false

    //MARK: - Discount Code Dummy
//    var discountCode = DiscountCode(id: 17022107484396, priceRuleID: 1525907194092, code: "SUMMERSALE10OFF", usageCount: 0, createdAt: "2023-10-30T03:56:31-04:00", updatedAt: "2023-10-30T03:56:31-04:00")
    
    override func viewWillAppear(_ animated: Bool) {
        addPromoCodeViewModel?.fetchOrderFromDraftOrder()
    }
    
    var addPromoCodeViewModel:AddPromoCodeViewModel?
    var priceRule:PriceRule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Promo Code"
        isLoadingIndicatorAnimating = true
        addPromoCodeViewModel?.fetchOrderFromDraftOrder()
        addPromoCodeViewModel?.bindDaftOrderFromApi = { [weak self] in
            if let totalPrice = self?.addPromoCodeViewModel?.retriveDraftOrder?.totalPrice{
                self?.amountLabel.text = "$\(totalPrice)"
                self?.totalPriceLabel.text = "$\(totalPrice)"
            }
            self?.isLoadingIndicatorAnimating = false
            
            
        }
        
        
    }
    
    
    
   //MARK: - Fire TO Use Copouns
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        if addPromoCodeViewModel?.retriveDraftOrder?.applied_discount == nil {
            if usesCoupon == false{
                addPromoCodeViewModel?.getDiscountCopoune(Handel: { copounExist, error in
                    if copounExist == true{
                        self.usesDiscountOFCoupons()
                        self.usesCoupon = true
                    }
                    else{
                        Alert.show(on: self, title: "Alert!", message: "There is No Copouns To Apply Discount ?!.")
                    }
                })
                
            }else{
                resetAmountData()
                usesCoupon = false
            }
        }else{
            
            Alert.show(on: self, title: "Not Allowed 🤡", message: "You Can't Uses More Than One Coupons For The Order !")
            
        }
        

    }
    
    
    
    //MARK: - Reset Amount For Total Amount
    func resetAmountData(){
        
        promoCodeTextField.text = ""
        amountLabel.text = "$\((self.addPromoCodeViewModel?.retriveDraftOrder!.totalPrice)!)"
        promoDiscountLabel.text = "$0"
        totalPriceLabel.text =  "$\((self.addPromoCodeViewModel?.retriveDraftOrder!.totalPrice)!)"
        
    }
    
    
    
    
    //MARK: - Fire To Use Copuns
    func usesDiscountOFCoupons(){
//        stateOfButton(isEnable: false)
        isLoadingIndicatorAnimating = true
        //Take theis Paramter From Ayman
   
        addPromoCodeViewModel?.fetchDataOfPriceRule(priceRuleID: (addPromoCodeViewModel?.retriveDiscountCopounsFromUserDefualt()?.priceRuleID)!)
        addPromoCodeViewModel?.bindPriceRuleFromApi = { [weak self] in
            
            DispatchQueue.main.async {
                //Change it To Coupoun
             //   self?.addCopouns.titleLabel?.text = self?.discountCode.code
                self?.promoCodeTextField.text = (self?.addPromoCodeViewModel?.retriveDiscountCopounsFromUserDefualt()?.code)!

            }
          //  self?.addCopouns.titleLabel?.text  = self?.discountCode.code
            self?.priceRule = self?.addPromoCodeViewModel?.retrivePriceRule()
            self?.addPromoCodeViewModel?.checkUsageOfCoponusAvaliable(Handel: { checkAvalibality in
                if checkAvalibality{
                    DispatchQueue.main.async {
                        
                        self?.promoDiscountLabel.text = "$\(self?.addPromoCodeViewModel?.discountAmount() ?? "-0.0")"
                        self?.totalPriceLabel.text = "$\(self?.addPromoCodeViewModel?.returnAmountAfterDiscount(orderPrice: self?.amountLabel.text, dicountPrice:self?.promoDiscountLabel.text) ?? "-0.0")"
                        self?.luanchSavingAnimation()
                        self?.isLoadingIndicatorAnimating = false
                    }
                }else{
                    self?.isLoadingIndicatorAnimating = false
                    Alert.show(on: self!, title: "Coupon Invalid", message: "Coupon usage limit has been reached")
                }
            })
//            self?.stateOfButton(isEnable: true)
            
            
        }
    }
    
    
    //MARK: - Show all Orders to purchase
    @IBAction func showOrdersButtonPressed(_ sender: UIButton) {
        self.present(ProductsOrderSheetTVC.sheet(), animated: true)
       
    }
    
    
    
    
    
    
    //MARK: - Go To Payment after user Decreament usage Copouns
    @IBAction func continueToPaymentButtonPressed(_ sender: UIButton) {
        //Take Data From Ayman Not Dummy from Text
            //Incremant copouns usage By one
            //Remove Copous from User Default
            //increamt total price after discount
            dataUpdatedToGoToPayment()
           
            
       
    }
    
    
    //MARK: - Increamt Copouns Usage and Modify total amout of Order remove Copouns
    func dataUpdatedToGoToPayment(){
       
        let cancelPayment = UIAlertAction(title: "Cancel", style: .default,handler: nil)
        let forwardToPayment = UIAlertAction(title: "Ok", style: .destructive) { action in
            
            if self.usesCoupon == true{
                self.addPromoCodeViewModel?.applyDiscountToOrder(Handel: { checkUpdate in
                    if checkUpdate == true{
                        print("Data put Successfully")
                        self.addPromoCodeViewModel?.removeCopounsFromUserDefaults()
                        self.addPromoCodeViewModel?.updatePriceRuleLimit(priceRuleID: (self.addPromoCodeViewModel?.retriveDiscountCopounsFromUserDefualt()?.priceRuleID)!)
                        self.navigationController?.pushViewController(PayMethodViewController(), animated: true)
                    }else{
                        print("There is an error in put Response")
                    }
                })
            }else{
                self.navigationController?.pushViewController(PayMethodViewController(), animated: true)
            }
        }
        Alert.show(on: self, title: "BeCare!", message: "Are you Sure To Go to Payment Process",actions: [cancelPayment,forwardToPayment])
        
       
        
    }
    
}



// MARK: - UITextField Delegate
extension AddPromoCodeViewController: UITextFieldDelegate {

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
