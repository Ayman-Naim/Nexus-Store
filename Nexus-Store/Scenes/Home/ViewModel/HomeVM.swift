//
//  HomeVM.swift
//  Nexus-Store
//
//  Created by ayman on 25/10/2023.
//

import Foundation
class HomeVM{
    var PriceRole:[PriceRuleElements]=[]
    var CoupusOFPriceRule:[[CoupounsCodes]] = []
    
    func getBrands(completion:@escaping (Result<[SmartCollection], Error>) -> Void){
        ApiManger.SharedApiManger.fetchData(url: .Brand, decodingModel: BrandsModel.self) { result in
            switch result{
            case .success(let data):
                completion(.success(data.smart_collections))
                
            case .failure(let error):
                completion(.failure(error))
            
                
        }
          
        }
        
    }
    init(){
        
        /*BaseUrl.CoupunsPriceRuleID = 1529293701356
        self.getCouponescodes { result in
            switch result{
            case .success(let data):
                print(data[0].code)
                
                
            case .failure(let error):
               print(error)
            }
        }*/
    }
    
    func getPriceRole(completion:@escaping (Result<[PriceRuleElements], Error>) -> Void){
        ApiManger.SharedApiManger.fetchData(url: .allpriceRole, decodingModel: PriceRuleModel.self) { result in
            switch result{
            case .success(let data):
                //print(data.price_rules)
                completion(.success(data.price_rules))
                
            case .failure(let error):
                completion(.failure(error))
            
                
        }
          
        }
        
    }
    
    func getCouponescodes(completion:@escaping (Result<[CoupounsCodes], Error>) -> Void){
        ApiManger.SharedApiManger.fetchData(url: .copounsOfPrieRule, decodingModel: CoupounsCodesModel.self) { result in
            switch result{
            case .success(let Coupouns):
               // print(Coupouns.discount_codes)
                completion(.success(Coupouns.discount_codes))
                
            case .failure(let error):
                completion(.failure(error))
            
                
        }
          
        }
        
    }
    
    func getPriceWithcoupouns(completion : @escaping (Bool) -> Void ){
        self.getPriceRole { result in
            switch result {
            case.success(let priceRules):
                self.PriceRole = priceRules
                for pricerule in self.PriceRole {
                    // print(pricerule.id)
                    BaseUrl.CoupunsPriceRuleID = pricerule.id
                    self.getCouponescodes { result2 in
                        switch result2{
                        case.success(let coupones):
                            
                            self.CoupusOFPriceRule.append(coupones)
                            //  print("Out of  \(pricerule.id):\(coupones)")
                        case.failure(let error ):
                            print(error )
                        }
                        
                    }
                }
                completion(true)
                
                //print(priceRules)
            case.failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    
    
    func getUserData()->Result<String,Error>{
       guard let contentData = UserDefaults.standard.string(forKey: "customerEmail") 
              else{ return(.failure(UserDfaultError.emptyUser)) }
        print(contentData)
        return(.success(contentData))
        

    }
    
    
    
}

enum UserDfaultError : Error{
case emptyUser
    
    
    var errorDescription :String{
        switch self{
        case.emptyUser : return "No User LogedIN"
        }
    }
}
