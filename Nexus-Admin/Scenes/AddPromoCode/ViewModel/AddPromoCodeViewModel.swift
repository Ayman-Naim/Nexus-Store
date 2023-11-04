//
//  AddPromoCodeViewModel.swift
//  Nexus-Admin
//
//  Created by Khater on 04/11/2023.
//

import Foundation
import Alamofire


class AddPromoCodeViewModel {
    let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    func addPromoCode(discountTitle: String, promoCode: String, amount: String, type: Int, usageLimit: String, startAt: Date, endAt: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ssZ"
        let startAtString = formatter.string(from: startAt)
        let endAtString = formatter.string(from: endAt)
        
        let params: [String: Any] = [
            "price_rule": [
                "title": discountTitle,
                "value_type": DiscountType.allCases[0].rawValue,
                "starts_at": startAtString,
                "ends_at": endAtString,
                "value": "-" + amount,
                "usage_limit": usageLimit,
                
                "target_type": "line_item",
                "target_selection": "all",
                "allocation_method": "across",
                "customer_selection": "all",
                "once_per_customer": true
            ] as [String : Any]
        ]
        
        let url = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/price_rules.json"
        AF.request(url, method: .post, parameters: params, headers: header).responseDecodable(of: PriceRuleResponse.self) { response in
            switch response.result {
            case .success(let priceRuleResponse):
                print(priceRuleResponse)
                guard let priceRule = priceRuleResponse.singleResult else { return }
                self.addDiscountCodeToPriceRule(priceRuleID: priceRule.id, code: promoCode)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addDiscountCodeToPriceRule(priceRuleID id: Int, code: String) {
        let params = ["discount_code": ["code": code]]
        let url = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/price_rules/\(id)/discount_codes.json"
        AF.request(url, method: .post, parameters: params, headers: header).responseDecodable(of: DiscountCodeResponse.self) { response in
            switch response.result {
            case .success(let discountResponse):
                guard let discountCod = discountResponse.singleResult else { return }
                print(discountCod)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
