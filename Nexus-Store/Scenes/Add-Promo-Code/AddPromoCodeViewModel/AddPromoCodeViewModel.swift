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
    
    
}

class AddPromoCodeViewModel:AddPromoCodeProtocaol{
   
   
    
    var bindPriceRuleFromApi: (() -> Void)?
    
    private let header: HTTPHeaders = [
        "X-Shopify-Access-Token": "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",
        "Content-Type": "application/json"
    ]
    
    
    
    
    let apiManager = ApiManger.SharedApiManger
    
    var priceRule:PriceRule?{
        didSet{
            if let validPriceRule = bindPriceRuleFromApi{
                validPriceRule()
            }
        }
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
    
    
    //MARK: - Retrive Price Rule
    func retrivePriceRule() ->PriceRule?{priceRule}
    
    
    
    
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
        if let dicountAmount = priceRule?.value{
            if let numberAmount = Double(dicountAmount){
                return String(format:"%.2f",numberAmount)
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
    
    
  
    
    
}
