//
//  PromoCodesViewModel.swift
//  Nexus-Admin
//
//  Created by Khater on 03/11/2023.
//

import Foundation
import Alamofire


class PromoCodesViewModel {
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    private var priceRules: [PriceRule] = []
    private var discountCodes: [DiscountCode] = [] {
        didSet{
            DispatchQueue.main.async {
                self.reload?()
            }
        }
    }
    
    
    var reload: (() -> Void)?
    var errorAlert: ((_ title: String, _ message: String) -> Void)?
    
    
    
    var numberOfRows: Int { priceRules.count}
    
    func configPromoCode(_ cell: PromoCodeCell, at index: Int) {
        let priceRule = priceRules[index]
        cell.setTitle(priceRule.title)
        cell.setDiscount(priceRule.discountValue)
        cell.setStartDate(priceRule.startAt)
        cell.setEndDate(priceRule.endAt ?? "")
        cell.setUsageCount(String(priceRule.usageLimit ?? 0))
        if let discountCode = discountCodes.first(where: { $0.priceRuleID == priceRule.id }){
            cell.setPromoCode("#" + String(discountCode.code))
        } else {
            cell.setPromoCode("#")
        }
    }
    
    
    
    // MARK: - Network Functions
    func fetchPriceRules() {
        let url = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/price_rules.json"
        AF.request(url, method: .get, headers: header).responseDecodable(of: PriceRuleResponse.self) { response in
            switch response.result {
            case .success(let priceRuleResponse):
                guard let priceRules = priceRuleResponse.results else { return }
                self.priceRules = priceRules
                self.discountCodes = []
                for priceRule in priceRules {
                    self.fetchDiscoundCodeForPriceRule(id: priceRule.id)
                }
            case .failure(let error):
                self.errorAlert?("Price Rule", error.localizedDescription)
            }
        }
    }
    
    private func fetchDiscoundCodeForPriceRule(id priceRuleID: Int) {
        let url = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/price_rules/\(priceRuleID)/discount_codes.json"
        AF.request(url, method: .get, headers: header).responseDecodable(of: DiscountCodeResponse.self) { response in
            switch response.result {
            case .success(let discountCodes):
                if let discountCode = discountCodes.results?.first {
                    self.discountCodes.append(discountCode)
                }
            case .failure(let error):
                self.errorAlert?("Discount Code", error.localizedDescription)
            }
        }
    }
}
