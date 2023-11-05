//
//  NetworkManger.swift
//  Nexus-Store
//
//  Created by ayman on 24/10/2023.
//

import Foundation
import Alamofire

class ApiManger {
    
    static let SharedApiManger = ApiManger()
    
    private  init(){}
    
    private let headerApi: HTTPHeaders = [
        "X-Shopify-Access-Token": "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",
        "Content-Type": "application/json"
    ]
    
    
    func fetchData<T: Decodable>(url: BaseUrl, decodingModel: T.Type, completion: @escaping (Result<T, Error>) -> Void) {

        AF.request(url.enpoint,headers: headerApi).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodedData):
                // print("DeBug: \(response)")
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
  
    func postData<T: Decodable>(url: BaseUrl, parameters: [String: Any],decodingModel: T.Type,completion: @escaping (Result<T,Error>) -> Void) {
        AF.request(url.enpoint, method: .post,parameters: parameters,encoding: JSONEncoding.default, headers: headerApi).validate(statusCode: 200 ..< 299).responseData { response in
                switch response.result {
                case .success(let data ):
                    do {
                        let result = try JSONDecoder().decode(decodingModel, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func Delete(url: BaseUrl,completion: @escaping (Result<Bool,Error>) -> Void) {
        AF.request(url.enpoint, method: .delete, headers: headerApi).validate(statusCode: 200 ..< 299).responseData { response in
                switch response.result {
                case .success(_):
                    completion(.success(true))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getCurrency() {
            guard let url = getCurrencyURL() else {return}
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    do{
                        let json = try JSONDecoder().decode(CurrencyModel.self, from: data)
                        DispatchQueue.main.async{
    //                        complition(json, nil)
                            print("success to get all brands")
                            self.setCurrency(currency: json.data.egp.value)
                        }
                    }catch let error{
                        DispatchQueue.main.async{
                            print(error)
    //                        complition(nil, error)
                        }
                    }
                }
                if let error = error{
                    print(error.localizedDescription)
                }
            }.resume()
        }
    
    func getCurrencyURL() -> URL?{
        return URL(string: "https://api.currencyapi.com/v3/latest?apikey=cur_live_7gaNSIC8bfKdN5yLRmUOgua1DkSXOGLgV71R6i83&currencies=EGP")
    }
    func setCurrency(currency: Double?){
        UserDefaults.standard.set(currency, forKey: "Currency")
    }
}
