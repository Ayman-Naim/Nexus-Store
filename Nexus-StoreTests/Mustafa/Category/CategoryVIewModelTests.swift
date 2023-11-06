//
//  CategoryVIewModel.swift
//  Nexus-StoreTests
//
//  Created by Mustafa on 06/11/2023.
//

import XCTest

@testable import Nexus_Store
final class CategoryVIewModelTests: XCTestCase {
    
    
    var categoryViewModel = CategoryViewModuleRefactor()
    let apiNetworkManager = ApiManger.SharedApiManger
    var mainCategory = K.menID
    var subCategory = K.all
    var productId = 8031030378732
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testRetriveAllApiProduct(){
        
        
        let loadingAnimationExpectation = expectation(description: "Loading animation expectation")
        categoryViewModel.loadingAnimation = { isLoading in
            if isLoading {
                loadingAnimationExpectation.fulfill()
            }
        }
        
        categoryViewModel.getAllProduct(for:mainCategory )
        waitForExpectations(timeout: 1.0, handler: nil)
        

        
    }
    
    
    func testProductOfSubCategory(){
        let loadingAnimationExpectation = expectation(description: "Loading animation expectation")
        categoryViewModel.loadingAnimation = { isLoading in
            if isLoading {
                loadingAnimationExpectation.fulfill()
            }
        }
        
        categoryViewModel.getSubCategoryData(for: mainCategory, with: subCategory )
        waitForExpectations(timeout: 1.0, handler: nil)
        
        
    }
    
    
    func testpriceforEveryProduct(){
        
        let expectation = expectation(description: "Wait Data From Api")
        
        BaseUrl.CategoryPriceID = productId
        
        
        apiNetworkManager.fetchData(url: BaseUrl.CategoryProductPrice, decodingModel: SingleProduct.self) { result in
            switch result {
                
                
            case .success(let product):
                XCTAssertNotNil(product, "The VAlue Retived of ALL Product in certain Team")
                expectation.fulfill()
            case .failure(_):
                XCTFail("The is An Error in retrive Data of all product")
                expectation.fulfill()
                
            }
            
        }
        waitForExpectations(timeout: 5000)

    }
    
    
    func testNumberOfProduct() {
            let product1 = Product(id: 8031030378732)
        let product2 = Product(id:8031030575340)
        categoryViewModel.filterProduct = [product1, product2]

            let numberOfProduct = categoryViewModel.numberOfProduct

            XCTAssertEqual(numberOfProduct, 2)
        }
    
  
    
    func testNumberOfMainCategory() {
          let numberOfMainCategory = categoryViewModel.numberOfMainCategory

          XCTAssertEqual(numberOfMainCategory, 4)
      }

      func testNumberOfSubCategory() {
          let numberOfSubCategory = categoryViewModel.numberOfsubCategory
          XCTAssertEqual(numberOfSubCategory, 4)
      }
    
    func testCheckIsAllProductMainCategoryForAllProduct_withAllSubCategory() {
           let mainCategory = 1
           let subCategory = K.all

           categoryViewModel.CheckIsAllProductMainCategoryForAllProduct(for: mainCategory, with: subCategory)
          
           XCTAssertNotNil(categoryViewModel.filterProduct)
       }
   
  


}
