//
//  CategoryViewModel.swift
//  Nexus-Store
//
//  Created by Mustafa on 25/10/2023.
//

import Foundation


protocol CategoryViewModelDelgation:AnyObject{
    
    var fetchProductToCategoryView: (()->Void)? {get set}
    func getAllProduct(with endPoint:BaseUrl)
    func RetiviedProductResult()->[Product]?
    func RetiviedProductResultCount()->Int?
    func priceOfEveryProduct(for product:Product , Handeler: @escaping (Product) -> Void)
    func getSubCategoryData(for mainCategory:Int , with subCategory:String , Handeler: @escaping ([Product]) -> Void)
    
    
    
}
extension CategoryViewModelDelgation {
    func test() {
        
    }
}

class CategoryViewModel:CategoryViewModelDelgation{
  
    
    let apiNetworkManager = ApiManger.SharedApiManger
    var fetchProductToCategoryView: (() -> Void)?
    
    weak var delegate: CategoryViewModelDelgation?
    
    
    private (set) var products:[Product]? = []{
        didSet{
            if let validretrivedDataProduct = fetchProductToCategoryView{
                validretrivedDataProduct()
            }
        }
    }
 
    //MARK: - Get All Product filter to it's Category
    func getAllProduct(with endPoint:BaseUrl){
        apiNetworkManager.fetchData(url: endPoint , decodingModel: AllProduct.self) { result in
            switch result{
            case .success(let decodingModel):
                self.products = decodingModel.products
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Get price For Every Product
    func priceOfEveryProduct(for product:Product , Handeler: @escaping (Product) -> Void){
        BaseUrl.CategoryPriceID = product.id
          
        apiNetworkManager.fetchData(url: BaseUrl.CategoryProductPrice, decodingModel: SingleProduct.self) { result in
            switch result{
            case .success(let product):
                Handeler(product.product)
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }
    
    func getSubCategoryData(for mainCategory: Int, with subCategory: String, Handeler: @escaping ([Product]) -> Void) {
        BaseUrl.MainCategory = mainCategory
        BaseUrl.SubCategoryItem = subCategory
        print("SubCategory:\(BaseUrl.SubCategory.enpoint)")
        apiNetworkManager.fetchData(url: BaseUrl.SubCategory , decodingModel: AllProduct.self) { result in
            switch result{
            case .success(let decodingModel):
                Handeler(decodingModel.products)
            case .failure(let error):
                print("")
                print(error.localizedDescription)
            }
        }
    }
    
    
    func RetiviedProductResult() -> [Product]? {
        return products
    }
    
    func RetiviedProductResultCount() -> Int? {
        return products?.count
    }
    
    
    
    
    
}
