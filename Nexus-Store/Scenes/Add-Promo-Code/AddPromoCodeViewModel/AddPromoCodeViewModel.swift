//
//  AddPromoCodeViewModel.swift
//  Nexus-Store
//
//  Created by Mustafa on 29/10/2023.
//

import Foundation
import Alamofire
protocol AddPromoCodeProtocaol{
    var bindPriceRuleFromApi:(()->Void)? {get set}
    func fetchDataOfPriceRule(priceRuleID:Int)
    func retrivePriceRule()->PriceRule?
    func checkUsageOfCoponusAvaliable(Handel:@escaping (Bool)->Void)
    func discountAmount()->String?
    func returnAmountAfterDiscount(orderPrice:String?,dicountPrice:String?)->String?
    func updatePriceRuleLimit(priceRuleID:Int)
    func getDiscountCopoune(Handel:@escaping((Bool?,Error?) -> Void))
    func fetchOrderFromDraftOrder()
    func retriveDraftOrder()->DraftOrder?
    func applyDiscountToOrder(Handel:@escaping(Bool)->Void)
    var bindDaftOrderFromApi:(()->Void)?{get}
    
}

class AddPromoCodeViewModel:AddPromoCodeProtocaol{
    var bindDaftOrderFromApi: (() -> Void)?
    
   
    
    
    private let header: HTTPHeaders = [
        "X-Shopify-Access-Token": "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",
        "Content-Type": "application/json"
    ]
    
    
    
    
    //MARK: - Properties
    let draftOrderservices = DraftOrderService()
    var discountCode: DiscountCode?
    let custemerID = K.customerID
    let apiManager = ApiManger.SharedApiManger
    var draftOrder:DraftOrder?{
        didSet{
            bindDaftOrderFromApi?()
        }
    }
    
    
    
    
    var priceRule:PriceRule?{
        didSet{
            if let validPriceRule = bindPriceRuleFromApi{
                validPriceRule()
            }
        }
    }
    
    //MARK: - Closure
    var bindPriceRuleFromApi: (() -> Void)?
    //MARK: - Retrive Price Rule
    func retrivePriceRule() ->PriceRule?{priceRule}
    
    
    //MARK: - Retirve the Dfrat Order
    func retriveDraftOrder() -> DraftOrder? {
        return draftOrder
    }
    
    
    //MARK: Fetch Data Of price Rule ID
    func fetchDataOfPriceRule(priceRuleID:Int) {
        BaseUrl.priceRuleID = "\(priceRuleID)"
        print(BaseUrl.PriceRule.enpoint)
        apiManager.fetchData(url: BaseUrl.PriceRule, decodingModel: SinglePriceRule.self) {
            result in
            switch result{
            case .success(let priceRule):
                self.priceRule = priceRule.priceRules
            case .failure(let error):
                print(String(describing: error))
                
                
            }
        }
    }
    
    
    //MARK: - Check Copoun COde is Avalible or not
    func checkUsageOfCoponusAvaliable(Handel: @escaping (Bool) -> Void) {
        
        if let productRule = self.priceRule {
            
            if productRule.usageLimit < productRule.allocationLimit{
                
                Handel(true)
            }
            else{
                Handel(false)
            }
            
        }
        else{
            Handel(false)
        }
        
    }
    
    
    //MARK: - The Discount amount of Coupon
    func discountAmount() -> String? {
        if let dicountAmount = priceRule?.value , let totalAmount = Double(draftOrder?.totalPrice ?? "0.0"){
            if let numberAmount = Double(dicountAmount){
                let totalAmountOfDicount = (totalAmount * numberAmount)/100
                return String(format:"%.2f",totalAmountOfDicount)
            }
        }
        return nil
    }
    
    
    
    //MARK: - Amount After APplying The Coupons
    func returnAmountAfterDiscount(orderPrice: String?, dicountPrice: String?) -> String? {
        if let orderPrice = orderPrice?.components(separatedBy: "$") , let dicountPrice = dicountPrice?.components(separatedBy: "$"){
            if let actualOrderPrice = Double(orderPrice[1]) , let actualDiscountPrice = Double(dicountPrice[1]){
                let amount = actualOrderPrice + actualDiscountPrice
                
                return String(format: "%.2f", amount)
                
            }
            
        }
        return nil
    }
    
    
    
    
    //MARK: - update the Usage of the Copouns
    func updatePriceRuleLimit(priceRuleID:Int) {
        if let id = priceRule?.id ,var usageLimit = priceRule?.usageLimit {
            BaseUrl.priceRuleID  = "\(priceRuleID)"
            usageLimit = usageLimit + 1
            priceRule?.usageLimit = usageLimit
            
            let json: [String: Any] = [
                "price_rule": [
                    "id": id,
                    "usage_limit": usageLimit
                ]
            ]
            
            AF.request(BaseUrl.PriceRule.enpoint, method: .put, parameters: json,encoding: JSONEncoding.default ,headers: header).responseData { response in
                switch response.result {
                case .success(_ ):
                    print("Success")
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        }
    }
    
    
    //MARK: - Get Copones of Discount
    func getDiscountCopoune(Handel: @escaping ((Bool?,Error?) -> Void)) {
        
        if let copouneData = UserDefaults.standard.object(forKey: "Copone") as? Data {
            
            do{
                let actualCopone = try JSONDecoder().decode(DiscountCode.self, from: copouneData)
                self.discountCode = actualCopone
                Handel(true , nil)
                
            }catch let error{Handel(nil ,error)}
            
            
        }else{
            Handel(nil,UserDfaultError.dicountFail)
        }
        
    }
    
    
    //MARK: -  APPLy Amount of Discount to total amount
    
    func fetchOrderFromDraftOrder(){
        
        draftOrderservices.customerDraftOrder(customerID: custemerID) { result in
            switch result{
                
            case .success(let draftOrder):
                self.draftOrder = draftOrder
                print(draftOrder)
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    //MARK: - Apply Discount To Draft Order
    
    func applyDiscountToOrder(Handel:@escaping(Bool)->Void){
        
        
        if let percentDiscount = Double(priceRule?.value ?? "0.0") ,let valueTypeOfDiscount = priceRule?.valueType ,   let draftOrderID = draftOrder?.id {
            
            let actualnumber =  percentDiscount < 0 ? (percentDiscount * -1) : (percentDiscount * 1)
            
            BaseUrl.draftOrderID  = draftOrderID
    
            let json: [String: Any] = [
                "draft_order":
                    [
                        "applied_discount":
                            [
                                "value_type": valueTypeOfDiscount,
                                "value": String(actualnumber)
                            ] as [String : Any]
                    ]
            ]
            
            
            AF.request(BaseUrl.draftOrder.enpoint, method: .put, parameters: json,encoding: JSONEncoding.default ,headers: header).responseData { response in
                switch response.result {
                case .success(_):
                    Handel(true)
                case .failure(let error):
                    print(String(describing: error))
                        Handel(false)
                }
            }
        }
        
        
    }
    
    
    //MARK: - Remove Discount Code From UserDefaults
    func removeCopounsFromUserDefaults(){
        if let discountCode = self.discountCode{
            UserDefaults.standard.removeObject(forKey: K.dicountCopounKey)
        }
        
    }
    
    
    
}






